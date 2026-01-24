from .intents import classify_intent
from .responses import get_response

def process_user_message(message: str) -> str:
    """
    Orchestrates the deterministic chat flow.
    1. Classify intent
    2. Get appropriate response
    """
    intent = classify_intent(message)
    response = get_response(intent, message)
    return response
