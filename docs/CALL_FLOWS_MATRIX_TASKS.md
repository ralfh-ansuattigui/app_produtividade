# CALL FLOWS - Matriz de Eisenhower e Tarefas

## 1. Eisenhower Matrix (Grid 2x2 com Quadrantes)

### ✨ Descrição Breve

Tela principal da matriz com 4 quadrantes (Urgente/Importante) carregando
tarefas do repositório e exibindo grid interativo.

### 📊 Diagrama de Fluxo (ASCII)

```
EisenhowerScreen
├─ initState()
│  └─ Future.microtask(() => context.read<TasksNotifier>().loadTasks())
│      └─ TasksNotifier.loadTasks()
│          ├─ _isLoading = true; notifyListeners()
│          ├─ TaskRepository.getAll()
│          │   └─ DatabaseFactory.database.query('tasks')
│          ├─ _tasks = result; _isLoading = false
│          └─ notifyListeners()
│
├─ AppBar(title: 'Matriz de Eisenhower', actions: [InfoButton])
│  └─ IconButton.onPressed → Navigator.push(EisenhowerInfoScreen)
│
└─ body: Consumer<TasksNotifier>
    ├─ if isLoading → CircularProgressIndicator
    ├─ if error → Text('Erro')
    └─ _buildGrid()
        ├─ Labels horizontais (Importante | Não Importante)
        ├─ Labels verticais (Urgente | Não Urgente)
        └─ 4× QuadrantCard(quadrant 1..4)
            ├─ DragTarget<Task> (para mover entre quadrantes)
            ├─ ReorderableListView (reordenação interna)
            ├─ GestureDetector (double tap → onAddTask)
            └─ _MagnifyButton → showDialog(QuadrantDetailModal)

FloatingActionButton.extended('Nova Tarefa')
└─ _showAddTaskDialog(context)
    └─ TaskDialog (criação)
```

### 🧩 Componentes Envolvidos

- `EisenhowerScreen` (`lib/screens/eisenhower_screen.dart`)
- `QuadrantCard` (`lib/widgets/quadrant_card.dart`)
- `TasksNotifier` (`lib/providers/tasks_provider.dart`)
- `TaskRepository` (`lib/repositories/task_repository.dart`)
- `TaskDialog`, `QuadrantDetailModal`, `_MagnifyButton`
- `EisenhowerInfoScreen`

### 🔧 Funções/Métodos Principais (ordem)

1. `EisenhowerScreen.initState()` → `TasksNotifier.loadTasks()`
2. `TaskRepository.getAll()` → DB query
3. `Consumer<TasksNotifier>` → `_buildGrid()`
4. `QuadrantCard` renderiza `ReorderableListView`
5. `FloatingActionButton` → `_showAddTaskDialog()`

### 🎛️ State Management

- `Provider` / `Consumer<TasksNotifier>` para tarefas.
- `ChangeNotifier` para updates (`notifyListeners`).

### 🚀 Entry Point

`Navigator.pushNamed('/eisenhower')` a partir do grid de ferramentas ou drawer.

### 🎬 Saída Esperada

Grid 2x2 colorido com tarefas por quadrante, possibilidade de arrastar entre
quadrantes, reordenação interna e botão de criação.

### 📌 Notas Adicionais

- Carregamento inicial usa `Future.microtask` para evitar context invalido no
  initState.
- InfoButton abre tela de informações (EisenhowerInfoScreen).

### 🔮 Próximas Versões

- Mover aba de estatísticas para esta tela (v1.2.0 planejado).

---

## 2. Task Management (CRUD)

### ✨ Descrição Breve

Criação, leitura, atualização e exclusão de tarefas com persistência em SQLite
via TaskRepository.

### 📊 Diagrama de Fluxo (ASCII)

```
CREATE
FloatingActionButton / double-tap Quadrant
└─ _showAddTaskDialog(context)
    └─ TaskDialog
        ├─ inputs: title, description, dueDate, urgent, important
        ├─ _updateQuadrant() conforme urgente/important
        └─ onSave → TasksNotifier.createTask(task)
            └─ TaskRepository.create(task)
                └─ database.insert('tasks')
                    └─ notifyListeners()

READ / DETAIL
_TaskTile.onTap()
└─ _showTaskDetailDialog(task)
    └─ Dialog com dados + toggleComplete + delete

UPDATE
Dialog edit
└─ TasksNotifier.updateTask(task)
    └─ TaskRepository.update(task)
        └─ database.update('tasks')
            └─ notifyListeners()

DELETE
Dialog delete
└─ TasksNotifier.deleteTask(id)
    └─ TaskRepository.delete(id)
        └─ database.delete('tasks')
            └─ notifyListeners()
```

