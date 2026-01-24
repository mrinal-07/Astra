import fitz  # PyMuPDF
from typing import List, Dict, Any

def load_pdf(file_path: str) -> List[Dict[str, Any]]:
    """
    Loads a PDF file and extracts text page by page.
    
    Args:
        file_path (str): The absolute path to the PDF file.
        
    Returns:
        List[Dict[str, Any]]: A list of dictionaries containing 'text' and 'page'.
    """
    doc = fitz.open(file_path)
    pages = []
    
    for page_num, page in enumerate(doc):
        text = page.get_text()
        if text.strip():  # Only add pages with text
            pages.append({
                "text": text,
                "page": page_num + 1  # 1-based indexing for display
            })
            
    doc.close()
    return pages
