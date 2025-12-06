import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/tasks_provider.dart';
import '../widgets/quadrant_card.dart';
import '../widgets/task_dialog.dart';

class EisenhowerScreen extends StatefulWidget {
  const EisenhowerScreen({Key? key}) : super(key: key);

  @override
  State<EisenhowerScreen> createState() => _EisenhowerScreenState();
}

class _EisenhowerScreenState extends State<EisenhowerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TasksNotifier>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matriz de Eisenhower'), elevation: 0),
      body: Consumer<TasksNotifier>(
        builder: (context, tasksNotifier, _) {
          if (tasksNotifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (tasksNotifier.error != null) {
            return Center(child: Text('Erro: ${tasksNotifier.error}'));
          }
          return _buildGrid(context, tasksNotifier);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, TasksNotifier tasksNotifier) {
    final quadrants = [
      {'number': 1, 'title': 'Urgente e Importante', 'color': Colors.red},
      {'number': 2, 'title': 'Não Urgente e Importante', 'color': Colors.green},
      {
        'number': 3,
        'title': 'Urgente e Não Importante',
        'color': Colors.orange,
      },
      {
        'number': 4,
        'title': 'Não Urgente e Não Importante',
        'color': Colors.blue,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: quadrants.map((q) {
          final quadrantTasks = tasksNotifier.getByQuadrant(q['number'] as int);
          return QuadrantCard(
            title: q['title'] as String,
            color: q['color'] as Color,
            tasks: quadrantTasks,
            onTaskTap: (task) => _showTaskDialog(context, tasksNotifier, task),
            onAddTask: () =>
                _showAddTaskDialog(context, quadrant: q['number'] as int),
          );
        }).toList(),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, {int quadrant = 1}) {
    showDialog(
      context: context,
      builder: (ctx) => TaskDialog(
        onSave: (title, description) async {
          final task = Task(
            userId: 1, // TODO: get from auth provider
            title: title,
            description: description,
            quadrant: quadrant,
          );
          if (context.mounted) {
            await context.read<TasksNotifier>().createTask(task);
            if (ctx.mounted) Navigator.pop(ctx);
          }
        },
      ),
    );
  }

  void _showTaskDialog(
    BuildContext context,
    TasksNotifier tasksNotifier,
    Task task,
  ) {
    showDialog(
      context: context,
      builder: (ctx) =>
          _TaskDetailDialog(task: task, tasksNotifier: tasksNotifier),
    );
  }
}

class _TaskDetailDialog extends StatelessWidget {
  final Task task;
  final TasksNotifier tasksNotifier;

  const _TaskDetailDialog({required this.task, required this.tasksNotifier});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(task.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.description != null && task.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(task.description!),
            ),
          Text('Quadrante: ${task.quadrant}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await tasksNotifier.toggleComplete(task.id!, true);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Marcar Completo'),
        ),
        TextButton(
          onPressed: () async {
            await tasksNotifier.deleteTask(task.id!);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Deletar', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
