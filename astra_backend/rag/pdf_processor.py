import fitz  # PyMuPDF
import re

def extract_pdf_pages(pdf_path: str):
    """
    Return list of dicts: [{"page": 1, "text": "..."}]
    """
    doc = fitz.open(pdf_path)
    pages = []
    for i, page in enumerate(doc):
        try:
            text = page.get_text().strip()
            if not text:
                continue
            # Basic cleaning: collapse multiple whitespace
            text = re.sub(r'\s+', ' ', text).strip()
            # Remove page headers/footers that look like "Page X" or short lines
            lines = [ln.strip() for ln in text.split('\n') if ln.strip()]
            cleaned = []
            for ln in lines:
                if len(ln) < 5:
                    continue
                if re.match(r'^(page\s*\d+|contents|table of contents)$', ln.lower()):
                    continue
                cleaned.append(ln)
            page_text = ' '.join(cleaned).strip()
            if page_text:
                pages.append({"page": i + 1, "text": page_text})
        except Exception:
            continue
    doc.close()
    return pages
