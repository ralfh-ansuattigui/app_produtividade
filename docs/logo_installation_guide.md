# 🎨 Guia de Instalação do Logotipo

## Passo 1: Preparar o Arquivo de Logotipo

### Requisitos do Arquivo

- **Formato**: PNG (com transparência) ou JPG
- **Tamanho mínimo**: 1024x1024 pixels (quadrado)
- **Qualidade**: Alta resolução
- **Fundo**: Transparente (recomendado) ou colorido

---

## Passo 2: Criar a Pasta de Assets

Execute no terminal:

```powershell
cd "C:\Users\ansua\OneDrive\Projetos Pessoais\app_produtividade"
New-Item -ItemType Directory -Path "assets\images" -Force
```

---

## Passo 3: Copiar o Logotipo para o Projeto

**Opção A - Se o logo está na Área de Trabalho:**

```powershell
Copy-Item "$env:USERPROFILE\Desktop\logo.png" -Destination "assets\images\logo.png"
```

**Opção B - Se está em outra pasta:**

```powershell
Copy-Item "CAMINHO_COMPLETO\logo.png" -Destination "assets\images\logo.png"
```

---

## Passo 4: Registrar Assets no pubspec.yaml

Adicione estas linhas no arquivo `pubspec.yaml`, na seção `flutter:`:

```yaml
flutter:
    uses-material-design: true

    # Adicionar assets de imagem
    assets:
        - assets/images/logo.png
        - assets/images/
```

---

## Passo 5: Usar o Logotipo no Código

### 5.1 - Atualizar CustomAppBar

No arquivo `lib/widgets/custom_app_bar.dart`, substituir o ícone por imagem:

```dart
// ANTES (ícone gradiente)
Container(
  width: 40,
  height: 40,
  decoration: BoxDecoration(
    gradient: LinearGradient(...),
    borderRadius: BorderRadius.circular(8),
  ),
  child: const Icon(
    Icons.check_circle_outline,
    color: Colors.white,
    size: 24,
  ),
),

// DEPOIS (logo real)
Container(
  width: 40,
  height: 40,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.asset(
      'assets/images/logo.png',
      width: 40,
      height: 40,
      fit: BoxFit.cover,
    ),
  ),
),
```

### 5.2 - Atualizar AppDrawer

No arquivo `lib/widgets/app_drawer.dart`, no header:

```dart
// ANTES
Container(
  width: 70,
  height: 70,
  decoration: BoxDecoration(
    gradient: LinearGradient(...),
    shape: BoxShape.circle,
  ),
  child: const Icon(
    Icons.check_circle_outline,
    color: Colors.white,
    size: 40,
  ),
),

// DEPOIS
Container(
  width: 70,
  height: 70,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white,
    boxShadow: [...],
  ),
  child: ClipOval(
    child: Image.asset(
      'assets/images/logo.png',
      width: 70,
      height: 70,
      fit: BoxFit.cover,
    ),
  ),
),
```

### 5.3 - Atualizar Splash Screen

No arquivo `lib/screens/splash.dart`:

```dart
// Substituir ícone por logo
Image.asset(
  'assets/images/logo.png',
  width: 120,
  height: 120,
),
```

---

## Passo 6: Atualizar Ícone do Launcher (Opcional)

Para alterar o ícone do app que aparece na tela inicial do telefone:

### 6.1 - Instalar flutter_launcher_icons

No terminal:

```powershell
flutter pub add --dev flutter_launcher_icons
```

### 6.2 - Configurar no pubspec.yaml

Adicione no final do `pubspec.yaml`:

```yaml
flutter_launcher_icons:
    android: true
    ios: true
    image_path: "assets/images/logo.png"
    adaptive_icon_background: "#6366F1" # Cor primária do app
    adaptive_icon_foreground: "assets/images/logo.png"
```

### 6.3 - Gerar Ícones

Execute:

```powershell
flutter pub get
flutter pub run flutter_launcher_icons
```

---

## Passo 7: Testar

Após todas as mudanças:

```powershell
# 1. Hot reload (se app estiver rodando)
r

# 2. Ou restart completo
R

# 3. Ou rebuild
flutter run -d emulator-5554
```

---

## 📝 Checklist

- [ ] Criar pasta `assets/images/`
- [ ] Copiar `logo.png` para `assets/images/`
- [ ] Adicionar `assets:` no `pubspec.yaml`
- [ ] Atualizar `CustomAppBar` (opcional)
- [ ] Atualizar `AppDrawer` (opcional)
- [ ] Atualizar `SplashScreen` (opcional)
- [ ] Instalar `flutter_launcher_icons` (opcional)
- [ ] Gerar ícones do launcher (opcional)
- [ ] Testar no emulador

---

## 🎯 Onde seu logo vai aparecer?

✅ **AppBar** - Topo de todas as telas\
✅ **Drawer** - Menu lateral (header)\
✅ **Splash Screen** - Tela inicial de carregamento\
✅ **Launcher Icon** - Ícone do app na tela do telefone (após gerar)

---

## ⚠️ Troubleshooting

**Erro: "Unable to load asset"**

- Execute: `flutter clean && flutter pub get`
- Verifique o caminho no `pubspec.yaml` (sem espaços extras)

**Imagem não aparece**

- Confirme que o arquivo está em `assets/images/logo.png`
- Verifique se o `pubspec.yaml` tem indentação correta (2 espaços)

**Ícone do launcher não muda**

- Execute: `flutter clean`
- Desinstale o app do emulador
- Reinstale: `flutter run -d emulator-5554`
