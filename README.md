# Astra 🚀

Astra is a powerful, offline-first AI assistant and productivity suite. It combines a modern Flutter frontend with a robust FastAPI backend to provide intelligent features like RAG (Retrieval-Augmented Generation) from local documents, offline chat, math solving, and more—all while keeping your data local.

---

## ✨ Features

### 🧠 Intelligent AI Assistant
- **Offline Chat**: Powered by Ollama (Phi-3) for private, offline conversations.
- **RAG System**: Upload PDFs to create a local knowledge base. Astra will cite specific pages and documents in its answers.
- **Astra Online**: Integration with Gemini for enhanced online capabilities.

### 🛠️ Productivity Tools
- **Math Solver**: Solve complex mathematical expressions with ease.
- **Email Generator**: Create professional emails from simple prompts.
- **Smart Summarizer**: Get concise summaries of long texts.
- **Offline Dictionary**: Quick word definitions and phonetics.
- **To-Do List**: Integrated task management system.

### 🎨 Modern Experience
- **Fluid UI**: Beautifully crafted Flutter interface with smooth animations and Lottie effects.
- **Cross-Platform**: Designed for seamless performance.
- **Secure**: Authentication system to keep your data personal.

---

## 🏗️ Architecture

- **Frontend**: Flutter (Provider for state management, Flutter Animate for UI)
- **Backend**: FastAPI (Python)
- **Database**: SQLite (SQLAlchemy)
- **Vector Store**: FAISS (for RAG document indexing)
- **AI Models**: Ollama (Phi-3 local), Gemini (Online)

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Python 3.10+](https://www.python.org/downloads/)
- [Ollama](https://ollama.com/) (with `phi3` model installed: `ollama run phi3`)

### Backend Setup
1. Navigate to the backend directory:
   ```bash
   cd astra_backend
   ```
2. Create and activate a virtual environment:
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Create a  `.env` file and add your API keys:
   ```env
   GEMINI_API_KEY=your_key_here
   ```
5. Run the server:
   ```bash
   python main.py
   ```

### Frontend Setup
1. Navigate to the frontend directory:
   ```bash
   cd astra
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

```text
Astra/
├── astra/                # Flutter Frontend
│   ├── lib/              # App logic & UI
│   └── assets/           # Images & Animations
└── astra_backend/        # FastAPI Backend
    ├── rag/              # RAG implementation
    ├── auth/             # User authentication
    ├── chat_online/      # Gemini integration
    └── database.py       # SQLite configuration
```

---

## 🛡️ License
Distributed under the MIT License. See `LICENSE` for more information.

---


