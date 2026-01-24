from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from .chat_service import process_user_message

router = APIRouter(prefix="/astra", tags=["Astra Chat"])

class ChatRequest(BaseModel):
    message: str

class ChatResponse(BaseModel):
    response: str

@router.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    """
    Deterministic endpoint for Astra Helper Bot.
    """
    if not request.message.strip():
        return ChatResponse(response="Please say something!")
        
    response_text = process_user_message(request.message)
    return ChatResponse(response=response_text)
