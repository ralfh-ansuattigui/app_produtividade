import 'package:flutter/material.dart';

import '../models/task.dart';

class QuadrantDetailScreen extends StatelessWidget {
  final int quadrant;
  final String title;
  final Color color;
  final List<Task> tasks;
  final Function(Task) onTaskTap;

  const QuadrantDetailScreen({
    Key? key,
    required this.quadrant,
    required this.title,
    required this.color,
    required this.tasks,
    required this.onTaskTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          backgroundColor: color.withOpacity(0.1),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          foregroundColor: Colors.black87,
        ),
        body: tasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, color: Colors.grey[300], size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma tarefa neste quadrante',
                      style: TextStyle(color: Colors.grey[500], fontSize: 14),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final dueStatusColor = _getDueStatusColor(task);
                  final dueStatusText = _getDueStatusText(task);
                  final hasDueWarning = task.getDueStatus() != DueStatus.ok;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: InkWell(
                      onTap: () {
                        onTaskTap(task);
                        Navigator.of(context).pop();
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: dueStatusColor,
                          borderRadius: BorderRadius.circular(8),
                          border: hasDueWarning
                              ? Border.all(color: dueStatusColor, width: 1.5)
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: hasDueWarning
                                        ? Colors.white
                                        : Colors.black12,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: hasDueWarning
                                            ? dueStatusColor
                                            : Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    task.title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: hasDueWarning
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                                if (hasDueWarning)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      dueStatusText,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            if (task.description.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                task.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: hasDueWarning
                                      ? Colors.white.withOpacity(0.95)
                                      : Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ],
                            if (task.dueDate != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 12,
                                    color: hasDueWarning
                                        ? Colors.white70
                                        : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDate(task.dueDate!),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: hasDueWarning
                                          ? Colors.white70
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Color _getDueStatusColor(Task task) {
    final status = task.getDueStatus();
    switch (status) {
      case DueStatus.overdue:
        return Colors.red[700]!;
      case DueStatus.today:
        return Colors.orange[700]!;
      case DueStatus.oneDay:
        return Colors.orange[400]!;
      case DueStatus.twoDays:
        return Colors.yellow[700]!;
      case DueStatus.ok:
        return Colors.grey[100]!;
    }
  }

  String _getDueStatusText(Task task) {
    final status = task.getDueStatus();
    if (status == DueStatus.ok) return '';

    switch (status) {
      case DueStatus.overdue:
        return '⚠ VENCIDA';
      case DueStatus.today:
        return '⏰ HOJE';
      case DueStatus.oneDay:
        return '📅 1 dia';
      case DueStatus.twoDays:
        return '📅 2 dias';
      case DueStatus.ok:
        return '';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
