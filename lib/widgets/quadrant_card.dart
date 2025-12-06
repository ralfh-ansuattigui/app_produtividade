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
    final titleFontSize = isCompact ? 10.0 : 12.0;
    final emptyMessageSize = isCompact ? 9.0 : 11.0;
    final taskTileFontSize = isCompact ? 9.0 : 10.0;
    final buttonIconSize = isCompact ? 12.0 : 14.0;
    final buttonTextSize = isCompact ? 9.0 : 10.0;
    const borderRadius = 6.0;

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
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: isCompact ? 3 : 4,
                        vertical: isCompact ? 2 : 3,
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
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(3),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            task.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: fontSize, height: 1.1),
          ),
        ),
      ),
    );
  }
}
