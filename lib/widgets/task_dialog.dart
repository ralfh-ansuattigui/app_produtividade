import 'package:flutter/material.dart';

class TaskDialog extends StatefulWidget {
  final Function(String title, String? description, int quadrant) onSave;
  final int initialQuadrant;

  const TaskDialog({
    Key? key,
    required this.onSave,
    this.initialQuadrant = 1,
  }) : super(key: key);

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late int _selectedQuadrant;

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
              );
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
