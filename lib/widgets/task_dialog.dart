import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/quadrant_helper.dart';
import '../providers/tasks_provider.dart';
import 'task_suggestions.dart';

class TaskDialog extends StatefulWidget {
  final Function(
    String title,
    String? description,
    int quadrant,
    DateTime? dueDate,
  )
  onSave;
  final int initialQuadrant;

  const TaskDialog({Key? key, required this.onSave, this.initialQuadrant = 1})
    : super(key: key);

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late int _selectedQuadrant;
  DateTime? _dueDate;

  // Novas variáveis para urgência e importância
  bool _isUrgent = true;
  bool _isImportant = true;

  @override
  void initState() {
    super.initState();
    _selectedQuadrant = widget.initialQuadrant;
    // Inicializa urgência e importância baseado no quadrante
    _updateUrgencyImportance();
  }

  void _updateUrgencyImportance() {
    switch (_selectedQuadrant) {
      case 1: // Urgente e Importante
        _isUrgent = true;
        _isImportant = true;
        break;
      case 2: // Não Urgente e Importante
        _isUrgent = false;
        _isImportant = true;
        break;
      case 3: // Urgente e Não Importante
        _isUrgent = true;
        _isImportant = false;
        break;
      case 4: // Não Urgente e Não Importante
        _isUrgent = false;
        _isImportant = false;
        break;
    }
  }

  void _updateQuadrant() {
    if (_isUrgent && _isImportant) {
      _selectedQuadrant = 1;
    } else if (!_isUrgent && _isImportant) {
      _selectedQuadrant = 2;
    } else if (_isUrgent && !_isImportant) {
      _selectedQuadrant = 3;
    } else {
      _selectedQuadrant = 4;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Tarefa'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    autofocus: true,
                  ),
                ),
                const SizedBox(width: 8),
                // Botão para abrir popup de histórico
                Consumer<TasksNotifier>(
                  builder: (context, tasksNotifier, _) {
                    return TaskHistoryButton(
                      allTasks: tasksNotifier.tasks,
                      onTaskSelected: (selectedTitle) {
                        // Callback para ações adicionais
                      },
                      titleController: _titleController,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição (opcional)',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _dueDate == null
                    ? 'Data Prazo (opcional)'
                    : 'Prazo: ${_dueDate!.day.toString().padLeft(2, '0')}/${_dueDate!.month.toString().padLeft(2, '0')}/${_dueDate!.year}',
              ),
              trailing: _dueDate != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _dueDate = null;
                        });
                      },
                    )
                  : null,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _dueDate = date;
                  });
                }
              },
            ),
            const SizedBox(height: 20),

            // Seleção de Urgência
            const Text(
              'Urgência:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(
                  value: true,
                  label: Text('Urgente'),
                  icon: Icon(Icons.warning_amber_rounded),
                ),
                ButtonSegment<bool>(
                  value: false,
                  label: Text('Não Urgente'),
                  icon: Icon(Icons.schedule),
                ),
              ],
              selected: {_isUrgent},
              onSelectionChanged: (Set<bool> selected) {
                setState(() {
                  _isUrgent = selected.first;
                  _updateQuadrant();
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return _isUrgent ? Colors.red[100]! : Colors.blue[100]!;
                  }
                  return Colors.grey[200]!;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return _isUrgent ? Colors.red[900]! : Colors.blue[900]!;
                  }
                  return Colors.grey[700]!;
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Seleção de Importância
            const Text(
              'Importância:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(
                  value: true,
                  label: Text('Importante'),
                  icon: Icon(Icons.star),
                ),
                ButtonSegment<bool>(
                  value: false,
                  label: Text('Não Importante'),
                  icon: Icon(Icons.star_border),
                ),
              ],
              selected: {_isImportant},
              onSelectionChanged: (Set<bool> selected) {
                setState(() {
                  _isImportant = selected.first;
                  _updateQuadrant();
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return _isImportant
                        ? Colors.green[100]!
                        : Colors.grey[300]!;
                  }
                  return Colors.grey[200]!;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return _isImportant
                        ? Colors.green[900]!
                        : Colors.grey[700]!;
                  }
                  return Colors.grey[700]!;
                }),
              ),
            ),

            const SizedBox(height: 16),

            // Indicador Visual do Quadrante Selecionado
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getQuadrantColor().withOpacity(0.1),
                border: Border.all(color: _getQuadrantColor(), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _getQuadrantIcon(),
                    color: _getQuadrantColor(),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getQuadrantName(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: _getQuadrantColor(),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getQuadrantAction(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              widget.onSave(
                _titleController.text,
                _descriptionController.text.isEmpty
                    ? null
                    : _descriptionController.text,
                _selectedQuadrant,
                _dueDate,
              );
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }

  // Métodos auxiliares para o indicador visual
  Color _getQuadrantColor() => QuadrantHelper.getColor(_selectedQuadrant);
  IconData _getQuadrantIcon() => QuadrantHelper.getIcon(_selectedQuadrant);
  String _getQuadrantName() =>
      'Quadrante $_selectedQuadrant: ${QuadrantHelper.getName(_selectedQuadrant)}';
  String _getQuadrantAction() => QuadrantHelper.getAction(_selectedQuadrant);
}
