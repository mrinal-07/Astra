from typing import Optional

def check_blockable_intent(message: str) -> Optional[str]:
    """
    Checks if the user message matches any tool-specific intent that should be
    handled by dedicated tools rather than the online chat.
    
    Returns:
        str: A redirect message if blocked.
        None: If the message is allowed (not a tool-specific query).
    """
    msg_lower = message.lower().strip()
    
    # 1. PDF / Knowledge Base
    if any(k in msg_lower for k in ["pdf", "upload document", "search file", "knowledge base","pdf", "document", "page", "uploaded file", "my file",
    "knowledge base", "from my document"]):
        return "I can help with that, but please use the **Knowledge Base** tool for managing and querying PDF documents."

    # 2. Math
    if any(k in msg_lower for k in ["calculate", "solve", "equation", "math", "sqrt", "algebra"]):
        # Simple heuristic to avoid blocking simple overlapping words, but sufficient for now
        return "For calculations, please use the **Math Solver** tool. It's optimized for accuracy!"

    # 3. Summarizer
    if any(k in msg_lower for k in ["summarize", "summary", "tl;dr", "shorten text","summarize text", "summarize document", "summarize file","summarize", "summary", "tl;dr", "shorten", "brief this"]):
        return "To summarize text, please go to the **Summarizer** tool."

    # 4. Email
    if any(k in msg_lower for k in ["write email", "compose mail", "draft email", "email to"]):
        return "I can draft emails better in the dedicated **Email Writer** tool."

    # 5. Dictionary
    if any(k in msg_lower for k in ["define", "definition of", "meaning of word", "dictionary"]):
        return "Looking for a definition? Check out the **Dictionary** tool."

    return None
