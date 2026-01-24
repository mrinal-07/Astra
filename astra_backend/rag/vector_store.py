import os
import json
import faiss
import numpy as np

RAG_DIR = os.path.join(os.path.dirname(__file__), "..", "rag")
RAG_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__)))
FAISS_PATH = os.path.join(RAG_DIR, "store.faiss")
META_PATH = os.path.join(RAG_DIR, "metadata.json")

EMB_DIM = 384  # matches all-MiniLM-L6-v2

def ensure_metadata_file():
    if not os.path.exists(META_PATH):
        with open(META_PATH, "w", encoding="utf-8") as f:
            json.dump([], f)

def load_metadata():
    ensure_metadata_file()
    with open(META_PATH, "r", encoding="utf-8") as f:
        try:
            data = json.load(f)
            if not isinstance(data, list):
                return []
            return data
        except Exception:
            return []

def save_metadata(metadata):
    with open(META_PATH, "w", encoding="utf-8") as f:
        json.dump(metadata, f, indent=2, ensure_ascii=False)

def faiss_index_exists():
    return os.path.exists(FAISS_PATH) and os.path.getsize(FAISS_PATH) > 0

def create_empty_index(dim=EMB_DIM):
    # Flat L2 index
    return faiss.IndexFlatL2(dim)

def load_faiss(dim=EMB_DIM):
    # try to load an index; if missing/corrupt, return empty index
    try:
        if faiss_index_exists():
            idx = faiss.read_index(FAISS_PATH)
            return idx
    except Exception:
        # corrupted index; ignore and create new
        try:
            os.remove(FAISS_PATH)
        except Exception:
            pass
    return create_empty_index(dim)

def save_faiss(index):
    # ensure dir exists
    idx_dir = os.path.dirname(FAISS_PATH)
    if not os.path.exists(idx_dir):
        os.makedirs(idx_dir, exist_ok=True)
    faiss.write_index(index, FAISS_PATH)
