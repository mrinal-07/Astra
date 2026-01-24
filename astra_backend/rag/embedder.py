from sentence_transformers import SentenceTransformer
import numpy as np

# dimension is model-dependent; all-MiniLM-L6-v2 has dim 384
MODEL_NAME = "sentence-transformers/all-MiniLM-L6-v2"

# instantiate once globally
_model = None

def get_model():
    global _model
    if _model is None:
        _model = SentenceTransformer(MODEL_NAME)
    return _model

def embed_text(texts):
    """
    texts: list[str]
    returns numpy array shape (n, dim)
    """
    model = get_model()
    embs = model.encode(texts, convert_to_numpy=True, show_progress_bar=False)
    return embs  # numpy array
