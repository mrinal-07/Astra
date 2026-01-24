from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from .online_chat_service import process_online_message

router = APIRouter(prefix="/astra", tags=["Astra Online Chat"])

class OnlineChatRequest(BaseModel):
    message: str

class OnlineChatResponse(BaseModel):
    response: str

@router.post("/online_chat", response_model=OnlineChatResponse)
async def online_chat(request: OnlineChatRequest):
    """
    Online chat endpoint that connects to Gemini with safety redirects.
    """
    if not request.message.strip():
        return OnlineChatResponse(response="I'm here to chat! What's on your mind?")
        
    try:
        response_text = process_online_message(request.message)
        return OnlineChatResponse(response=response_text)
    except Exception as e:
        # Graceful fallback for API issues
        return OnlineChatResponse(
            response=f"I'm having a little trouble connecting to my brain right now. Please try again in a moment! (Error: {str(e)})"
        )
