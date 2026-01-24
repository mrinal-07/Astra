from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from database import get_db_connection
import sqlite3

router = APIRouter(prefix="/auth", tags=["Authentication"])

class AuthRequest(BaseModel):
    email: str
    password: str

class AuthResponse(BaseModel):
    user_id: int
    email: str
    status: str

@router.post("/signup", response_model=AuthResponse)
async def signup(request: AuthRequest):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "INSERT INTO users (email, password) VALUES (?, ?)",
            (request.email, request.password)
        )
        conn.commit()
        user_id = cursor.lastrowid
        return AuthResponse(user_id=user_id, email=request.email, status="User created successfully")
    except sqlite3.IntegrityError:
        raise HTTPException(status_code=400, detail="Email already registered")
    finally:
        conn.close()

@router.post("/login", response_model=AuthResponse)
async def login(request: AuthRequest):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "SELECT id, email FROM users WHERE email = ? AND password = ?",
        (request.email, request.password)
    )
    user = cursor.fetchone()
    conn.close()
    
    if user:
        return AuthResponse(user_id=user["id"], email=user["email"], status="Login successful")
    else:
        raise HTTPException(status_code=401, detail="Invalid email or password")
