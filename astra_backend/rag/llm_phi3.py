import requests
import os

OLLAMA_URL = os.getenv("OLLAMA_URL", "http://127.0.0.1:11434/api/generate")
MODEL = os.getenv("OLLAMA_MODEL", "phi3")
TIMEOUT = 30

def ask_phi3(prompt: str, max_tokens: int = 512) -> str:
    """
    Send prompt to local Ollama API. Returns generated text or raises.
    """
    try:
        payload = {
            "model": MODEL,
            "prompt": prompt,
            "max_tokens": max_tokens,
            "stream": False
        }
        resp = requests.post(OLLAMA_URL, json=payload, timeout=TIMEOUT)
        resp.raise_for_status()
        data = resp.json()
        # Ollama responses sometimes vary by version. Try to adapt:
        if isinstance(data, dict):
            # common: data["response"] or data["choices"][0]["content"]
            if "response" in data and isinstance(data["response"], str):
                return data["response"].strip()
            if "choices" in data and isinstance(data["choices"], list) and data["choices"]:
                c = data["choices"][0]
                # try content
                if "content" in c:
                    return c["content"].strip()
                if "message" in c and isinstance(c["message"], dict) and "content" in c["message"]:
                    return c["message"]["content"].strip()
        # fallback to raw text
        return str(data).strip()
    except Exception as e:
        # Propagate as string for caller to decide fallback
        return f"LLM_ERROR: {e}"
