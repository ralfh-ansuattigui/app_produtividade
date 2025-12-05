# 🚀 Quick Start Guide - Sistema de Autenticação

## 📋 Arquivos Criados

```
lib/
├── database/
│   └── database_factory.dart          ← Factory SQLite
├── models/
│   └── user.dart                      ← Modelo User
├── services/
│   └── auth_service.dart              ← Serviço de autenticação
├── repositories/
│   └── auth_repository.dart           ← Repositório de dados
├── providers/
│   └── auth_provider.dart             ← State management
├── screens/
│   └── auth_screen.dart               ← Tela de login/registro
├── main.dart                          ← Atualizado com rotas
└── main_with_provider.dart            ← Exemplo com Provider

Documentação/
├── AUTHENTICATION.md                  ← Guia completo
├── IMPLEMENTATION_SUMMARY.md          ← Resumo da implementação
└── QUICK_START.md                     ← Este arquivo
```

## 🎯 O que fazer agora

### 1️⃣ Instalar dependências
```bash
cd "c:\Users\ansua\OneDrive\Projetos Pessoais\app_produtividade"
flutter pub get
```

### 2️⃣ Rodar o app
```bash
flutter run
```

### 3️⃣ Testar a autenticação
- Clique em "Registre-se"
- Crie um novo usuário:
  - Username: `testeuser`
  - Email: `teste@email.com`
  - Senha: `senha123`
- Faça login com os dados criados
- Será redirecionado para HomeScreen

## 🔑 Recursos Principais

### ✅ Autenticação
- [x] Registro com validações
- [x] Login seguro
- [x] Hash bcrypt de senhas
- [x] Validação de email
- [x] Confirmação de senha

### ✅ Banco de Dados
- [x] SQLite com Factory Pattern
- [x] Tabelas users e tasks
- [x] Índices otimizados
- [x] Suporte a migrações

### ✅ Interface
- [x] Tela de login/registro
- [x] Toggle entre modes
- [x] Indicador de carregamento
- [x] Mensagens de erro/sucesso
- [x] Masks de visibilidade de senha

## 💾 Tabelas do Banco

### users
```
id (INTEGER, PRIMARY KEY)
username (TEXT, UNIQUE)
email (TEXT, UNIQUE)
password_hash (TEXT)
created_at (TEXT)
updated_at (TEXT)
```

### tasks
```
id (INTEGER, PRIMARY KEY)
user_id (INTEGER, FOREIGN KEY)
title (TEXT)
description (TEXT)
is_completed (INTEGER)
priority (INTEGER)
created_at (TEXT)
updated_at (TEXT)
```

## 🔐 Segurança

- ✅ Senhas hasheadas com bcrypt
- ✅ Validação de entrada
- ✅ Email e username únicos
- ✅ Mensagens genéricas de erro
- ✅ Confirmação de senha no registro

## 📱 Navegação

```
SplashScreen (3 segundos)
    ↓
AuthScreen (Login/Registro)
    ├─ Já tem conta? → Login
    └─ Não tem conta? → Registro
    ↓
HomeScreen (App Principal)
```

## 🎨 Usar em MultiProvider (Opcional)

Se quiser usar state management avançado, veja `main_with_provider.dart` para exemplo de integração com Provider.

## 📞 Métodos Principais

### AuthRepository
```dart
// Registrar
await authRepository.register(
  username: 'user',
  email: 'user@email.com',
  password: 'pass123'
);

// Login
await authRepository.login(
  username: 'user',
  password: 'pass123'
);

// Buscar usuário
final user = await authRepository.getUserByUsername('user');
```

### AuthService
```dart
// Hash de senha
String hash = authService.hashPassword('senha123');

// Verificar senha
bool isValid = authService.verifyPassword('senha123', hash);

// Validar email
bool isValid = authService.validateEmail('user@email.com');

// Validar username
bool isValid = authService.validateUsername('user123');
```

## ⚠️ Troubleshooting

### Erro: "sqflite not found"
```bash
flutter clean
flutter pub get
flutter run
```

### Erro ao fazer login
- Verifique se o username/email está correto
- Certifique-se que o usuário foi registrado
- Verifique a senha (case-sensitive)

### Banco corrompido
```dart
await DatabaseFactory().deleteDatabase();
// O banco será recriado na próxima execução
```

## 🌟 Próximas Features (Sugeridas)

1. **Persistência de Sessão**
   - Guardar user_id em SharedPreferences
   - Auto-login se sessão válida

2. **Recuperação de Senha**
   - Email de reset
   - Token temporário

3. **Biometria**
   - Fingerprint
   - Face recognition

4. **Social Login**
   - Google Sign-In
   - Facebook Login

5. **Dashboard do Usuário**
   - Ver perfil
   - Editar dados
   - Mudar senha

## 📚 Referências

- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [bcrypt Package](https://pub.dev/packages/bcrypt)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Flutter Database Documentation](https://flutter.dev/docs/development/data-and-backend)

---

**🎉 Pronto! Seu sistema de autenticação está implementado e funcionando!**

Para dúvidas, veja AUTHENTICATION.md para documentação completa.