### 🧩 Componentes Envolvidos

- `TaskDialog`, `_TaskDetailDialog` (dentro do fluxo principal)
- `TasksNotifier`
- `TaskRepository`
- `Task` model

### 🔧 Funções/Métodos Principais (ordem)

- `TasksNotifier.createTask`, `updateTask`, `deleteTask`
- `TaskRepository.create`, `update`, `delete`
- `database.insert/update/delete`

### 🎛️ State Management

- `ChangeNotifier` + `notifyListeners` para refletir mudanças na UI.

### 🚀 Entry Point

- Botão “Nova Tarefa” ou double tap no quadrante.

### 🎬 Saída Esperada

- Tarefa criada/editada/deletada com atualização imediata na UI e persistência
  em DB.

### 📌 Notas Adicionais

- Criação insere no topo da lista (`_tasks.insert(0, created)`).

### 🔮 Próximas Versões

- Validações de entrada e segurança de dados.

---

## 3. Reordenação de Tarefas (Drag & Drop)

### ✨ Descrição Breve

Permite mover tarefas entre quadrantes e reordenar dentro do mesmo quadrante.

### 📊 Diagrama de Fluxo (ASCII)

```
MOVER ENTRE QUADRANTES
_TaskTile (Draggable<Task>)
└─ DragTarget<Task> em QuadrantCard
    ├─ onWillAcceptWithDetails → valida quadrant diferente
    └─ onAcceptWithDetails → onTaskMoved(task, targetQuadrant)
        └─ TasksNotifier.moveTask(id, quadrant)
            └─ TaskRepository.move(id, quadrant)
                └─ database.update('tasks')
                    └─ notifyListeners()

REORDENAR NO MESMO QUADRANTE
ReorderableListView.onReorder(oldIndex, newIndex)
└─ TasksNotifier.reorderTasksInQuadrant(quadrant, from, to)
    ├─ reordena lista local do quadrante
    └─ notifyListeners() (sem persistência de ordem no DB)
```

### 🧩 Componentes Envolvidos

- `Draggable<Task>`, `DragTarget<Task>` (em `_TaskTile` e `QuadrantCard`)
- `ReorderableListView`
- `TasksNotifier`, `TaskRepository`

### 🔧 Funções/Métodos Principais (ordem)

- `onTaskMoved` → `TasksNotifier.moveTask` → `TaskRepository.move`
- `onReorder` → `TasksNotifier.reorderTasksInQuadrant`

### 🎛️ State Management

- `ChangeNotifier` para refletir movimentos/reordenação.

### 🚀 Entry Point

- Gesture de arrastar (`Draggable`) dentro de `QuadrantCard`.

### 🎬 Saída Esperada

- Tarefa se move entre quadrantes (com persistência do quadrant),
- Reordenação interna só na memória (ordem visual).

### 📌 Notas Adicionais

- Ordem não é persistida no DB; apenas o quadrante é persistido.

### 🔮 Próximas Versões

- Persistir ordem por `sort_order` no DB, se desejado.

---

## 4. Quadrant Detail Modal

### ✨ Descrição Breve

Modal fullscreen exibindo as tarefas de um quadrante com status visual e
callback de tap.

### 📊 Diagrama de Fluxo (ASCII)

```
_MagnifyButton.onTap()
└─ showDialog(QuadrantDetailModal)
    └─ Dialog + Scaffold
        ├─ AppBar (close)
        └─ body:
            ├─ if tasks.isEmpty → mensagem vazia
            └─ ListView.builder
                ├─ InkWell.onTap → onTaskTap(task); Navigator.pop()
                ├─ Cor de fundo = dueStatusColor(task)
                └─ Badges: número, status (VENCIDA, HOJE, etc), data
```

### 🧩 Componentes Envolvidos

- `_MagnifyButton` e `QuadrantDetailModal` (`lib/widgets/quadrant_card.dart`)
- `Task` model (para status)

### 🔧 Funções/Métodos Principais (ordem)

- `_MagnifyButton.onTap` → `showDialog`
- `_getDueStatusColor`, `_getDueStatusText`, `_formatDate`
- `InkWell.onTap` → `onTaskTap(task)` → `Navigator.pop`

### 🎛️ State Management

- Dialog modal; estado derivado da lista de tarefas fornecida.

### 🚀 Entry Point

- Botão de lupa no canto do QuadrantCard.

### 🎬 Saída Esperada

- Modal com lista detalhada; ao tocar em tarefa, fecha modal e aciona callback
  de detalhe/edição.

### 📌 Notas Adicionais

- Reaproveita mesmas cores de status usadas nos tiles.

### 🔮 Próximas Versões

- Adicionar ações rápidas (completar/deletar) diretamente no modal.
