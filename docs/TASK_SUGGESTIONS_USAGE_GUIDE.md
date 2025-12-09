# 📖 Guia de Uso - TaskSuggestions Widget

## ⚡ Quick Start (5 minutos)

### Como Funciona

O widget `TaskSuggestions` aparece **automaticamente** no `TaskDialog` quando você abre a tela de adicionar tarefa. Não requer ação adicional do desenvolvedor!

### Para o Usuário Final

```
┌─────────────────────────────────────┐
│ Adicionar Tarefa                    │
├─────────────────────────────────────┤
│ Título                              │
│ [_________________________________]│
│                                     │
│ 📋 Histórico de Tarefas             │ ← Aparece automaticamente
│ [Estudar] [Exercitar] [Ler]         │
│ [Trabalhar] [Dormir]                │
│                                     │
│ Descrição (opcional)                │
│ [_________________________________]│
│ [_________________________________]│
│                                     │
│ ... mais campos ...                 │
│                                     │
│ [Cancelar] [Salvar]                 │
└─────────────────────────────────────┘
```

### Fluxo de Uso

1. **Abrir Task Dialog**
   - Clica no botão "+" (FAB) na EisenhowerScreen

2. **Widget Renderiza**
   - TaskSuggestions carrega histórico automaticamente
   - Mostra top 5 títulos mais recentes

3. **Digitar no Título**
   - Widget filtra sugestões em tempo real
   - Busca é case-insensitive

4. **Selecionar Sugestão**
   - Clica em um chip/dropdown item
   - Campo "Título" é preenchido automaticamente

5. **Completar e Salvar**
   - Preenche outros campos (descrição, urgência, etc.)
   - Clica "Salvar" para criar a tarefa

---

## 🔧 Para Desenvolvedores

### Implementação Atual (TaskDialog)

```dart
import 'package:provider/provider.dart';
import '../providers/tasks_provider.dart';
import 'task_suggestions.dart';

class _TaskDialogState extends State<TaskDialog> {
  final _titleController = TextEditingController();
  // ... outros controllers ...

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Tarefa'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Campo de título
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
              autofocus: true,
            ),
            
            // ⭐ Widget de sugestões integrado
            Consumer<TasksNotifier>(
              builder: (context, tasksNotifier, _) {
                return TaskSuggestions(
                  allTasks: tasksNotifier.tasks,
                  onTaskSelected: (selectedTitle) {
                    // Callback - aqui você pode fazer mais coisas
                    // Por padrão, apenas o título é preenchido
                  },
                  titleController: _titleController,
                );
              },
            ),

            // Resto dos campos...
          ],
        ),
      ),
      actions: [/* ... */],
    );
  }
}
```

### Customizações Possíveis

#### 1. AutoFill Completo (Múltiplos Campos)

```dart
Consumer<TasksNotifier>(
  builder: (context, tasksNotifier, _) {
    return TaskSuggestions(
      allTasks: tasksNotifier.tasks,
      onTaskSelected: (selectedTitle) {
        // Encontra a tarefa original
        final originalTask = tasksNotifier.tasks
            .firstWhere((t) => t.title == selectedTitle);
        
        // Preenche todos os campos
        _titleController.text = originalTask.title;
        _descriptionController.text = originalTask.description ?? '';
        _isUrgent = originalTask.isUrgent;
        _isImportant = originalTask.isImportant;
        if (originalTask.dueDate != null) {
          _dueDate = originalTask.dueDate;
        }
        
        // Atualiza quadrante
        _updateQuadrant();
        setState(() {});
      },
      titleController: _titleController,
    );
  },
)
```

#### 2. Usar Variante Dropdown (Para Muitas Sugestões)

```dart
// Trocar de:
return TaskSuggestions(...)

// Para:
return TaskSuggestionsDropdown(...)
```

#### 3. Customizar Aparência de Chips

```dart
// Dentro de task_suggestions.dart, modificar Chip:
Chip(
  label: Text(title),
  backgroundColor: Colors.blue[50],      // ← Mudar cor
  side: BorderSide(color: Colors.blue[200]!),
  labelStyle: TextStyle(/* ... */),      // ← Mudar font
  avatar: Icon(Icons.history),           // ← Adicionar avatar
  // ...
)
```

#### 4. Adicionar Busca Fuzzy (Typo Tolerance)

