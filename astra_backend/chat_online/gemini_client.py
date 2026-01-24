import os
import google.generativeai as genai

def call_gemini(message: str) -> str:
    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        return "Configuration Error: GEMINI_API_KEY not found."

    try:
        genai.configure(api_key=api_key)

        model = genai.GenerativeModel(
            model_name="gemini-pro",
            system_instruction="""
You are ASTRA Online Assistant.

You can answer general knowledge questions clearly and concisely.

You must NOT:
- Answer questions about user documents or PDFs
- Solve mathematical problems
- Write or draft emails
- Summarize user-provided text

If the user asks about these tasks, politely redirect them to the appropriate tool.
"""
        )

        response = model.generate_content(message)
        return response.text.strip()

    except Exception as e:
        return f"Gemini Error: {str(e)}"
