import 'package:flutter/material.dart';

import '../models/task.dart';

class QuadrantCard extends StatefulWidget {
  final int quadrant;
  final String title;
  final Color color;
  final List<Task> tasks;
  final Function(Task) onTaskTap;
  final Function(Task, int) onTaskMoved;
  final Function(int, int)? onTaskReordered;
  final VoidCallback onAddTask;

  const QuadrantCard({
    Key? key,
    required this.quadrant,
    required this.title,
    required this.color,
    required this.tasks,
    required this.onTaskTap,
    required this.onTaskMoved,
    this.onTaskReordered,
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
      _tapCount = 0;
      _lastTapTime = null;
      widget.onAddTask();
    } else {
      _tapCount = 1;
      _lastTapTime = now;
    }
  }

  @override
  Widget build(BuildContext context) {
    const titleFontSize = 12.0;
    const emptyMessageSize = 11.0;
    const taskTileFontSize = 12.0;
    const borderRadius = 6.0;

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: DragTarget<Task>(
        onWillAcceptWithDetails: (details) =>
            details.data.quadrant != widget.quadrant,
        onAcceptWithDetails: (details) {
          widget.onTaskMoved(details.data, widget.quadrant);
        },
        builder: (context, candidateData, rejectedData) {
          final isDraggingOver = candidateData.isNotEmpty;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border(top: BorderSide(color: widget.color, width: 2)),
              color: isDraggingOver ? widget.color.withOpacity(0.1) : null,
            ),
            child: Stack(
              children: [
                Column(
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
                        onTap: _handleTap,
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
                            : ReorderableListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.tasks.length,
                                onReorder: (oldIndex, newIndex) {
                                  if (oldIndex != newIndex) {
                                    widget.onTaskReordered?.call(
                                      oldIndex,
                                      newIndex,
                                    );
                                  }
                                },
                                itemBuilder: (context, index) {
                                  return _TaskTile(
                                    key: ValueKey(widget.tasks[index].id),
                                    task: widget.tasks[index],
                                    taskNumber: index + 1,
                                    onTap: () =>
                                        widget.onTaskTap(widget.tasks[index]),
                                    fontSize: taskTileFontSize,
                                    onTaskMoved: widget.onTaskMoved,
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
                if (widget.tasks.isNotEmpty)
                  Positioned(
                    bottom: 4,
                    left: 4,
                    child: _MagnifyButton(
                      quadrant: widget.quadrant,
                      title: widget.title,
                      color: widget.color,
                      tasks: widget.tasks,
                      onTaskTap: widget.onTaskTap,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final Task task;
  final int taskNumber;
  final VoidCallback onTap;
  final double fontSize;
  final Function(Task, int) onTaskMoved;

  const _TaskTile({
    Key? key,
    required this.task,
    required this.taskNumber,
    required this.onTap,
    required this.onTaskMoved,
    this.fontSize = 12.0,
  }) : super(key: key);

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
      child: DragTarget<Task>(
        onWillAcceptWithDetails: (details) =>
            details.data.quadrant != task.quadrant,
        onAcceptWithDetails: (details) {
          onTaskMoved(details.data, task.quadrant);
        },
        builder: (context, candidateData, rejectedData) {
          return Draggable<Task>(
            data: task,
            feedback: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[400],
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(maxWidth: 220),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          '$taskNumber',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fontSize,
                          height: 1.1,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: dueStatusColor,
                  borderRadius: BorderRadius.circular(6),
                  border: hasDueWarning
                      ? Border.all(color: dueStatusColor, width: 1.5)
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: hasDueWarning ? Colors.white : Colors.black12,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Center(
                        child: Text(
                          '$taskNumber',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: hasDueWarning
                                ? dueStatusColor
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fontSize * 0.95,
                          height: 1.1,
                          color: hasDueWarning ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    if (hasDueWarning)
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Text(
                          dueStatusText,
                          style: TextStyle(
                            fontSize: fontSize * 0.7,
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
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                margin: const EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  color: dueStatusColor,
                  borderRadius: BorderRadius.circular(6),
                  border: hasDueWarning
                      ? Border.all(color: dueStatusColor, width: 1.5)
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: hasDueWarning ? Colors.white : Colors.black12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          '$taskNumber',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: hasDueWarning
                                ? dueStatusColor
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: fontSize,
                          height: 1.1,
                          color: hasDueWarning ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (hasDueWarning)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          dueStatusText,
                          style: TextStyle(
                            fontSize: fontSize * 0.75,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MagnifyButton extends StatelessWidget {
  final int quadrant;
  final String title;
  final Color color;
  final List<Task> tasks;
  final Function(Task) onTaskTap;

  const _MagnifyButton({
    required this.quadrant,
    required this.title,
    required this.color,
    required this.tasks,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return QuadrantDetailModal(
                quadrant: quadrant,
                title: title,
                color: color,
                tasks: tasks,
                onTaskTap: onTaskTap,
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.search, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}

class QuadrantDetailModal extends StatelessWidget {
  final int quadrant;
  final String title;
  final Color color;
  final List<Task> tasks;
  final Function(Task) onTaskTap;

  const QuadrantDetailModal({
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
                            if ((task.description ?? '').isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                task.description ?? '',
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
