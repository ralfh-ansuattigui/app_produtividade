# TaskSuggestions Widget - Documentação

## Visão Geral

O widget `TaskSuggestions` implementa uma **lista auxiliar para seleção rápida de tarefas** baseada no histórico de tarefas já criadas. Este widget reduz a necessidade de digitação repetida ao criar novas tarefas e melhora a experiência do usuário.

## Características Principais

### 1. **Deduplicação de Tarefas**
- Remove títulos duplicados mantendo apenas um registro
- Ordena por **data de atualização** (tarefas mais recentes primeiro)
- Preserva a frequência de uso para análise de padrões

### 2. **Filtros Inteligentes**
- **Filtro Dinâmico**: Mostra sugestões baseadas no texto digitado
- **Mostrar Top 5**: Exibe os 5 títulos mais recentes quando campo está vazio
- **Case-Insensitive**: Busca não diferencia maiúsculas/minúsculas

### 3. **Duas Variações de UI**

#### Variação 1: TaskSuggestions (Chips)
```dart
TaskSuggestions(
  allTasks: tasksNotifier.tasks,
  onTaskSelected: (title) { /* callback */ },
  titleController: titleController,
)
```
- Exibe sugestões como **chips interativos**
- Ideal para poucos títulos (até ~10)
- Mais visualmente atrativo
- Boa responsividade em telas pequenas

#### Variação 2: TaskSuggestionsDropdown
```dart
TaskSuggestionsDropdown(
  allTasks: tasksNotifier.tasks,
  onTaskSelected: (title) { /* callback */ },
  titleController: titleController,
)
```
- Exibe sugestões em **dropdown**
- Ideal para muitos títulos (>20)
- Economiza espaço vertical
- Melhor desempenho com grandes volumes

## Integração no TaskDialog

### Implementação Atual

```dart
Consumer<TasksNotifier>(
  builder: (context, tasksNotifier, _) {
    return TaskSuggestions(
      allTasks: tasksNotifier.tasks,
      onTaskSelected: (selectedTitle) {
        // Callback para ações adicionais
      },
      titleController: _titleController,
    );
  },
)
```

### Fluxo de Uso

1. **Usuário abre TaskDialog** → Dialog exibe campo de título
2. **TaskSuggestions renderiza** → Consumer acessa lista de tarefas via Provider
3. **Usuário digita** → Filtro dinâmico mostra sugestões relevantes
4. **Usuário seleciona** → Título é preenchido no TextField via callback
5. **Usuário valida/edita** → Pode modificar antes de salvar

## Classe Helper: TaskHistoryStats

Fornece estatísticas úteis sobre o histórico de tarefas:

```dart
final stats = TaskHistoryStats.fromTasks(allTasks);
print('Total: ${stats.totalTasks}');           // int
print('Únicos: ${stats.uniqueTitles}');        // int
print('Completos: ${stats.completedTasks}');   // int
print('Top 5: ${stats.topTitles}');            // List<String>
```

**Propriedades:**
- `totalTasks`: Total de tarefas no histórico
- `uniqueTitles`: Quantidade de títulos únicos
- `completedTasks`: Quantidade de tarefas concluídas
- `topTitles`: Lista dos 5 títulos mais frequentes

## Estratégia de Deduplicação

### Critério Atual
```dart
// Deduplicação por TÍTULO EXATO
if (task.title.isNotEmpty && !titleSet.contains(task.title)) {
  titleSet.add(task.title);
}
```

**Comportamento:**
- "Estudar" e "Estudar" → 1 sugestão
- "Estudar" e "estudar" → 2 sugestões (case-sensitive)
- "Estudar Flutter" e "Estudar Flutter" → 1 sugestão
- "" (vazio) → Ignorado (não cria sugestão)

### Alternativas Implementáveis

Se precisar de normalização de texto:

```dart
// Opção 1: Normalização (trim + lowercase)
final normalized = title.trim().toLowerCase();

// Opção 2: Whitespace normalizado
final normalized = title.trim().replaceAll(RegExp(r'\s+'), ' ');

// Opção 3: Remover acentos
String removeAccents(String str) {
  var baseChars = 'àáâãäåèéêëìíîïòóôõöùúûüç';
  var baseReplacements = 'aaaaaaeeeeiiiioooouuuuc';
  var string = str.toLowerCase();
  for (var i = 0; i < baseChars.length; i++) {
    string = string.replaceAll(baseChars[i], baseReplacements[i]);
  }
  return string;
}
```

