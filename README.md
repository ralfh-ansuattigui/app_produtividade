# App Produtividade 📊

Um aplicativo Flutter multiplataforma que implementa a **Matriz de Eisenhower** para gerenciamento de produtividade pessoal com suporte para Android, iOS, Web, Windows, macOS e Linux.

## Visão Geral

App Produtividade ajuda você a organizar tarefas em 4 quadrantes baseado na urgência e importância:

1. **Urgente & Importante** - Fazer Agora
2. **Não Urgente & Importante** - Agendar
3. **Urgente & Não Importante** - Delegar
4. **Não Urgente & Não Importante** - Eliminar

### Recursos Principais

- ✅ **Matriz de Eisenhower** com 4 quadrantes responsivos
- ✅ **Drag & Drop** para mover tarefas entre quadrantes
- ✅ **Data de Prazo** com avisos visuais:
  - 🔴 **VENCIDA** (vermelho) - Tarefas atrasadas
  - 🟠 **HOJE** (laranja) - Vence hoje
  - 📅 **1 dia** (laranja claro) - Vence amanhã
  - 📅 **2 dias** (amarelo) - Vence em 2 dias
- ✅ **Marcar Completo** e **Deletar** tarefas
- ✅ **Banco de Dados Local** (SQLite)
- ✅ **UI Responsiva** adaptável a diferentes tamanhos de tela

## Arquitetura

```
lib/
├── main.dart                 # Entry point com providers
├── models/
│   └── task.dart            # Task model com DueStatus enum
├── database/
│   └── database_factory.dart # SQLite factory (v3 com due_date)
├── repositories/
│   └── task_repository.dart  # Data access layer
├── providers/
│   └── tasks_provider.dart   # State management (ChangeNotifier)
├── screens/
│   ├── home_screen.dart
│   ├── splash.dart
│   └── eisenhower_screen.dart
└── widgets/
    ├── quadrant_card.dart    # Card com DragTarget
    ├── task_dialog.dart      # Dialog com date picker
```

## Stack Técnico

- **Framework**: Flutter 3.10.3+
- **State Management**: Provider 6.0.0
- **Database**: SQLite (sqflite 2.3.0)
- **Desktop Support**: sqflite_common_ffi
- **Segurança**: bcrypt para futuras autenticações

## Plataformas Suportadas

- ✅ **Android** (API 21+) - **NOVO**
- ✅ **iOS** (12.0+)
- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **Windows** (Desktop)
- ✅ **macOS** (Desktop)
- ✅ **Linux** (Desktop)

## Instalação & Setup

### Pré-requisitos

- Flutter SDK 3.10.3+ ([Download](https://flutter.dev/docs/get-started/install))
- Dart SDK (incluído com Flutter)
- Android Studio (para suporte Android)

### Clonar e Executar

```bash
# Clone o repositório
git clone <repo-url>
cd app_produtividade

# Obter dependências
flutter pub get

# Executar em debug
flutter run

# Executar em release
flutter run --release
```

## Build por Plataforma

### Android

```bash
# APK Debug
flutter build apk --debug

# APK Release (otimizado para App Store)
flutter build apk --release --split-per-abi

# Android App Bundle (para Google Play)
flutter build appbundle --release
```

**Arquivo gerado**: `build/app/outputs/flutter-apk/app-debug.apk`

Ver [ANDROID_BUILD_GUIDE.md](./ANDROID_BUILD_GUIDE.md) para instruções detalhadas.

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

### Windows

```bash
flutter build windows --release
```

### macOS

```bash
flutter build macos --release
```

### Linux

```bash
flutter build linux --release
```

## Estrutura do Banco de Dados

### Tabela: users
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
```

### Tabela: tasks (v3)
```sql
CREATE TABLE tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  is_completed INTEGER DEFAULT 0,
  priority INTEGER DEFAULT 1,
  quadrant INTEGER DEFAULT 1,
  due_date TEXT,                          -- NOVO em v3
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
)
```

## Uso

### Adicionar Tarefa

1. Clique no botão "Adicionar" no quadrante desejado
2. Preencha título e descrição (opcional)
3. Selecione a data de prazo (opcional)
4. Escolha o quadrante (ou confirme o pré-selecionado)
5. Clique "Salvar"

### Mover Tarefa (Drag & Drop)

1. Segure uma tarefa em um quadrante
2. Arraste até outro quadrante
3. Solte para confirmar a mudança

### Marcar Completo

1. Clique em uma tarefa para abrir detalhes
2. Clique "Marcar Completo"

### Deletar Tarefa

1. Clique em uma tarefa para abrir detalhes
2. Clique "Deletar" (confirmação necessária)

## Roadmap

- [ ] Autenticação de usuários (BCrypt + Backend)
- [ ] Sincronização com servidor (Firebase/Custom API)
- [ ] Notificações de lembrete
- [ ] Matriz de Pareto (80/20)
- [ ] Matriz GUT (Gravity-Urgency-Tendency)
- [ ] Exportar tarefas (PDF/CSV)
- [ ] Tema escuro
- [ ] Múltiplos idiomas

## Desenvolvimento

### Executar Testes

```bash
flutter test
```

### Análise Estática

```bash
flutter analyze
```

### Formato de Código

```bash
dart format lib/
```

### Generate Build Runners (se necessário)

```bash
flutter pub run build_runner build
```

## Troubleshooting

### Build Android Falha

```bash
flutter clean
flutter pub get
flutter build apk --debug
```

### Dispositivo não encontrado

```bash
adb devices
adb kill-server
adb start-server
```

### Erro de permissão no Windows

Alguns erros de permissão ao deletar diretórios no Windows podem ser ignorados - não afetam o build final.

## Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## Licença

Este projeto está sob a licença MIT. Veja [LICENSE](LICENSE) para detalhes.

## Contato

📧 Email: ralfh@example.com
🐙 GitHub: [@ralfh-ansuattigui](https://github.com/ralfh-ansuattigui)

## Referências

- [Flutter Documentation](https://flutter.dev/docs)
- [Eisenhower Matrix](https://en.wikipedia.org/wiki/Time_management#Eisenhower_matrix)
- [Android Build Guide](./ANDROID_BUILD_GUIDE.md)
- [Provider Package](https://pub.dev/packages/provider)

