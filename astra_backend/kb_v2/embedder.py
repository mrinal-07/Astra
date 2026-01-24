from sentence_transformers import SentenceTransformer
import numpy as np

# Use the same model as the rest of the project for consistency
MODEL_NAME = "sentence-transformers/all-MiniLM-L6-v2"
_model = None

def get_model() -> SentenceTransformer:
    global _model
    if _model is None:
        _model = SentenceTransformer(MODEL_NAME)
    return _model

def generate_embedding(text: str) -> np.ndarray:
    """
    Generates an embedding vector for a single text string.
    
    Args:
        text (str): The input text.
        
    Returns:
        np.ndarray: The embedding vector.
    """
    model = get_model()
    # encode returns an array (or list of arrays)
    # Since input is a single string, output is a single 1D array
    embedding = model.encode(text, convert_to_numpy=True, show_progress_bar=False)
    return embedding
