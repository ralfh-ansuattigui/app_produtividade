import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../repositories/task_repository.dart';

class TasksNotifier extends ChangeNotifier {
  final TaskRepository _repository = TaskRepository();
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Task> getByQuadrant(int quadrant) {
    return _tasks
        .where((t) => t.quadrant == quadrant && !t.isCompleted)
        .toList();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _tasks = await _repository.getAll();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createTask(Task task) async {
    try {
      final created = await _repository.create(task);
      _tasks.insert(0, created);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _repository.update(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index >= 0) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _repository.delete(id);
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> moveTask(int id, int quadrant) async {
    try {
      await _repository.move(id, quadrant);
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index >= 0) {
        _tasks[index] = _tasks[index].copyWith(quadrant: quadrant);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleComplete(int id, bool isCompleted) async {
    try {
      await _repository.toggleComplete(id, isCompleted);
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index >= 0) {
        _tasks[index] = _tasks[index].copyWith(isCompleted: isCompleted);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
