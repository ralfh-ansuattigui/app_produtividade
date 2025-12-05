# 🔧 Troubleshooting - Erro ao Registrar

## 🚨 Problema: Erro ao Registrar Usuário

Se você está recebendo um erro ao tentar registrar um novo usuário, siga este
guia de resolução.

---

## 🔍 Passo 1: Diagnosticar o Problema

### Adicione diagnóstico no seu código

Adicione isso no `main.dart` ou em um widget de debug:

```dart
import 'package:app_produtividade/database/database_diagnostics.dart';

// Na função main ou no initState:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Rode diagnóstico
  await DatabaseDiagnostics.runDiagnostics();
  
  runApp(const MyApp());
}
```

### O que procurar nos logs

```
✅ Banco inicializado com sucesso    → OK
✅ Banco está aberto                 → OK
✅ Tabela users encontrada           → OK
✅ Tabela tasks encontrada           → OK
✅ Total de usuários: X              → OK
```

Se qualquer item estiver ❌, veja abaixo.

---

## ❌ Erros Comuns e Soluções

### Erro 1: "Banco não foi inicializado"

**Sintoma:**

```
❌ Falha na inicialização
❌ Tabela users não encontrada
```

**Solução:**

1. Limpe o cache do Flutter:

```bash
flutter clean
flutter pub get
```

2. Resetar o banco:

```dart
await DatabaseDiagnostics.resetDatabase();
```

3. Rode novamente:

```bash
flutter run
```

---

### Erro 2: "Erro de acesso ao banco de dados"

**Sintoma:**

```
❌ Erro ao registrar usuário: ...database...
❌ Erro ao consultar usuários
```

**Solução:**

1. Feche todas as instâncias do app
2. Delete o banco de dados manualmente
3. Execute novamente

**No seu código:**

```dart
import 'package:app_produtividade/database/database_diagnostics.dart';

// Resete o banco
await DatabaseDiagnostics.resetDatabase();
```

---

### Erro 3: "Tabelas não foram criadas"

**Sintoma:**

```
❌ Tabela users não encontrada
```

**Solução:**

1. Verifique se `_onCreate` está sendo chamado
2. Execute diagnóstico:

```dart
await DatabaseDiagnostics.runDiagnostics();
```

3. Se ainda não funcionar, reset:

```dart
await DatabaseDiagnostics.resetDatabase();
```

---

### Erro 4: "Exception: Erro ao registrar usuário"

**Sintoma:**

```
Exception: Erro ao registrar usuário: ...
```

**Causa comum:** Banco não está inicializado corretamente

**Solução:**

1. Verifique se `main()` é async e chama a inicialização:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseInitializer.initialize();
  runApp(const MyApp());
}
```

2. Se ainda não funcionar, rode diagnóstico e reset.

---

## 🛠️ Guia de Diagnóstico Passo a Passo

### Passo 1: Verificar Inicialização

Adicione no seu `splash.dart` ou no `main.dart`:

```dart
import 'package:app_produtividade/database/database_diagnostics.dart';

@override
void initState() {
  super.initState();
  
  // Diagnóstico
  DatabaseDiagnostics.runDiagnostics().then((_) {
    debugPrint('✅ Diagnóstico concluído');
  });
  
  // ... resto do código
}
```

### Passo 2: Verificar Logs

Abra o terminal e procure por:

```
✅ ✅ ✅ = Tudo OK
❌ = Há um problema
```

### Passo 3: Resolver Problemas

Se houver ❌:

1. **Se erro de inicialização:**
   ```dart
   await DatabaseDiagnostics.resetDatabase();
   ```

2. **Se erro de acesso:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **Se erro de estrutura:**
   ```dart
   await DatabaseDiagnostics.resetDatabase();
   ```

---

## 🔄 Resetar Banco Completamente

Se nenhuma solução acima funcionar, faça um reset completo:

### Opção 1: Via Código

```dart
import 'package:app_produtividade/database/database_diagnostics.dart';

// Na sua tela ou no main
void onResetPressed() async {
  final success = await DatabaseDiagnostics.resetDatabase();
  if (success) {
    print('✅ Banco resetado com sucesso');
    // Reiniciar o app
  }
}
```

### Opção 2: Via Terminal

```bash
# 1. Limpar
flutter clean

# 2. Reinstalar dependências
flutter pub get

# 3. Rodar
flutter run
```

### Opção 3: Deletar Arquivo do Banco

Encontrar o arquivo do banco e deletar:

- **Android:**
  `/data/data/com.example.app_produtividade/databases/app_produtividade.db`
- **iOS:**
  `~/Library/Developer/CoreSimulator/Devices/.../Documents/app_produtividade.db`

Depois, execute `flutter run` novamente.

---

## ✅ Verificação Final

Após resolver o problema:

1. Execute diagnóstico:

```dart
await DatabaseDiagnostics.runDiagnostics();
```

2. Procure por:

```
✅ Banco inicializado com sucesso
✅ Banco está aberto
✅ Tabela users encontrada
✅ Tabela tasks encontrada
✅ Total de usuários: X
```

3. Tente registrar um novo usuário
4. Se funcionar ✅, o problema foi resolvido!

---

## 📝 Checklist de Debug

- [ ] Executei `flutter clean`?
- [ ] Executei `flutter pub get`?
- [ ] Rodei o diagnóstico?
- [ ] Vi todos os ✅?
- [ ] Reseti o banco se necessário?
- [ ] Testei o registro novamente?

---

## 🆘 Ainda não Funciona?

Se ainda estiver com problema, compartilhe:

1. **Output do diagnóstico:**

```dart
await DatabaseDiagnostics.runDiagnostics();
```

2. **Mensagem de erro exata** que você vê

3. **Passos que você já tentou**

---

## 📚 Referências

- Ver: `database_factory.dart` - Inicialização do banco
- Ver: `database_initializer.dart` - Verificações
- Ver: `database_diagnostics.dart` - Diagnóstico
- Ver: `auth_repository.dart` - Operações de banco

---

**Última atualização:** 05/12/2025 **Versão:** 1.0 (com fixes)
