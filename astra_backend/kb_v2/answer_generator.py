import requests
from typing import List, Dict, Any

def generate_answer(query: str, chunks: List[Dict[str, Any]]) -> str:
    """
    Generates an answer using an LLM based on retrieved chunks.
    
    Args:
        query (str): The user query.
        chunks (List[Dict]): List of retrieved chunks.
        
    Returns:
        str: The generated answer or "Answer not found in the document."
    """
    if not chunks:
        return "Answer not found in the document."

    # Build context string
    context_text = "\n\n".join([
        f"--- Chunk {i} ---\n{c.get('text', '')[:1000]}"
        for i, c in enumerate(chunks[:3])
    ])

    # Strict prompt to prevent hallucination
    prompt = f"""
You are an AI assistant that answers questions based ONLY on the provided text chunks.
Do NOT use outside knowledge.
If the answer is not explicitly contained in the chunks below, you MUST say exactly: "Answer not found in the document."

Context Chunks:
{context_text}

User Question:
{query}

Answer:
"""

    try:
        response = requests.post(
            "http://127.0.0.1:11434/api/generate",
            json={
                "model": "phi3",
                "prompt": prompt,
                "stream": False,
                # Low temperature for more deterministic/strict answers
                "options": {
                    "temperature": 0.1
                }
            },
            timeout=120  # Good practice to have a timeout
        )
        
        if response.status_code == 200:
            result = response.json().get("response", "").strip()
            # If the model returns nothing or empty, assume not found
            if not result:
                return "Answer not found in the document."
            return result
        else:
            return f"Error: LLM returned status code {response.status_code}"

    except Exception as e:
        return f"Error connecting to LLM: {str(e)}"
