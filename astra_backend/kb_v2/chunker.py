import uuid
from typing import List, Dict, Any

# Approximation: 1 token ~= 4 chars, or roughly 0.75 words.
# We will use words for splitting to avoid breaking words.
# 400 tokens ~= 300 words
# 600 tokens ~= 450 words
# 50 tokens overlap ~= 40 words

CHUNK_SIZE_WORDS = 400  # Approx 500-550 tokens
OVERLAP_WORDS = 50      # Approx 60-70 tokens

def chunk_data(pages: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    """
    Splits text from pages into overlapping chunks.
    
    Args:
        pages (List[Dict[str, Any]]): List of dicts with keys 'text' and 'page'.
        
    Returns:
        List[Dict[str, Any]]: List of chunks with 'chunk_id', 'text', 'page'.
    """
    chunks_list = []
    
    for entry in pages:
        text = entry.get("text", "")
        page_num = entry.get("page", 0)
        
        # Simple whitespace splitting (approximation for tokens)
        words = text.split()
        if not words:
            continue
            
        i = 0
        while i < len(words):
            # Define chunk end
            end = min(i + CHUNK_SIZE_WORDS, len(words))
            
            # Create chunk text
            chunk_words = words[i:end]
            chunk_text = " ".join(chunk_words)
            
            # Create chunk object
            chunks_list.append({
                "chunk_id": str(uuid.uuid4()),
                "text": chunk_text,
                "page": page_num
            })
            
            # Move index forward, respecting overlap
            # If we reached the end, break
            if end == len(words):
                break
                
            i += (CHUNK_SIZE_WORDS - OVERLAP_WORDS)
            
    return chunks_list
