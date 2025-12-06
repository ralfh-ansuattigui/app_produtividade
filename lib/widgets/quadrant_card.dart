import 'package:flutter/material.dart';

import '../models/task.dart';

class QuadrantCard extends StatelessWidget {
  final int quadrant;
  final String title;
  final Color color;
  final List<Task> tasks;
  final Function(Task) onTaskTap;
  final Function(Task, int) onTaskMoved;
  final VoidCallback onAddTask;
  final bool isCompact;

  const QuadrantCard({
    Key? key,
    required this.quadrant,
    required this.title,
    required this.color,
    required this.tasks,
    required this.onTaskTap,
    required this.onTaskMoved,
    required this.onAddTask,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleFontSize = isCompact ? 10.0 : 12.0;
    final emptyMessageSize = isCompact ? 9.0 : 11.0;
    final taskTileFontSize = isCompact ? 9.0 : 10.0;
    final buttonIconSize = isCompact ? 12.0 : 14.0;
    final buttonTextSize = isCompact ? 9.0 : 10.0;
    const borderRadius = 6.0;

    return DragTarget<Task>(
      onWillAcceptWithDetails: (details) => details.data.quadrant != quadrant,
      onAcceptWithDetails: (details) {
        onTaskMoved(details.data, quadrant);
      },
      builder: (context, candidateData, rejectedData) {
        final isDraggingOver = candidateData.isNotEmpty;
        return Card(
          elevation: 1,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border(top: BorderSide(color: color, width: 2)),
              color: isDraggingOver ? color.withOpacity(0.1) : null,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 4 : 6,
                    vertical: isCompact ? 4 : 6,
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize,
                      height: 1.15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: tasks.isEmpty
                      ? Center(
                          child: Text(
                            'Sem tarefas',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: emptyMessageSize,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: tasks.map((task) {
                              return _TaskTile(
                                task: task,
                                onTap: () => onTaskTap(task),
                                fontSize: taskTileFontSize,
                              );
                            }).toList(),
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 3 : 4,
                    vertical: isCompact ? 3 : 4,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: isCompact ? 28 : 32,
                    child: ElevatedButton.icon(
                      onPressed: onAddTask,
                      icon: Icon(Icons.add, size: buttonIconSize),
                      label: Text(
                        'Adicionar',
                        style: TextStyle(fontSize: buttonTextSize),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.withOpacity(0.2),
                        foregroundColor: color,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final double fontSize;

  const _TaskTile({
    required this.task,
    required this.onTap,
    this.fontSize = 11.0,
  });

  Color _getDueStatusColor() {
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

  String _getDueStatusText() {
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

  @override
  Widget build(BuildContext context) {
    final dueStatusColor = _getDueStatusColor();
    final dueStatusText = _getDueStatusText();
    final hasDueWarning = task.getDueStatus() != DueStatus.ok;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Draggable<Task>(
        data: task,
        feedback: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(3),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(3),
            ),
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              task.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: fontSize, height: 1.1),
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: dueStatusColor,
              borderRadius: BorderRadius.circular(3),
              border: hasDueWarning
                  ? Border.all(color: dueStatusColor, width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fontSize,
                      height: 1.1,
                      color: hasDueWarning ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                if (hasDueWarning)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      dueStatusText,
                      style: TextStyle(
                        fontSize: fontSize * 0.8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(3),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: dueStatusColor,
              borderRadius: BorderRadius.circular(3),
              border: hasDueWarning
                  ? Border.all(color: dueStatusColor, width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fontSize,
                      height: 1.1,
                      color: hasDueWarning ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                if (hasDueWarning)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      dueStatusText,
                      style: TextStyle(
                        fontSize: fontSize * 0.8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
