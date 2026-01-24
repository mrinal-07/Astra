import faiss
import numpy as np
import pickle
import os
from typing import List, Dict, Any

class VectorStore:
    def __init__(self, dimension: int = 384, storage_path: str = "kb_v2_store.pkl"):
        self.dimension = dimension
        self.storage_path = storage_path
        # IndexFlatIP calculates inner product, which is equivalent to cosine similarity
        # IF vectors are normalized.
        self.index = faiss.IndexFlatIP(dimension)
        self.metadata: List[Dict[str, Any]] = []

    def add_embeddings(self, embeddings: np.ndarray, metadata: List[Dict[str, Any]]):
        """
        Adds embeddings and corresponding metadata to the store.
        Args:
            embeddings (np.ndarray): Shape (n, dimension)
            metadata (List[Dict]): List of length n
        """
        if len(metadata) != embeddings.shape[0]:
            raise ValueError("Metadata count must match embedding count")

        # Normalize for cosine similarity
        faiss.normalize_L2(embeddings)
        
        self.index.add(embeddings)
        self.metadata.extend(metadata)
        
    def search(self, query_embedding: np.ndarray, top_k: int = 5) -> List[Dict[str, Any]]:
        """
        Searches for the top_k most similar chunks.
        Args:
            query_embedding (np.ndarray): Shape (dimension,) or (1, dimension)
            top_k (int): Number of results to return
            
        Returns:
            List[Dict]: List of metadata dicts with added 'score' key
        """
        if self.index.ntotal == 0:
            return []

        # Ensure query is 2D and normalized
        if query_embedding.ndim == 1:
            query_embedding = query_embedding.reshape(1, -1)
            
        faiss.normalize_L2(query_embedding)
        
        distances, indices = self.index.search(query_embedding, top_k)
        
        results = []
        # indices[0] because we only searched for 1 query vector
        for i, idx in enumerate(indices[0]):
            if idx == -1:
                continue
            
            meta = self.metadata[idx].copy()
            meta['score'] = float(distances[0][i])
            results.append(meta)
            
        return results

    def save(self):
        """Saves current index and metadata to disk."""
        # For simplicity, pickling the whole state including the simple FAISS index
        # For production with huge indexes, save the FAISS index separately.
        # But `faiss` objects can't always be pickled directly in older versions?
        # Standard way:
        # faiss.write_index(self.index, "index_file")
        # pickle metadata.
        # Here we'll do a simple dictionary dump if possible, or robust standard way.
        
        # Local simplistic storage
        base_dir = os.path.dirname(os.path.abspath(__file__))
        save_path = os.path.join(base_dir, self.storage_path)
        
        # We need to serialize the index separately usually, 
        # but let's try a hybrid structure.
        
        # 1. Save FAISS index
        index_file = save_path + ".index"
        faiss.write_index(self.index, index_file)
        
        # 2. Save Metadata
        meta_file = save_path + ".meta"
        with open(meta_file, 'wb') as f:
            pickle.dump(self.metadata, f)
            
    def load(self):
        """Loads index and metadata from disk."""
        base_dir = os.path.dirname(os.path.abspath(__file__))
        save_path = os.path.join(base_dir, self.storage_path)
        index_file = save_path + ".index"
        meta_file = save_path + ".meta"
        
        if os.path.exists(index_file) and os.path.exists(meta_file):
            self.index = faiss.read_index(index_file)
            with open(meta_file, 'rb') as f:
                self.metadata = pickle.load(f)
