from .intent_firewall import check_blockable_intent
from .gemini_client import call_gemini

def process_online_message(message: str) -> str:
    """
    Orchestrates the online chat flow:
    1. Check firewall for tool-specific intents.
    2. If blocked, return redirect message.
    3. If allowed, call Gemini Pro.
    """
    # 1. Firewall Check
    redirect_msg = check_blockable_intent(message)
    if redirect_msg:
        return redirect_msg

    # 2. Call LLM
    return call_gemini(message)
