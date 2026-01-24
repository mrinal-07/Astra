from .vector_store import load_faiss, load_metadata, EMB_DIM
from .embedder import embed_text
import numpy as np

def retrieve_chunks(query: str, top_k: int = 6):
    """
    Returns list of metadata dicts with keys: 'doc','page','text'
    """
    metadata = load_metadata()
    if not metadata:
        return []

    index = load_faiss(EMB_DIM)
    # embed query
    q_emb = embed_text([query])  # shape (1, dim)
    try:
        D, I = index.search(q_emb, top_k)
    except Exception:
        # if index empty or other, return empty
        return []

    results = []
    for dist, idx in zip(D[0], I[0]):
        if idx == -1 or idx >= len(metadata):
            continue
        item = metadata[idx].copy()
        # Add score (convert L2 distance -> similarity approx)
        item["score"] = float(dist)
        results.append(item)
    return results
