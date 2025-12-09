# CALL FLOWS - Navegação e Interface

## 1. Navegação & Screens (SplashScreen → AuthScreen → HomeScreen)

### ✨ Descrição Breve

Fluxo inicial do app: animação do splash, redirecionamento para autenticação e,
após login/registro bem-sucedido, navegação para a Home.

### 📊 Diagrama de Fluxo (ASCII)

```
main()
├─ WidgetsFlutterBinding.ensureInitialized()
├─ DatabaseInitializer.initialize()
└─ runApp(MyApp)
    └─ MultiProvider(TasksNotifier)
        └─ MaterialApp(home: SplashScreen)
            └─ SplashScreen.initState()
                ├─ AnimationController.forward()
                └─ Future.delayed(3s)
                    └─ Navigator.pushReplacementNamed('/auth')
                        └─ AuthScreen
                            ├─ _handleSubmit()
                            │   └─ AuthRepository.login()/register()
                            │       └─ database.query()/insert()
                            └─ Navigator.pushReplacementNamed('/home')
                                └─ HomeScreen
                                    ├─ CustomAppBar(showBackButton: false)
                                    ├─ AppDrawer
                                    └─ Grid de ferramentas + Stats placeholder
```

### 🧩 Componentes Envolvidos

- `main.dart`
- `SplashScreen` (`lib/screens/splash.dart`)
- `AuthScreen` (`lib/screens/auth_screen.dart`)
- `HomeScreen` (`lib/screens/home_screen.dart`)
- `CustomAppBar`, `AppDrawer`
- `AuthRepository` (login/register)

### 🔧 Funções/Métodos Principais (ordem)

1. `main()`
2. `DatabaseInitializer.initialize()`
3. `SplashScreen.initState()` → `Future.delayed()` →
   `Navigator.pushReplacementNamed('/auth')`
4. `AuthScreen._handleSubmit()` → `AuthRepository.login/register`
5. `Navigator.pushReplacementNamed('/home')`
6. `HomeScreen.build()` → `CustomAppBar` + `AppDrawer`

### 🎛️ State Management

- `Navigator` para rotas (`/auth`, `/home`)
- `Provider` para `TasksNotifier` (disponível no app, embora não usado no fluxo
  de auth)

### 🚀 Entry Point

`main()` → `MyApp()` → `home: SplashScreen()`

### 🎬 Saída Esperada

- Animação de 3 segundos do logo, tela de autenticação, e depois Home com grid
  de ferramentas.

### 📌 Notas Adicionais

- O splash usa `AnimationController` (2s) + delay (3s).
- Auth ainda requer implementação de segurança real para produção.

### 🔮 Próximas Versões

- Integrar autenticação real (Firebase/AuthProvider) antes de produção.

---

## 2. App Drawer (Menu Lateral)

### ✨ Descrição Breve

Menu lateral com navegação para Home, Matriz de Eisenhower, itens futuros e
atalho para “Sobre o App”.

### 📊 Diagrama de Fluxo (ASCII)

```
CustomAppBar (leading menu)
└─ IconButton.onPressed → Scaffold.of(context).openDrawer()
    └─ AppDrawer.build()
        ├─ DrawerHeader (logo + título)
        ├─ ListView itens
        │   ├─ Início → Navigator.pushReplacementNamed('/home')
        │   ├─ Matriz → Navigator.pushReplacementNamed('/eisenhower')
        │   ├─ Pareto (disabled)
        │   ├─ GUT (disabled)
        │   ├─ Configurações (disabled)
        │   └─ Sobre o App → showDialog(AboutAppScreen)
        └─ Rodapé: versão 1.2.0-dev
```

### 🧩 Componentes Envolvidos

- `AppDrawer` (`lib/widgets/app_drawer.dart`)
- `CustomAppBar` (`lib/widgets/custom_app_bar.dart`)
- `Navigator.pushReplacementNamed`
- `AboutAppScreen` (dialog)

### 🔧 Funções/Métodos Principais (ordem)

1. `CustomAppBar.leading` → `Scaffold.of(context).openDrawer()`
2. `_buildDrawerItem().onTap()` → `Navigator.pop(context)` →
   `Navigator.pushReplacementNamed(route)`
3. ListTile “Sobre o App” → `showDialog(AboutAppScreen)`

### 🎛️ State Management

- `Navigator` para troca de rotas.
- `ModalRoute.of(context)?.settings.name` para saber rota atual (seleção
  visual).

### 🚀 Entry Point

`AppBar` menu button (quando `showBackButton` é falso).

### 🎬 Saída Esperada

- Drawer abre com header + logo, itens de navegação, chips “Em breve” para rotas
  desabilitadas, diálogo “Sobre o App”.

### 📌 Notas Adicionais

- Usa `pushReplacementNamed` para evitar empilhar telas iguais.
- Itens futuros ficam desabilitados com chip “Em breve”.

### 🔮 Próximas Versões

- Ativar itens Pareto e GUT quando implementados.
- Adicionar Configurações quando existir tela.

---

## 3. About App Screen (Dialog Popup)

### ✨ Descrição Breve

Dialog com informações do app: desenvolvedor, versão, stack técnico, roadmap e
licença.

### 📊 Diagrama de Fluxo (ASCII)

```
AppDrawer → ListTile('Sobre o App').onTap
└─ Navigator.pop(drawer)
└─ showDialog(AboutAppScreen)
    └─ Dialog
        ├─ Header (gradient + logo + título + versão)
        ├─ Corpo (seções: Desenvolvedor, Sobre, Stack Técnico, Roadmap, Licença)
        └─ Botão Fechar → Navigator.pop()
```

### 🧩 Componentes Envolvidos

- `AboutAppScreen` (`lib/screens/about_app_screen.dart`)
- `AppDrawer` → ListTile
- `showDialog`, `Navigator.pop`

### 🔧 Funções/Métodos Principais (ordem)

1. `ListTile.onTap` → `Navigator.pop(drawer)` → `showDialog(AboutAppScreen)`
2. `AboutAppScreen.build()` → monta header + seções
3. Botão “Fechar” → `Navigator.pop(context)`

### 🎛️ State Management

- Diálogo modal (`showDialog` + `Navigator`).

### 🚀 Entry Point

ListTile “Sobre o App” no Drawer.

### 🎬 Saída Esperada

- Dialog fullscreen com gradient header, logo, dados do dev, stack, roadmap e
  licença.

### 📌 Notas Adicionais

- Versão exibida: `1.2.0-dev` (atual).

### 🔮 Próximas Versões

- Atualizar roadmap e versão conforme novas releases.
