import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/tasks_provider.dart';
import '../widgets/quadrant_card.dart';
import '../widgets/task_dialog.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/quadrant_helper.dart';
import 'eisenhower_info_screen.dart';

class EisenhowerScreen extends StatefulWidget {
  const EisenhowerScreen({super.key});

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
      appBar: CustomAppBar(
        title: 'Matriz de Eisenhower',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EisenhowerInfoScreen(),
              ),
            ),
            tooltip: 'Sobre a Matriz',
          ),
        ],
      ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nova Tarefa'),
      ),
    );
  }

  void _showMatrixInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Matriz de Eisenhower'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'A Matriz de Eisenhower ajuda a priorizar tarefas baseado em:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildInfoItem(
                context,
                color: Colors.red,
                title: 'Quadrante 1: Urgente e Importante',
                description: 'Crises e emergências. Faça imediatamente!',
              ),
              const SizedBox(height: 12),
              _buildInfoItem(
                context,
                color: Colors.green,
                title: 'Quadrante 2: Não Urgente e Importante',
                description: 'Planejamento e desenvolvimento. Agende!',
              ),
              const SizedBox(height: 12),
              _buildInfoItem(
                context,
                color: Colors.orange,
                title: 'Quadrante 3: Urgente e Não Importante',
                description: 'Interrupções e distrações. Delegue!',
              ),
              const SizedBox(height: 12),
              _buildInfoItem(
                context,
                color: Colors.blue,
                title: 'Quadrante 4: Não Urgente e Não Importante',
                description: 'Atividades triviais. Elimine!',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required Color color,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, TasksNotifier tasksNotifier) {
    final quadrants = [
      {'number': 1, 'title': '', 'color': Colors.red},
      {'number': 2, 'title': '', 'color': Colors.green},
      {'number': 3, 'title': '', 'color': Colors.orange},
      {'number': 4, 'title': '', 'color': Colors.blue},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 2.0;
        final labelWidth = 50.0;
        final labelHeight = 28.0;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Labels Horizontais (IMPORTANTE | NÃO IMPORTANTE)
              Row(
                children: [
                  SizedBox(width: labelWidth),
                  Expanded(
                    child: Container(
                      height: labelHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.8),
                            Theme.of(
                              context,
                            ).colorScheme.secondary.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'IMPORTANTE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: Container(
                      height: labelHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'NÃO IMPORTANTE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.grey[800],
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Grid com Labels Verticais
              Expanded(
                child: Row(
                  children: [
                    // Coluna de Labels Verticais (URGENTE | NÃO URGENTE)
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: labelWidth,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red[600]!, Colors.orange[600]!],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: const Text(
                                'URGENTE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: spacing),
                        Expanded(
                          child: Container(
                            width: labelWidth,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                'NÃO URGENTE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Colors.grey[800],
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    // Grid de Quadrantes
                    Expanded(
                      child: Column(
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
                                  ),
                                ),
                                SizedBox(width: spacing),
                                Expanded(
                                  child: _buildQuadrant(
                                    context,
                                    tasksNotifier,
                                    quadrants[2],
                                    spacing,
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
                                    quadrants[1],
                                    spacing,
                                  ),
                                ),
                                SizedBox(width: spacing),
                                Expanded(
                                  child: _buildQuadrant(
                                    context,
                                    tasksNotifier,
                                    quadrants[3],
                                    spacing,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuadrant(
    BuildContext context,
    TasksNotifier tasksNotifier,
    Map<String, dynamic> quadrant,
    double spacing,
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
          tasksNotifier.moveTask(task.id!, newQuadrant),
      onTaskReordered: (fromIndex, toIndex) {
        tasksNotifier.reorderTasksInQuadrant(
          quadrant['number'] as int,
          fromIndex,
          toIndex,
        );
      },
      onAddTask: () =>
          _showAddTaskDialog(context, quadrant: quadrant['number'] as int),
    );
  }

  void _showAddTaskDialog(BuildContext context, {int quadrant = 1}) {
    showDialog(
      context: context,
      builder: (ctx) => TaskDialog(
        initialQuadrant: quadrant,
        onSave: (title, description, selectedQuadrant, dueDate) async {
          final task = Task(
            userId: 1, 
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
          Text('Quadrante: ${QuadrantHelper.getName(task.quadrant)}'),
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