```dart
// Instalar: flutter pub add fuzzy_search

List<String> _filterSuggestions(String input) {
  if (input.isEmpty) {
    return _getUniqueTitles().take(5).toList();
  }

  // Usar busca fuzzy
  final results = FuzzySearch(
    haystack: _getUniqueTitles(),
    query: input,
  ).sortedResults
      .map((r) => r.item)
      .toList();
  
  return results;
}
```

---

## 🎨 Customizações de UI

### Opção A: Chips (Padrão)

**Vantagens:**
- ✅ Visualmente atrativo
- ✅ Fácil de clicar
- ✅ Mostra múltiplas opções simultaneamente
- ✅ Bom para 5-10 sugestões

**Código:**
```dart
return TaskSuggestions(
  allTasks: tasksNotifier.tasks,
  onTaskSelected: (title) { ... },
  titleController: _titleController,
);
```

**Resultado:**
```
📋 Histórico de Tarefas
[Estudar] [Exercitar] [Ler]
[Trabalho] [Compras]
```

---

### Opção B: Dropdown

**Vantagens:**
- ✅ Compacto (ocupa menos espaço)
- ✅ Bom para muitas sugestões (>20)
- ✅ Melhor em telas pequenas
- ✅ Padrão Material Design

**Código:**
```dart
return TaskSuggestionsDropdown(
  allTasks: tasksNotifier.tasks,
  onTaskSelected: (title) { ... },
  titleController: _titleController,
);
```

**Resultado:**
```
Ou selecione do histórico:
┌──────────────────────────────┐
│ Escolha uma tarefa anterior ▼│
└──────────────────────────────┘
```

---

### Opção C: Custom (Seu Próprio Widget)

```dart
// Você pode criar seu próprio widget similar:

class MyCustomTaskSuggestions extends StatelessWidget {
  final List<Task> allTasks;
  final Function(String) onTaskSelected;
  final TextEditingController titleController;

  const MyCustomTaskSuggestions({
    required this.allTasks,
    required this.onTaskSelected,
    required this.titleController,
  });

  @override
  Widget build(BuildContext context) {
    // Sua implementação aqui
    return Container(/* ... */);
  }
}
```

---

## 📊 Exemplos de Uso Avançado

### Exemplo 1: Com Busca Avançada

```dart
Consumer<TasksNotifier>(
  builder: (context, tasksNotifier, _) {
    // Filtrar apenas tarefas dos últimos 30 dias
    final recentTasks = tasksNotifier.tasks
        .where((t) => t.createdAt.isAfter(
          DateTime.now().subtract(Duration(days: 30))
        ))
        .toList();

    return TaskSuggestions(
      allTasks: recentTasks,
      onTaskSelected: (selectedTitle) { ... },
      titleController: _titleController,
    );
  },
)
```

### Exemplo 2: Com Filtro por Quadrante

```dart
Consumer<TasksNotifier>(
  builder: (context, tasksNotifier, _) {
    // Mostrar apenas tarefas do quadrante 1 (Urgente & Importante)
    final urgentImportant = tasksNotifier.tasks
        .where((t) => t.quadrant == 1)
        .toList();

    return TaskSuggestions(
      allTasks: urgentImportant,
      onTaskSelected: (selectedTitle) { ... },
      titleController: _titleController,
    );
  },
)
```

### Exemplo 3: Com Estatísticas

```dart
Consumer<TasksNotifier>(
  builder: (context, tasksNotifier, _) {
    final stats = TaskHistoryStats.fromTasks(tasksNotifier.tasks);
    
    return Column(
      children: [
        Text('Total: ${stats.totalTasks}'),
        Text('Únicas: ${stats.uniqueTitles}'),
        TaskSuggestions(
          allTasks: tasksNotifier.tasks,
          onTaskSelected: (selectedTitle) { ... },
          titleController: _titleController,
        ),
      ],
    );
  },
)
```

---

## ⚙️ Configurações e Ajustes

### Mudar Número de Top Sugestões

**Arquivo:** `lib/widgets/task_suggestions.dart`

**Linha:** ~50
```dart
// Mudar de 5 para 10:
return _getUniqueTitles().take(10).toList();
```

### Mudar Comportamento de Deduplicação

**Arquivo:** `lib/widgets/task_suggestions.dart`

**Método:** `_getUniqueTitles()`

**Opções:**