## Integrações Futuras (v1.2.0+)

### Sugestões Avançadas
```dart
// Sugerir descrição, urgência, importância baseado na tarefa anterior
Future<Task?> _getFullTaskSuggestion(String title) async {
  return allTasks.firstWhereOrNull((t) => t.title == title);
}
```

### AutoFill de Campos
```dart
void _fillFromHistory(Task historicTask) {
  _titleController.text = historicTask.title;
  _descriptionController.text = historicTask.description ?? '';
  _isUrgent = historicTask.isUrgent;
  _isImportant = historicTask.isImportant;
  _dueDate = historicTask.dueDate;
}
```

### Busca Avançada
```dart
// Filtrar por data (últimas 30 dias)
// Filtrar por quadrante
// Filtrar por status (completadas/ativas)
// Busca fuzzy (typo tolerance)
```

### Analytics
```dart
// Rastrear qual sugestão foi selecionada
// Medir frequência de reutilização
// Identificar tarefas mais repetidas
```

## Performance

### Otimizações Aplicadas
- ✅ Deduplicação feita em-memória (O(n))
- ✅ Ordenação por data de atualização (O(n log n))
- ✅ Filtro dinâmico usa contains (O(n)) – Aceitável para <1000 itens
- ✅ ValueListenableBuilder reescuta apenas quando titleController muda

### Melhorias Futuras
```dart
// Usar Riverpod/StateNotifier para cache
// Implementar busca fuzzy com algoritmo Levenshtein
// Usar sqlite LIKE queries para filtro em tempo de execução
// Virtualizar lista se >500 itens
```

## Testes

### Casos de Teste Obrigatórios

```dart
testWidgets('TaskSuggestions exibe chip para cada título único', ...);
testWidgets('Deduplicação remove títulos duplicados', ...);
testWidgets('Ordenação coloca títulos mais recentes primeiro', ...);
testWidgets('Filtro dinâmico mostra apenas matches', ...);
testWidgets('Clique em chip preenche titleController', ...);
testWidgets('Vazio mostra top 5 sugestões', ...);
testWidgets('Case-insensitive search funciona', ...);
testWidgets('Sugestões vazias com histórico vazio', ...);
testWidgets('TaskHistoryStats calcula valores corretos', ...);
```

## Troubleshooting

| Problema | Causa | Solução |
|----------|-------|---------|
| Sugestões não aparecem | `allTasks` vazio | Verificar se TasksNotifier carregou dados |
| Duplicatas aparecem | Case diferente | Adicionar normalização em `_getUniqueTitles()` |
| UI lenta com muitos chips | Renderização pesada | Usar `TaskSuggestionsDropdown` |
| Clique não preenche campo | Callback vazio | Verificar `onTaskSelected` callback |
| Sugestão desaparece após digitar | TextField não é ValueListenable | Usar `TextEditingController` (✓ já feito) |

## Changelog

### v1.0.0 (Inicial - v1.2.0-dev)
- ✅ Implementação de `TaskSuggestions` com chips
- ✅ Implementação de `TaskSuggestionsDropdown`
- ✅ Classe `TaskHistoryStats` para análise
- ✅ Integração em `TaskDialog`
- ✅ Deduplicação por título exato
- ✅ Ordenação por data de atualização
- ✅ Filtro dinâmico case-insensitive

### Planned (v1.2.0+)
- 🔲 AutoFill de múltiplos campos
- 🔲 Busca fuzzy com typo tolerance
- 🔲 Filtros avançados (data, quadrante, status)
- 🔲 Histórico de buscas
- 🔲 Analytics de uso
- 🔲 Sincronização com backend

## Referências

- **Arquivo Principal**: `lib/widgets/task_suggestions.dart`
- **Arquivo de Integração**: `lib/widgets/task_dialog.dart`
- **Provider Utilizado**: `lib/providers/tasks_provider.dart`
- **Modelo de Dados**: `lib/models/task.dart`

---

**Última Atualização**: v1.2.0-dev  
**Autor**: Copilot  
**Status**: ✅ Implementado e Integrado
