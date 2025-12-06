import 'package:flutter/material.dart';

class TaskDialog extends StatefulWidget {
  final Function(String title, String? description, int quadrant, DateTime? dueDate) onSave;
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

  @override
  void initState() {
    super.initState();
    _selectedQuadrant = widget.initialQuadrant;
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
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
              autofocus: true,
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
            const Text(
              'Quadrante:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            RadioListTile<int>(
              title: const Text('Urgente e Importante'),
              subtitle: const Text('Fazer agora'),
              value: 1,
              groupValue: _selectedQuadrant,
              onChanged: (value) {
                setState(() {
                  _selectedQuadrant = value!;
                });
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<int>(
              title: const Text('Não Urgente e Importante'),
              subtitle: const Text('Agendar'),
              value: 2,
              groupValue: _selectedQuadrant,
              onChanged: (value) {
                setState(() {
                  _selectedQuadrant = value!;
                });
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<int>(
              title: const Text('Urgente e Não Importante'),
              subtitle: const Text('Delegar'),
              value: 3,
              groupValue: _selectedQuadrant,
              onChanged: (value) {
                setState(() {
                  _selectedQuadrant = value!;
                });
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<int>(
              title: const Text('Não Urgente e Não Importante'),
              subtitle: const Text('Eliminar'),
              value: 4,
              groupValue: _selectedQuadrant,
              onChanged: (value) {
                setState(() {
                  _selectedQuadrant = value!;
                });
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
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
}