1. **Case-Insensitive (Normalizado)**
```dart
if (task.title.trim().toLowerCase().isEmpty) continue;
if (!titleSet.contains(task.title.trim().toLowerCase())) {
  titleSet.add(task.title.trim().toLowerCase());
}
```

2. **Com Remoção de Whitespace Extra**
```dart
final normalized = task.title.trim().replaceAll(RegExp(r'\s+'), ' ');
if (!titleSet.contains(normalized)) {
  titleSet.add(normalized);
}
```

3. **Com Remoção de Acentos**
```dart
String removeAccents(String str) {
  var baseChars = 'àáâãäåèéêëìíîïòóôõöùúûüç';
  var baseReplacements = 'aaaaaaeeeeiiiioooouuuuc';
  var string = str.toLowerCase();
  for (var i = 0; i < baseChars.length; i++) {
    string = string.replaceAll(baseChars[i], baseReplacements[i]);
  }
  return string;
}

// Usar: removeAccents(task.title)
```

### Mudar Cor dos Chips

**Arquivo:** `lib/widgets/task_suggestions.dart`

**Linhas:** ~130-135

```dart
Chip(
  label: Text(title),
  backgroundColor: Colors.green[50],     // ← Mudar de blue[50]
  side: BorderSide(color: Colors.green[200]!),  // ← Mudar de blue[200]
)
```

---

## 🐛 Troubleshooting

### Problema: Sugestões não aparecem

**Causa:** `allTasks` está vazio

**Solução:**
```dart
// Verificar se TasksNotifier carregou dados
print('Tasks loaded: ${tasksNotifier.tasks.length}');

// Garantir que initState() foi chamado
@override
void initState() {
  super.initState();
  // Forçar carregamento se necessário
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<TasksNotifier>(context, listen: false)
        .loadTasks();  // Se método existir
  });
}
```

### Problema: Duplicatas aparecem

**Causa:** Títulos têm case diferente ("Estudar" vs "estudar")

**Solução:** Normalizar em `_getUniqueTitles()`:
```dart
final normalized = task.title.trim().toLowerCase();
if (!titleSet.contains(normalized)) {
  titleSet.add(normalized);
}
```

### Problema: UI fica lenta com muitos chips

**Causa:** Renderização pesada com 100+ chips

**Solução:** Usar `TaskSuggestionsDropdown` em vez de `TaskSuggestions`

### Problema: Clique não preenche o campo

**Causa:** `titleController` não está sendo usado corretamente

**Solução:**
```dart
// Verificar que titleController está vinculado:
TextField(
  controller: _titleController,  // ← Necessário
  decoration: const InputDecoration(labelText: 'Título'),
)

// E passado para widget:
TaskSuggestions(
  titleController: _titleController,  // ← Necessário
  // ...
)
```

---

## 📚 Referências

| Arquivo | Propósito | Linhas |
|---------|----------|--------|
| lib/widgets/task_suggestions.dart | Widget principal | 250+ |
| lib/widgets/task_dialog.dart | Integração | 5-10 |
| docs/TASK_SUGGESTIONS_WIDGET.md | Documentação técnica | 400+ |
| docs/TASK_SUGGESTIONS_IMPLEMENTATION.md | Resumo executivo | 360+ |

---

## ✅ Checklist de Implementação

- [x] Widget exibe sugestões
- [x] Deduplicação funciona
- [x] Filtro dinâmico funciona
- [x] Clique preenche campo
- [x] Duas variantes (Chips e Dropdown)
- [x] Integração em TaskDialog
- [x] Documentação completa
- [x] Ready para produção

---

## 🎓 Próximos Passos

1. **Testar em diferentes tamanhos de tela**
   - iOS (pequeno, médio, grande)
   - Android (pequeno, médio, grande, tablet)

2. **Avaliar performance com muitos históricos**
   - Testar com 100+ tarefas
   - Considerar virtualização se necessário

3. **Implementar futuras melhorias**
   - AutoFill de múltiplos campos (v1.2.1)
   - Busca fuzzy com typo tolerance (v1.2.2)
   - Filtros avançados (v1.2.3)
   - Analytics (v1.3.0)

4. **Coletar feedback de usuários**
   - UX é intuitiva?
   - Sugestões são úteis?
   - Performance satisfatória?

---

**Status:** ✅ Pronto para Uso  
**Versão:** v1.2.0-dev  
**Última Atualização:** 2024
