def chunk_text(text: str, chunk_size: int = 900, overlap: int = 150):
    """
    Return list of chunk strings.
    """
    if not text:
        return []
    text_len = len(text)
    start = 0
    chunks = []
    while start < text_len:
        end = min(start + chunk_size, text_len)
        chunk = text[start:end].strip()
        if chunk:
            chunks.append(chunk)
        start += chunk_size - overlap
    return chunks
