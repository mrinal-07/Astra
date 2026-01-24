from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from database import get_db_connection
from typing import List

router = APIRouter(prefix="/todo", tags=["Todo List"])

class TodoItem(BaseModel):
    id: int
    user_id: int
    task: str
    completed: bool

class TodoCreate(BaseModel):
    user_id: int
    task: str

@router.get("/list", response_model=List[TodoItem])
async def list_todos(user_id: int = Query(...)):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM todos WHERE user_id = ?", (user_id,))
    rows = cursor.fetchall()
    conn.close()
    
    return [
        TodoItem(
            id=row["id"],
            user_id=row["user_id"],
            task=row["task"],
            completed=bool(row["completed"])
        ) for row in rows
    ]

@router.post("/add", response_model=TodoItem)
async def add_todo(request: TodoCreate):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO todos (user_id, task) VALUES (?, ?)",
        (request.user_id, request.task)
    )
    conn.commit()
    todo_id = cursor.lastrowid
    conn.close()
    
    return TodoItem(id=todo_id, user_id=request.user_id, task=request.task, completed=False)

@router.delete("/delete")
async def delete_todo(todo_id: int = Query(...)):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM todos WHERE id = ?", (todo_id,))
    conn.commit()
    conn.close()
    return {"status": "deleted"}
