from typing import List, Dict, Any

def build_citations(chunks: List[Dict[str, Any]]) -> List[str]:
    """
    Extracts unique page numbers from chunks and formats them as citations.
    
    Args:
        chunks (List[Dict[str, Any]]): List of chunk dictionaries containing 'page' key.
        
    Returns:
        List[str]: Sorted list of unique citation strings, e.g. ["Page 1", "Page 3"].
    """
    if not chunks:
        return []

    # Use a set to collect unique page numbers
    pages = set()
    for chunk in chunks:
        # Safeguard against missing key or None
        p = chunk.get("page")
        if p is not None:
            pages.add(p)
            
    # Sort pages to keep deterministic order
    sorted_pages = sorted(list(pages))
    
    # Format
    citations = [f"Page {p}" for p in sorted_pages]
    
    return citations
