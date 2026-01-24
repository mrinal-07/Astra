from typing import Dict

# Predefined templates
TEMPLATES = {
    "greeting": "Hello! I am Astra. I'm here to help you get the most out of your tools.",
    "help": "I can guide you through using the Knowledge Base (PDFs), Math Solver, Dictionary, Summarizer, and Email Writer.",
    "misuse": "I cannot engage with that content. Let's focus on your tasks.",
    "unknown": "I'm designed to help you use Astra's features. Try asking 'How do I use the PDF tool?' or 'What tools do I have?'"
}

TOOL_GUIDES = {
    "pdf": "1. Go to **Knowledge Base**.\n2. Upload a PDF.\n3. Ask questions to get answers with citations.",
    "knowledge": "1. Go to **Knowledge Base**.\n2. Upload a PDF.\n3. Ask questions to get answers with citations.",
    "math": "Use the **Math Solver** to calculate expressions like `2 + 2` or `sqrt(144)`. Just type your equation there.",
    "dictionary": "Use the **Dictionary** tool to find definitions and phonetics. Just enter a word to look it up.",
    "summary": "Paste any long text into the **Summarizer** to get a quick, 3-sentence overview.",
    "summarize": "Paste any long text into the **Summarizer** to get a quick, 3-sentence overview.",
    "email": "Use the **Email Writer** to draft professional emails. Just describe who it's for and what you want to say.",
}

def get_response(intent: str, message: str = "") -> str:
    """
    Returns the appropriate response based on intent.
    If intent is 'tool_query', it checks the message to give specific tool guidance.
    """
    if intent == "tool_query":
        msg_lower = message.lower()
        # Find the specific tool mentioned
        for keyword, guide in TOOL_GUIDES.items():
            if keyword in msg_lower:
                return guide
        return "Which tool do you need help with? I know about Knowledge Base, Math, Dictionary, Summarizer, and Email."

    return TEMPLATES.get(intent, TEMPLATES["unknown"])
