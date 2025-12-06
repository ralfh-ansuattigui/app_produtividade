import 'package:flutter/material.dart';

import '../models/task.dart';

class QuadrantCard extends StatelessWidget {
  final String title;
  final Color color;
  final List<Task> tasks;
  final Function(Task) onTaskTap;
  final VoidCallback onAddTask;
  final bool isCompact;

  const QuadrantCard({
    Key? key,
    required this.title,
    required this.color,
    required this.tasks,
    required this.onTaskTap,
    required this.onAddTask,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleFontSize = isCompact ? 11.0 : 13.0;
    final emptyMessageSize = isCompact ? 10.0 : 12.0;
    final taskTileFontSize = isCompact ? 10.0 : 11.0;
    final buttonIconSize = isCompact ? 14.0 : 16.0;
    final buttonTextSize = isCompact ? 10.0 : 12.0;
    const borderRadius = 8.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border(top: BorderSide(color: color, width: 3)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(isCompact ? 8 : 10),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                  height: 1.2,
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
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: isCompact ? 4 : 8,
                        vertical: isCompact ? 4 : 6,
                      ),
                      itemCount: tasks.length,
                      itemBuilder: (ctx, idx) => _TaskTile(
                        task: tasks[idx],
                        onTap: () => onTaskTap(tasks[idx]),
                        fontSize: taskTileFontSize,
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(isCompact ? 6 : 8),
              child: SizedBox(
                width: double.infinity,
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
                    padding: EdgeInsets.symmetric(
                      vertical: isCompact ? 6 : 8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            task.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
