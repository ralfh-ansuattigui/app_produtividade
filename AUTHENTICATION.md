# Sistema de Autenticação - App Produtividade

## 📋 Visão Geral

Este documento descreve a implementação do sistema de autenticação e persistência de dados do App Produtividade.

## 🗄️ Arquitetura do Banco de Dados

### DatabaseFactory (`lib/database/database_factory.dart`)

Factory pattern para gerenciar a conexão com SQLite:

```dart
// Inicializar banco
final db = await DatabaseFactory().database;
```

**Tabelas criadas:**
- `users` - Armazena informações de usuários (username, email, senha hasheada)
- `tasks` - Armazena tarefas dos usuários (relacionada via user_id)

### Fluxo de Inicialização

1. `DatabaseFactory._initDatabase()` - Abre a conexão
2. `_onCreate()` - Cria as tabelas na primeira execução
3. `_onUpgrade()` - Gerencia migrations de schema

## 🔐 Autenticação

### Componentes

1. **AuthService** (`lib/services/auth_service.dart`)
   - Hash de senhas com bcrypt
   - Validação de email e username
   - Verificação de força de senha

2. **AuthRepository** (`lib/repositories/auth_repository.dart`)
   - Operações CRUD de usuários
   - Lógica de registro e login
   - Validações de negócio

3. **AuthProvider** (`lib/providers/auth_provider.dart`)
   - State management com Provider
   - Gerencia estado de autenticação
   - Notifica mudanças na UI

4. **AuthScreen** (`lib/screens/auth_screen.dart`)
   - Interface de login/registro
   - Validação de formulário
   - Feedback ao usuário

## 🔑 Fluxo de Autenticação

### Registro

```dart
final user = await _authRepository.register(
  username: 'joao',
  email: 'joao@example.com',
  password: 'senha123'
);
// Senha é hasheada com bcrypt antes de armazenar
```

**Validações:**
- Username único
- Email único
- Senha mínimo 6 caracteres
- Email válido

### Login

```dart
final user = await _authRepository.login(
  username: 'joao',
  password: 'senha123'
);
// Verifica hash da senha com bcrypt
```

**Segurança:**
- Senha hasheada não é reversível
- Comparação segura com BCrypt.checkpw()
- Mensagens de erro genéricas (não revela se user existe)

## 📦 Dependências Adicionadas

```yaml
dependencies:
  sqflite: ^2.3.0          # SQLite para Flutter
  path: ^1.8.3             # Localizar diretório do banco
  bcrypt: ^2.1.0           # Hash seguro de senhas
  provider: ^6.0.0         # State management
```

## 🛠️ Como Usar

### 1. Inicializar o Banco na App

```dart
void main() {
  // Garantir que o banco está acessível
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
```

### 2. Usar AuthProvider em MultiProvider

```dart
MaterialApp(
  home: MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
    ],
    child: const MyApp(),
  ),
)
```

### 3. Fazer Login

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
await authProvider.login(
  username: username,
  password: password,
);
```

### 4. Acessar Usuário Autenticado

```dart
final currentUser = Provider.of<AuthProvider>(context).currentUser;
if (currentUser != null) {
  print('Usuário: ${currentUser.username}');
}
```

## 📱 Tela de Autenticação

A `AuthScreen` fornece:
- ✅ Validação de formulário
- ✅ Alternância entre login/registro
- ✅ Máscaras de visibilidade de senha
- ✅ Indicador de carregamento
- ✅ Mensagens de erro e sucesso
- ✅ Responsividade

## 🔄 Fluxo de Navegação

```
SplashScreen (3s)
    ↓
AuthScreen (login/registro)
    ↓
HomeScreen (app principal)
```

## 🛡️ Segurança

1. **Senhas**: Hasheadas com bcrypt (não reversível)
2. **Validação**: Email e username únicos no banco
3. **Mensagens**: Genéricas para evitar revelação de dados
4. **Confirmar Senha**: Validação no registro

## 📊 Modelo de Dados - User

```dart
User(
  id: 1,
  username: 'joao',
  email: 'joao@example.com',
  passwordHash: '$2b$12$...',  // bcrypt hash
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
)
```

## 🚀 Próximos Passos

1. **Persistência de Sessão**: Salvar token/ID do usuário em SharedPreferences
2. **Refresh de Token**: Implementar refresh automático de sessão
3. **Biometria**: Adicionar autenticação com fingerprint/face
4. **Recuperação de Senha**: Implementar reset de senha
5. **Testes**: Adicionar testes unitários e de integração

## 📝 Exemplo Completo

```dart
// Registrar
final authProvider = Provider.of<AuthProvider>(context, listen: false);
bool success = await authProvider.register(
  username: 'novo_user',
  email: 'novo@example.com',
  password: 'senha123',
);

if (success) {
  Navigator.pushReplacementNamed(context, '/home');
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(authProvider.errorMessage ?? 'Erro desconhecido')),
  );
}
```

## 🐛 Troubleshooting

**Erro: "sqflite not found"**
- Execute `flutter pub get`
- Limpe build: `flutter clean`

**Erro: "bcrypt not found"**
- Verifique pubspec.yaml
- Execute `flutter pub get`

**Banco corrompido**
```dart
// Deletar e recriar
await DatabaseFactory().deleteDatabase();
```
