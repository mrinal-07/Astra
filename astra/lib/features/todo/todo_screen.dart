import 'package:flutter/material.dart';
import 'package:astra/widgets/astra_page.dart';
import 'package:astra/features/todo/todo_service.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AstraPage(
      title: "Todo List",
      child: TodoBody(),
    );
  }
}

class TodoBody extends StatefulWidget {
  const TodoBody({super.key});

  @override
  State<TodoBody> createState() => _TodoBodyState();
}

class _TodoBodyState extends State<TodoBody> {
  final TextEditingController _controller = TextEditingController();
  final TodoService _todoService = TodoService();
  List<Map<String, dynamic>> _todos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await _todoService.fetchTodos();
    if (mounted) {
      setState(() {
        _todos = todos;
        _isLoading = false;
      });
    }
  }

  Future<void> _addTodo() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final newTodo = await _todoService.addTodo(text);
    if (newTodo != null && mounted) {
      setState(() {
        _todos.add(newTodo);
        _controller.clear();
      });
    }
  }

  Future<void> _deleteTodo(int id, int index) async {
    final success = await _todoService.deleteTodo(id);
    if (success && mounted) {
      setState(() => _todos.removeAt(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Add a new task:", style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your task...",
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(onPressed: _addTodo, child: const Text("Add")),
          ],
        ),

        const SizedBox(height: 20),

        Expanded(
          child: _todos.isEmpty 
            ? const Center(child: Text("No tasks yet!", style: TextStyle(color: Colors.white60)))
            : ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  return ListTile(
                    title: Text(
                      todo['task'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteTodo(todo['id'], index),
                    ),
                  );
                },
              ),
        )
      ],
    );
  }
}
