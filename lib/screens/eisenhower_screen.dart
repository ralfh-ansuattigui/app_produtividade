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
      {'number': 1, 'title': 'Urgente e\nImportante', 'color': Colors.red},
      {
        'number': 2,
        'title': 'Não Urgente e\nImportante',
        'color': Colors.green,
      },
      {
        'number': 3,
        'title': 'Urgente e Não\nImportante',
        'color': Colors.orange,
      },
      {
        'number': 4,
        'title': 'Não Urgente e\nNão Importante',
        'color': Colors.blue,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 2.0;

        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuadrant(
                      context,
                      tasksNotifier,
                      quadrants[0],
                      spacing,
                      constraints.maxWidth < 500,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: _buildQuadrant(
                      context,
                      tasksNotifier,
                      quadrants[1],
                      spacing,
                      constraints.maxWidth < 500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildQuadrant(
                      context,
                      tasksNotifier,
                      quadrants[2],
                      spacing,
                      constraints.maxWidth < 500,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: _buildQuadrant(
                      context,
                      tasksNotifier,
                      quadrants[3],
                      spacing,
                      constraints.maxWidth < 500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuadrant(
    BuildContext context,
    TasksNotifier tasksNotifier,
    Map<String, dynamic> quadrant,
    double spacing,
    bool isCompact,
  ) {
    final quadrantTasks = tasksNotifier.getByQuadrant(
      quadrant['number'] as int,
    );

    return QuadrantCard(
      quadrant: quadrant['number'] as int,
      title: quadrant['title'] as String,
      color: quadrant['color'] as Color,
      tasks: quadrantTasks,
      onTaskTap: (task) => _showTaskDialog(context, tasksNotifier, task),
      onTaskMoved: (task, newQuadrant) =>
          _moveTask(tasksNotifier, task, newQuadrant),
      onAddTask: () =>
          _showAddTaskDialog(context, quadrant: quadrant['number'] as int),
      isCompact: isCompact,
    );
  }

  void _moveTask(
    TasksNotifier tasksNotifier,
    Task task,
    int newQuadrant,
  ) async {
    await tasksNotifier.moveTask(task.id!, newQuadrant);
  }

  void _showAddTaskDialog(BuildContext context, {int quadrant = 1}) {
    showDialog(
      context: context,
      builder: (ctx) => TaskDialog(
        initialQuadrant: quadrant,
        onSave: (title, description, selectedQuadrant, dueDate) async {
          final task = Task(
            userId: 1, // TODO: get from auth provider
            title: title,
            description: description,
            quadrant: selectedQuadrant,
            dueDate: dueDate,
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

  String _getQuadrantName(int quadrant) {
    switch (quadrant) {
      case 1:
        return 'Urgente e Importante';
      case 2:
        return 'Não Urgente e Importante';
      case 3:
        return 'Urgente e Não Importante';
      case 4:
        return 'Não Urgente e Não Importante';
      default:
        return 'Desconhecido';
    }
  }

  String _getDueStatusMessage() {
    final status = task.getDueStatus();
    switch (status) {
      case DueStatus.overdue:
        return '⚠️ VENCIDA';
      case DueStatus.today:
        return '⏰ Vence HOJE';
      case DueStatus.oneDay:
        return '📅 Vence em 1 dia';
      case DueStatus.twoDays:
        return '📅 Vence em 2 dias';
      case DueStatus.ok:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dueStatusMessage = _getDueStatusMessage();
    final hasDueWarning = task.getDueStatus() != DueStatus.ok;

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
          Text('Quadrante: ${_getQuadrantName(task.quadrant)}'),
          if (task.dueDate != null) ...[
            const SizedBox(height: 8),
            Text(
              'Prazo: ${task.dueDate!.day.toString().padLeft(2, '0')}/${task.dueDate!.month.toString().padLeft(2, '0')}/${task.dueDate!.year}',
            ),
          ],
          if (hasDueWarning) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: task.getDueStatus() == DueStatus.overdue
                    ? Colors.red[100]
                    : Colors.orange[100],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: task.getDueStatus() == DueStatus.overdue
                      ? Colors.red
                      : Colors.orange,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    task.getDueStatus() == DueStatus.overdue
                        ? Icons.warning
                        : Icons.access_time,
                    color: task.getDueStatus() == DueStatus.overdue
                        ? Colors.red[700]
                        : Colors.orange[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      dueStatusMessage,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: task.getDueStatus() == DueStatus.overdue
                            ? Colors.red[700]
                            : Colors.orange[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
