import re
from .llm_phi3 import ask_phi3
from .embedder import embed_text
import numpy as np
import requests
import json


# small helper to split into sentences
def _split_sentences(text: str):
    text = text.replace("\n", " ").strip()
    # naive split, keep punctuation
    sents = re.split(r'(?<=[.!?])\s+', text)
    cleaned = [s.strip() for s in sents if len(s.strip()) > 20]
    return cleaned

def _cosine(a: np.ndarray, b: np.ndarray):
    if np.linalg.norm(a) == 0 or np.linalg.norm(b) == 0:
        return 0.0
    return float(np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b)))

def semantic_sentence_rank(retrieved_chunks, query, top_k=4):
    """
    For each retrieved chunk, split into sentences and rank them by semantic similarity to query.
    Return selected sentences (dicts with sentence, doc, page).
    """
    candidates = []
    for c in retrieved_chunks:
        text = c.get("text") or c.get("chunk_text") or c.get("text", "")
        doc = c.get("doc", "unknown")
        page = c.get("page", -1)
        for s in _split_sentences(text):
            candidates.append({"sentence": s, "doc": doc, "page": page})

    if not candidates:
        return []

    # embed query + sentences
    texts = [query] + [c["sentence"] for c in candidates]
    embs = embed_text(texts)
    q_emb = embs[0]
    sent_embs = embs[1:]

    scores = []
    for i, emb in enumerate(sent_embs):
        scores.append((_cosine(q_emb, emb), i))

    scores.sort(key=lambda x: x[0], reverse=True)
    selected = []
    seen = set()
    for score, idx in scores:
        if len(selected) >= top_k:
            break
        s = candidates[idx]["sentence"]
        key = s[:120].lower()
        if key in seen:
            continue
        selected.append({
            "sentence": s,
            "doc": candidates[idx]["doc"],
            "page": candidates[idx]["page"],
            "score": float(score)
        })
        seen.add(key)
    return selected

def build_context_text(selected_sentences):
    # join with separators
    blocks = []
    for s in selected_sentences:
        blocks.append(f"{s['sentence']}\n\n(Source: {s['doc']} - page {s['page']})")
    return "\n\n".join(blocks)

def build_prompt(query, context_text):
    return f"""
You are Astra — an offline assistant. Answer using ONLY the context provided below.
RULES:
- Use only the context.
- If the context does not contain information to answer, say exactly: "Not found in the knowledge base."
- Do not add information beyond the context.
- Keep the answer concise and bullet/paragraph form as appropriate.

Context:
{context_text}

Question:
{query}

Answer:
"""

def llm_grounded_answer(question, chunks):
    context_text = "\n\n".join([f"[{i}] (Doc: {c['doc']} • Page: {c['page']})\n{c['text']}"
                                for i, c in enumerate(chunks)])

    prompt = f"""
Use ONLY the information provided below to answer the question.
If you use a specific chunk, cite it using [index].

Question: {question}

Context:
{context_text}

Answer with citations:
"""

    response = requests.post(
        "http://localhost:11434/api/generate",
        json={
            "model": "phi3",
            "prompt": prompt,
            "stream": False
        }
    )

    data = response.json()
    answer = data.get("response", "")

    # Build citation list
    citations = [{
        "index": i,
        "doc": c["doc"],
        "page": c["page"]
    } for i, c in enumerate(chunks)]

    return {
        "answer": answer,
        "citations": citations
    }

