import os
from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import requests
from rag.pdf_processor import extract_pdf_pages
from rag.chunker import chunk_text
from rag.embedder import embed_text
from rag.vector_store import (
    load_faiss, save_faiss, load_metadata, save_metadata,
    EMB_DIM, ensure_metadata_file
)
from rag.retriever import retrieve_chunks
from rag.answer_builder import llm_grounded_answer
from math_tool.solver import solve_math_expression
from kb_v2.api import router as kb_router
from chat_helper.api import router as astra_router
from chat_online.api import router as astra_online_router
from dotenv import load_dotenv
from database import init_db
from auth.api import router as auth_router
from todo.api import router as todo_router
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
load_dotenv()
init_db()  # Initialize SQLite tables


app = FastAPI(title="Astra RAG Backend")

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # allow Flutter Windows
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include KB V2 Router
app.include_router(kb_router)

app.include_router(astra_router)

app.include_router(astra_online_router)

app.include_router(auth_router)
app.include_router(todo_router)

# Upload directory
UPLOAD_DIR = os.path.join(os.path.dirname(__file__), "uploads")
os.makedirs(UPLOAD_DIR, exist_ok=True)

# Ensure metadata file exists
ensure_metadata_file()

# ------------------------------------------------------------------------------
#                               PDF UPLOAD & INDEX
# ------------------------------------------------------------------------------
@app.post("/upload_pdf")
async def upload_pdf(file: UploadFile = File(...)):
    if not file.filename.lower().endswith(".pdf"):
        raise HTTPException(status_code=400, detail="Only PDF allowed")

    file_path = os.path.join(UPLOAD_DIR, file.filename)

    with open(file_path, "wb") as f:
        f.write(await file.read())

    pages = extract_pdf_pages(file_path)
    if not pages:
        return {"status": "No text extracted from PDF."}

    metadata = load_metadata()
    faiss_index = load_faiss(EMB_DIM)

    texts = []
    meta_entries = []

    for p in pages:
        for chunk in chunk_text(p["text"]):
            texts.append(chunk)
            meta_entries.append({
                "doc": file.filename,
                "page": p["page"],
                "text": chunk
            })

    if texts:
        embeddings = embed_text(texts)

        try:
            faiss_index.add(embeddings)
        except Exception:
            faiss_index = load_faiss(EMB_DIM)
            faiss_index.add(embeddings)

        metadata.extend(meta_entries)
        save_faiss(faiss_index)
        save_metadata(metadata)

    return {
        "status": "PDF indexed successfully.",
        "file": file.filename,
        "chunks_added": len(texts)
    }


# ------------------------------------------------------------------------------
#                               KNOWLEDGE BASE QUERY (JSON MODE)
# ------------------------------------------------------------------------------
class KBQuery(BaseModel):
    query: str

@app.post("/query_kb")
async def query_kb(data: KBQuery):
    query = data.query.strip()

    if not query:
        return {"answer": "No query provided.", "citations": []}

    chunks = retrieve_chunks(query, top_k=8)

    if not chunks:
        return {"answer": "No relevant information found.", "citations": []}

    result = llm_grounded_answer(query, chunks)
    return result


@app.get("/list_docs")
async def list_docs():
    files = [f for f in os.listdir(UPLOAD_DIR) if f.lower().endswith(".pdf")]
    return {"docs": files}


@app.post("/delete_doc")
async def delete_doc(filename: str = Form(...)):
    from rag.vector_store import FAISS_PATH, create_empty_index

    file_path = os.path.join(UPLOAD_DIR, filename)
    if os.path.exists(file_path):
        os.remove(file_path)

    # Rebuild the entire index
    try:
        if os.path.exists(FAISS_PATH):
            os.remove(FAISS_PATH)
    except:
        pass

    save_metadata([])
    metadata = []
    faiss_index = create_empty_index(EMB_DIM)

    for f in os.listdir(UPLOAD_DIR):
        if not f.endswith(".pdf"):
            continue

        path = os.path.join(UPLOAD_DIR, f)
        pages = extract_pdf_pages(path)

        texts = []
        meta_entries = []

        for p in pages:
            for chunk in chunk_text(p["text"]):
                texts.append(chunk)
                meta_entries.append({"doc": f, "page": p["page"], "text": chunk})

        if texts:
            embeddings = embed_text(texts)
            faiss_index.add(embeddings)
            metadata.extend(meta_entries)

    save_faiss(faiss_index)
    save_metadata(metadata)

    return {"status": "deleted and reindexed"}


