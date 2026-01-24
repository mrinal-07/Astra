import numpy as np
from typing import Dict, Any, List

from . import pdf_loader
from . import chunker
from . import embedder
from .vector_store import VectorStore
from . import retriever
from . import answer_generator
from . import citation_builder

class KBService:
    def __init__(self):
        # The single stateful component
        self.vector_store = VectorStore()
        # Attempt to load existing index if available
        self.vector_store.load()

    def ingest_pdf(self, file_path: str) -> Dict[str, Any]:
        """
        Orchestrates the ingestion of a PDF file.
        
        1. Load PDF pages
        2. Chunk text
        3. Embed chunks
        4. Store in VectorStore
        """
        # 1. Load
        pages = pdf_loader.load_pdf(file_path)
        if not pages:
            return {"status": "error", "message": "No text extracted from PDF"}
            
        # 2. Chunk
        chunks = chunker.chunk_data(pages)
        if not chunks:
            return {"status": "error", "message": "No chunks created"}
            
        # 3. Embed
        # embedder.generate_embedding returns a 1D numpy array
        vectors_list = []
        for chunk in chunks:
            vec = embedder.generate_embedding(chunk["text"])
            vectors_list.append(vec)
            
        if not vectors_list:
             return {"status": "error", "message": "Embedding failed"}
             
        # Convert to numpy array of shape (n, dim)
        embeddings_matrix = np.vstack(vectors_list)
        
        # 4. Store
        self.vector_store.add_embeddings(embeddings_matrix, chunks)
        self.vector_store.save()
        
        return {
            "status": "success", 
            "chunks_count": len(chunks),
            "vectors_shape": str(embeddings_matrix.shape)
        }

    def query_kb(self, query: str) -> Dict[str, Any]:
        """
        Orchestrates the query process.
        
        1. Retrieve relevant chunks
        2. Generate answer
        3. Build citations
        4. Calculate confidence
        """
        # 1. Retrieve
        chunks = retriever.retrieve(query, self.vector_store, top_k=5)
        
        # 2. Answer
        answer = answer_generator.generate_answer(query, chunks)
        
        # 3. Citations
        citations = citation_builder.build_citations(chunks)
        
        # 4. Confidence Heuristic
        confidence = "Low"
        if answer != "Answer not found in the document." and chunks:
            # Check the score of the top chunk
            # Scores are cosine similarity (-1 to 1) after normalization
            top_score = chunks[0].get('score', 0.0)
            if top_score > 0.6:
                confidence = "High"
            elif top_score > 0.3:
                confidence = "Medium"
        elif not chunks:
            confidence = "N/A"
            
        return {
            "answer": answer,
            "citations": citations,
            "confidence": confidence
        }
