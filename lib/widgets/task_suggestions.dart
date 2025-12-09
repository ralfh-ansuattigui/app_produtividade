import 'package:flutter/material.dart';
import '../models/task.dart';

/// Widget auxiliar para sugestão e seleção de tarefas baseado no histórico
/// Filtra duplicatas e mostra títulos já utilizados para rápida seleção
class TaskSuggestions extends StatelessWidget {
  final List<Task> allTasks;
  final Function(String) onTaskSelected;
  final TextEditingController titleController;

  const TaskSuggestions({
    Key? key,
    required this.allTasks,
    required this.onTaskSelected,
    required this.titleController,
  }) : super(key: key);

  /// Extrai títulos únicos do histórico de tarefas
  /// Filtra duplicatas e ordena por frequência/recência
  List<String> _getUniqueTitles() {
    final titleSet = <String>{};
    final titleMap = <String, DateTime>{};

    // Coletar títulos únicos com sua data mais recente
    for (final task in allTasks) {
      if (task.title.isNotEmpty && !titleSet.contains(task.title)) {
        titleSet.add(task.title);
        titleMap[task.title] = task.updatedAt;
      }
    }

    // Ordenar por data (mais recentes primeiro)
    final sortedTitles = titleSet.toList();
    sortedTitles.sort((a, b) => titleMap[b]!.compareTo(titleMap[a]!));

    return sortedTitles;
  }

  /// Filtra sugestões baseado no texto digitado
  List<String> _filterSuggestions(String input) {
    if (input.isEmpty) {
      return _getUniqueTitles().take(5).toList(); // Top 5 mais recentes
    }

    final inputLower = input.toLowerCase();
    return _getUniqueTitles()
        .where((title) => title.toLowerCase().contains(inputLower))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: titleController,
      builder: (context, value, _) {
        final suggestions = _filterSuggestions(value.text);

        if (suggestions.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!, width: 1),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[50],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8),
                child: Text(
                  '📋 Histórico de Tarefas',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: suggestions
                    .map(
                      (title) => InkWell(
                        onTap: () {
                          onTaskSelected(title);
                          titleController.text = title;
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Chip(
                          label: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.blue[50],
                          side: BorderSide(color: Colors.blue[200]!),
                          onDeleted: null, // Não deletar, apenas selecionar
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

/// Widget alternativo: Lista suspensa ao invés de Chips
/// Útil para muitas sugestões
class TaskSuggestionsDropdown extends StatelessWidget {
  final List<Task> allTasks;
  final Function(String) onTaskSelected;
  final TextEditingController titleController;

  const TaskSuggestionsDropdown({
    Key? key,
    required this.allTasks,
    required this.onTaskSelected,
    required this.titleController,
  }) : super(key: key);

  List<String> _getUniqueTitles() {
    final titleSet = <String>{};
    final titleMap = <String, DateTime>{};

    for (final task in allTasks) {
      if (task.title.isNotEmpty && !titleSet.contains(task.title)) {
        titleSet.add(task.title);
        titleMap[task.title] = task.updatedAt;
      }
    }

    final sortedTitles = titleSet.toList();
    sortedTitles.sort((a, b) => titleMap[b]!.compareTo(titleMap[a]!));

    return sortedTitles;
  }

  @override
  Widget build(BuildContext context) {
    final uniqueTitles = _getUniqueTitles();

    if (uniqueTitles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[25],
        border: Border.all(color: Colors.blue[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ou selecione do histórico:',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.blue[700],
                ),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            isExpanded: true,
            hint: const Text('Escolha uma tarefa anterior'),
            onChanged: (selectedTitle) {
              if (selectedTitle != null) {
                onTaskSelected(selectedTitle);
                titleController.text = selectedTitle;
              }
            },
            items: uniqueTitles
                .map(
                  (title) => DropdownMenuItem(
                    value: title,
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// Helper para obter estatísticas do histórico de tarefas
class TaskHistoryStats {
  final int totalTasks;
  final int uniqueTitles;
  final int completedTasks;
  final List<String> topTitles;

  TaskHistoryStats({
    required this.totalTasks,
    required this.uniqueTitles,
    required this.completedTasks,
    required this.topTitles,
  });

  /// Extrai estatísticas do histórico de tarefas
  factory TaskHistoryStats.fromTasks(List<Task> allTasks) {
    final titleFrequency = <String, int>{};
    int completedCount = 0;

    for (final task in allTasks) {
      if (task.title.isNotEmpty) {
        titleFrequency[task.title] = (titleFrequency[task.title] ?? 0) + 1;
      }
      if (task.isCompleted) {
        completedCount++;
      }
    }

    // Top 5 títulos mais frequentes
    final topTitles = titleFrequency.entries.toList();
    topTitles.sort((a, b) => b.value.compareTo(a.value));
    final topTitlesList = topTitles
        .take(5)
        .map((entry) => entry.key)
        .toList();

    return TaskHistoryStats(
      totalTasks: allTasks.length,
      uniqueTitles: titleFrequency.length,
      completedTasks: completedCount,
      topTitles: topTitlesList,
    );
  }
}
