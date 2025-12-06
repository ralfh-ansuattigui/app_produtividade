import '../database/database_factory.dart' as db;
import '../models/task.dart';

class TaskRepository {
  final db.DatabaseFactory _databaseFactory = db.DatabaseFactory();

  Future<List<Task>> getByQuadrant(int quadrant) async {
    final database = await _databaseFactory.database;
    final result = await database.query(
      'tasks',
      where: 'quadrant = ? AND is_completed = 0',
      whereArgs: [quadrant],
      orderBy: 'created_at DESC',
    );
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> getAll() async {
    final database = await _databaseFactory.database;
    final result = await database.query('tasks', orderBy: 'created_at DESC');
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<Task> create(Task task) async {
    final database = await _databaseFactory.database;
    final data = task.toMap();
    data.remove('id');
    final id = await database.insert('tasks', data);
    return task.copyWith(id: id);
  }

  Future<void> update(Task task) async {
    final database = await _databaseFactory.database;
    await database.update(
      'tasks',
      task.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> delete(int id) async {
    final database = await _databaseFactory.database;
    await database.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> move(int id, int quadrant) async {
    final database = await _databaseFactory.database;
    await database.update(
      'tasks',
      {'quadrant': quadrant, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleComplete(int id, bool isCompleted) async {
    final database = await _databaseFactory.database;
    await database.update(
      'tasks',
      {
        'is_completed': isCompleted ? 1 : 0,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
