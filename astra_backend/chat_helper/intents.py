from typing import Dict

def classify_intent(message: str) -> str:
    """
    Classifies the user message into a simple set of intents using keyword matching.
    
    Intents:
    - greeting: Simple salutations.
    - help: Asking for capabilities or guidance.
    - tool_query: Asking about specific tools (Math, PDF, Dictionary, etc.).
    - misuse: Inappropriate or hostile language.
    - unknown: Everything else.
    """
    msg_lower = message.lower().strip()
    
    # 1. Misuse / Safety
    misuse_keywords = ["idiot", "stupid", "dumb", "hate", "kill", "shut up", "useless"]
    if any(k in msg_lower for k in misuse_keywords):
        return "misuse"

    # 2. Greeting
    greeting_keywords = ["hello", "hi", "hey", "good morning", "good evening", "astra"]
    # Exact match or starts with greetings for better accuracy
    if any(msg_lower.startswith(k) or msg_lower == k for k in greeting_keywords):
        return "greeting"

    # 3. Help
    help_keywords = ["help", "what can you do", "capabilities", "features", "how to use", "guide", "manual", "support"]
    if any(k in msg_lower for k in help_keywords):
        return "help"

    # 4. Tool Queries
    # We check for tool-specific keywords to guide the user
    tool_keywords = [
        "math", "calculate", "solve", "equation",  # Math
        "pdf", "document", "upload", "knowledge", "search file", # PDF/KB
        "define", "meaning", "definition", "dictionary", # Dictionary
        "summarize", "summary", "tl;dr", # Summarizer
        "email", "write a mail", "compose" # Email
    ]
    if any(k in msg_lower for k in tool_keywords):
        return "tool_query"

    return "unknown"
