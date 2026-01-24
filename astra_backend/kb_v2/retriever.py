from typing import List, Dict, Any
from .embedder import generate_embedding
from .vector_store import VectorStore

def retrieve(query: str, vector_store: VectorStore, top_k: int = 5) -> List[Dict[str, Any]]:
    """
    Retrieves the most relevant chunks for a given query.
    
    Args:
        query (str): The user's query string.
        vector_store (VectorStore): The vector store instance to search in.
        top_k (int): Number of chunks to return.
        
    Returns:
        List[Dict[str, Any]]: List of retrieved chunks with metadata and scores.
    """
    if not query.strip():
        return []

    # 1. Generate embedding for the query
    query_embedding = generate_embedding(query)
    
    # 2. Search in the vector store
    results = vector_store.search(query_embedding, top_k=top_k)
    
    return results