# ------------------------------------------------------------------------------
#                               MATH SOLVER
# ------------------------------------------------------------------------------
@app.post("/solve_math")
async def solve_math(data: dict):
    expr = data.get("expression", "")
    if not expr:
        return {"error": "No expression provided"}

    result = solve_math_expression(expr)
    return {"expression": expr, "result": result}


# ------------------------------------------------------------------------------
#                               DICTIONARY
# ------------------------------------------------------------------------------
@app.get("/dictionary/{word}")
def get_dictionary(word: str):
    url = f"https://api.dictionaryapi.dev/api/v2/entries/en/{word}"
    response = requests.get(url, verify=False)

    if response.status_code != 200:
        return {
            "word": word,
            "meaning": "No definition found.",
            "phonetics": "",
            "example": ""
        }

    data = response.json()[0]
    meaning = data["meanings"][0]["definitions"][0].get("definition", "")
    example = data["meanings"][0]["definitions"][0].get("example", "")
    phonetics = data.get("phonetics", [{}])[0].get("text", "")

    return {
        "word": word,
        "meaning": meaning,
        "phonetics": phonetics,
        "example": example
    }


# ------------------------------------------------------------------------------
#                               SUMMARIZER (OLLAMA)
# ------------------------------------------------------------------------------
class TextInput(BaseModel):
    text: str

@app.post("/summarize")
def summarize_text(input_data: TextInput):
    prompt = f"""
Summarize this text into 3–4 clear, compact sentences.

TEXT:
{input_data.text}
"""

    try:
        response = requests.post(
            "http://localhost:11434/api/generate",
            json={
                "model": "phi3",
                "prompt": prompt,
                "stream": False,
            },
            verify=False
        )

        summary = response.json().get("response", "").strip()

        if not summary:
            return {"summary": "No summary generated."}

        return {"summary": summary}

    except Exception as e:
        return {"summary": f"Error connecting to Ollama: {str(e)}"}


# ------------------------------------------------------------------------------
#                               CHAT WITH CITATIONS
# ------------------------------------------------------------------------------
class ChatInput(BaseModel):
    message: str

@app.post("/chat")
def chat_endpoint(input_data: ChatInput):
    question = input_data.message.strip()

    if not question:
        return {"response": "Please enter a question.", "citations": []}

    chunks = retrieve_chunks(question, top_k=5)

    context_text = ""
    if chunks:
        context_text = "\n\n".join(
            [f"[{i}] (Doc: {c['doc']} — Page {c['page']})\n{c['text']}"
             for i, c in enumerate(chunks)]
        )

    prompt = f"""
You are Astra, an offline AI assistant.
Use context only if it is relevant. Cite used chunks using [index].

User question:
{question}

Context:
{context_text}

Answer clearly. Include citations at the end.
"""

    try:
        response = requests.post(
            "http://localhost:11434/api/generate",
            json={"model": "phi3", "prompt": prompt, "stream": False}
        )

        result = response.json().get("response", "").strip()

        citations = [
            {"index": i, "doc": c["doc"], "page": c["page"]}
            for i, c in enumerate(chunks)
        ]

        return {
            "response": result if result else "I couldn't generate an answer.",
            "citations": citations
        }

    except Exception as e:
        return {"response": f"Error contacting Ollama: {str(e)}", "citations": []}


# ------------------------------------------------------------------------------
#                               EMAIL GENERATOR
# ------------------------------------------------------------------------------
class EmailInput(BaseModel):
    prompt: str

@app.post("/email")
def generate_email(input_data: EmailInput):
    instruction = input_data.prompt

    full_prompt = f"""
Write a clean, professional email based on this instruction:

{instruction}

Email:
"""

    try:
        response = requests.post(
            "http://localhost:11434/api/generate",
            json={"model": "phi3", "prompt": full_prompt, "stream": False}
        )

        email_text = response.json().get("response", "").strip()
        return {"email": email_text}

    except Exception as e:
        return {"email": f"Error contacting model: {str(e)}"}
