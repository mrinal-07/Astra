import os
import shutil
from fastapi import APIRouter, UploadFile, File, HTTPException
from pydantic import BaseModel
from typing import Dict, Any

from .kb_service import KBService

# Create router (can be included in main.py)
router = APIRouter(prefix="/kb", tags=["Knowledge Base V2"])

# Instantiate service globally for the module
kb_service = KBService()

# Directory for v2 uploads
UPLOAD_DIR = os.path.join(os.path.dirname(__file__), "uploads")
os.makedirs(UPLOAD_DIR, exist_ok=True)

class QueryRequest(BaseModel):
    query: str

@router.post("/upload")
async def upload_pdf(file: UploadFile = File(...)) -> Dict[str, Any]:
    """
    Accepts a PDF upload, saves it, and ingests it into the KB.
    """
    if not file.filename.lower().endswith(".pdf"):
        raise HTTPException(status_code=400, detail="Only PDF files are allowed.")
        
    file_path = os.path.join(UPLOAD_DIR, file.filename)
    
    try:
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to save file: {str(e)}")
        
    # Ingest
    try:
        result = kb_service.ingest_pdf(file_path)
        if result.get("status") == "error":
            raise HTTPException(status_code=500, detail=result.get("message"))
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Ingestion failed: {str(e)}")

@router.post("/query")
async def query_kb(request: QueryRequest) -> Dict[str, Any]:
    """
    Accepts a query string and returns an answer with citations.
    """
    if not request.query.strip():
        raise HTTPException(status_code=400, detail="Query cannot be empty.")
        
    try:
        result = kb_service.query_kb(request.query)
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Query failed: {str(e)}")
