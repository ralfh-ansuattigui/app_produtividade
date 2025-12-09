# CALL FLOWS - Branding, Informações e Estatísticas

## 1. Logo Integration (Splash, AppBar, Drawer)

### ✨ Descrição Breve

Uso consistente do logo em três pontos: splash (com animação), AppBar e Drawer
header.

### 📊 Diagrama de Fluxo (ASCII)

```
SPLASH
SplashScreen.build()
└─ Scaffold
    └─ Center
        └─ ScaleTransition(Tween 0.5→1.0, Curves.easeOut)
            └─ Column
                ├─ Image.asset('assets/images/logo.png', 200x200)
                └─ Text('Produtividade')

APP BAR
CustomAppBar.build()
└─ AppBar(actions: [logo])
    └─ ClipRRect(borderRadius: 12)
        └─ Image.asset('assets/images/logo.png', 70x70)

DRAWER HEADER
AppDrawer.build()
└─ DrawerHeader(gradient)
    └─ Container(70x70, white bg, shadow)
        └─ ClipRRect(borderRadius: 12)
            └─ Image.asset('assets/images/logo.png', 70x70)
```

### 🧩 Componentes Envolvidos

- `SplashScreen` (`lib/screens/splash.dart`)
- `CustomAppBar` (`lib/widgets/custom_app_bar.dart`)
- `AppDrawer` (`lib/widgets/app_drawer.dart`)
- `assets/images/logo.png`

### 🔧 Funções/Métodos Principais

- `AnimationController.forward()` (splash)
- `ScaleTransition`
- `Image.asset()`

### 🎛️ State Management

- Não há estado; animação controlada por `AnimationController` local no splash.

### 🚀 Entry Point

`main()` → `SplashScreen`; AppBar/Drawer em `HomeScreen` e `EisenhowerScreen`.

### 🎬 Saída Esperada

- Logo animado no splash (scale 0.5→1.0), logo 70x70 na AppBar e no header do
  Drawer.

### 📌 Notas Adicionais

- Manter o asset em `assets/images/logo.png` e referenciado no `pubspec.yaml`.

### 🔮 Próximas Versões

- Considerar tema dark com variação de logo se necessário.

---

## 2. Info Screen (EisenhowerInfoScreen, 2 Abas)

### ✨ Descrição Breve

Tela com informações sobre a Matriz de Eisenhower em duas abas: Orientação
Rápida e Sobre.

### 📊 Diagrama de Fluxo (ASCII)

```
AppBar.infoButton (EisenhowerScreen)
└─ Navigator.push(MaterialPageRoute(EisenhowerInfoScreen))
    └─ EisenhowerInfoScreen
        └─ DefaultTabController(length: 2)
            └─ Scaffold
                ├─ AppBar(title, TabBar[Orientação Rápida, Sobre])
                └─ TabBarView
                    ├─ Tab 1: _QuickOrientationTab
                    │   └─ _buildQuadrantInfo() x4 (Q1..Q4)
                    └─ Tab 2: _AboutTab
                        └─ Seções de texto e dicas
```

### 🧩 Componentes Envolvidos

- `EisenhowerInfoScreen` (`lib/screens/eisenhower_info_screen.dart`)
- `DefaultTabController`, `TabBar`, `TabBarView`
- `_QuickOrientationTab`, `_AboutTab`

### 🔧 Funções/Métodos Principais

- `Navigator.push(MaterialPageRoute)`
- `DefaultTabController` construção
- `_buildQuadrantInfo()` helpers

### 🎛️ State Management

- Gerenciado pelo `DefaultTabController` interno (tabs).

### 🚀 Entry Point

Ícone de info no AppBar da `EisenhowerScreen`.

### 🎬 Saída Esperada

- Tela com duas abas: exemplos e dicas dos quadrantes; histórico/uso da matriz.

### 📌 Notas Adicionais

- Conteúdo estático; sem chamada a repositório.

### 🔮 Próximas Versões

- Adicionar links externos ou vídeo explicativo.

---

## 3. Stats Card (Resumo Placeholder)

### ✨ Descrição Breve

Card de resumo exibido na Home; atualmente placeholder (v1.1.0) com plano de
mover para aba dedicada em v1.2.0.

### 📊 Diagrama de Fluxo (ASCII)

```
HomeScreen.build()
└─ Column
    ├─ _buildWelcomeBanner()
    ├─ _buildToolsGrid()
    ├─ Text('Resumo das Tarefas')
    └─ _buildStatsCard(context)
        └─ Card (valores estáticos v1.1.0)

Planejado v1.2.0:
EisenhowerScreen
└─ DefaultTabController(length: 2)
    ├─ Tab 1: Grid 2x2 (existente)
    └─ Tab 2: StatisticsView
        └─ Consumer<TasksNotifier>
            └─ TaskStatistics.fromTasks(tasks)
```

### 🧩 Componentes Envolvidos

- `HomeScreen` (`lib/screens/home_screen.dart`)
- Futuro: `Consumer<TasksNotifier>` para dados dinâmicos
- Futuro: `_StatisticsView` (planejado)

### 🔧 Funções/Métodos Principais

- Atual: `_buildStatsCard()` (placeholder)
- Futuro: `TaskStatistics.fromTasks()`

### 🎛️ State Management

- Atual: estático; Futuro: `Consumer<TasksNotifier>`.

### 🚀 Entry Point

`HomeScreen` body.

### 🎬 Saída Esperada

- v1.1.0: card estático; v1.2.0: métricas dinâmicas por quadrante.

### 📌 Notas Adicionais

- Deverá ser movido para EisenhowerScreen em uma aba dedicada.

### 🔮 Próximas Versões

- Implementar aba de estatísticas dinâmica (v1.2.0), incluindo totais,
  concluídas, atrasadas por quadrante.
