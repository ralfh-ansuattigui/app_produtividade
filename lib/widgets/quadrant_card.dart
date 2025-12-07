import 'package:flutter/material.dart';

import '../models/task.dart';

class QuadrantCard extends StatefulWidget {
  final int quadrant;
  final String title;
  final Color color;
  final List<Task> tasks;
  final Function(Task) onTaskTap;
  final Function(Task, int) onTaskMoved;
  final VoidCallback onAddTask;

  const QuadrantCard({
    Key? key,
    required this.quadrant,
    required this.title,
    required this.color,
    required this.tasks,
    required this.onTaskTap,
    required this.onTaskMoved,
    required this.onAddTask,
  }) : super(key: key);

  @override
  State<QuadrantCard> createState() => _QuadrantCardState();
}

class _QuadrantCardState extends State<QuadrantCard> {
  int _tapCount = 0;
  DateTime? _lastTapTime;

  void _handleTap() {
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!).inMilliseconds < 500) {
      // Duplo clique detectado
      _tapCount = 0;
      _lastTapTime = null;
      widget.onAddTask();
    } else {
      // Primeiro clique
      _tapCount = 1;
      _lastTapTime = now;
    }
  }

  @override
  Widget build(BuildContext context) {
    const titleFontSize = 12.0;
    const emptyMessageSize = 11.0;
    const taskTileFontSize = 10.0;
    const borderRadius = 6.0;

    return DragTarget<Task>(
      onWillAcceptWithDetails: (details) =>
          details.data.quadrant != widget.quadrant,
      onAcceptWithDetails: (details) {
        widget.onTaskMoved(details.data, widget.quadrant);
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
              border: Border(top: BorderSide(color: widget.color, width: 2)),
              color: isDraggingOver ? widget.color.withOpacity(0.1) : null,
            ),
            child: Column(
              children: [
                if (widget.title.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleFontSize,
                        height: 1.15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Expanded(
                  child: GestureDetector(
                    onTap: widget.tasks.isEmpty ? _handleTap : null,
                    child: widget.tasks.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.touch_app,
                                  color: Colors.grey[300],
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Duplo clique para\nadicionar tarefa',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: emptyMessageSize,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: widget.tasks.map((task) {
                                return _TaskTile(
                                  task: task,
                                  onTap: () => widget.onTaskTap(task),
                                  fontSize: taskTileFontSize,
                                );
                              }).toList(),
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
