# Simulador Android no VS Code

## 📱 Emulador Disponível

Você já possui um emulador configurado:

- **Nome**: Medium Phone API 36.1 (Android 15)
- **ID**: Medium_Phone_API_36.1
- **Fabricante**: Generic

## 🚀 Como Usar

### 1. Iniciar o Emulador

#### Opção A: Via Flutter (Recomendado)

```bash
flutter emulators --launch Medium_Phone_API_36.1
```

#### Opção B: Via Android Studio

- Abrir Android Studio
- Clicar em "Device Manager" ou "AVD Manager"
- Clicar no play button do emulador desejado

### 2. Executar App no Emulador

Após o emulador estar rodando, execute:

```bash
flutter run
```

Ou especificamente:

```bash
flutter run -d Medium_Phone_API_36.1
```

### 3. Build em Release

```bash
flutter run --release
```

## 🛠️ Gerenciar Emuladores

### Listar Emuladores

```bash
flutter emulators
```

### Criar Novo Emulador

```bash
flutter emulators --create --name "Pixel_7_Pro"
```

### Deletar Emulador

```bash
flutter emulators --delete <id>
```

### Listar Emuladores do Android (detalhado)

```bash
$ANDROID_HOME/tools/bin/avdmanager list avd
```

## 🖥️ Acessar Android Studio

Para gerenciar emuladores com interface gráfica:

1. Abrir Android Studio
2. Clicar em **Tools** → **Device Manager**
3. Gerenciar, editar ou deletar emuladores

## 💡 Dicas Úteis

### Acelerar o Emulador

- Verificar que você tem Hardware Acceleration habilitado
- Se lento, aumentar RAM e CPU no gerenciador de emuladores
- Usar emulador com API 21-30 (mais rápido que versões recentes)

### Instalar APK Diretamente

```bash
adb install build/app/outputs/flutter-apk/app-debug.apk
```

### Limpar Cache do Emulador

```bash
adb shell pm clear com.produtividade.app
```

### Ver Logs em Tempo Real

```bash
flutter logs
```

### Abrir ADB Shell (terminal do emulador)

```bash
adb shell
```

## 🔧 Troubleshooting

### Emulador não inicia

1. Verificar se o Android SDK está instalado corretamente
   ```bash
   flutter doctor -v
   ```
2. Tentar resetar o emulador
   ```bash
   flutter emulators --delete Medium_Phone_API_36.1
   flutter emulators --create --name "Medium_Phone_API_36.1"
   ```

### Conexão perdida com emulador durante build

```bash
adb kill-server
adb start-server
flutter run
```

### Emulador muito lento

- Usar API menor (21-30)
- Aumentar RAM disponível
- Usar SSD em vez de HDD
- Habilitar Hyper-V no Windows (se disponível)

## 📱 Opções de Tamanho de Tela

Ao criar emulador, escolher:

- **Small Phone**: 4.65" (ex: Pixel 3)
- **Medium Phone**: 6.1" (ex: Pixel 7) ← Você tem esse
- **Large Phone**: 6.7" (ex: Pixel 7 Pro)
- **Tablet**: 10.1" e acima

## 🎮 Simuladores iOS (se estiver em macOS)

No macOS, também pode simular iOS:

```bash
open -a Simulator  # Abre o iOS Simulator
flutter run -d iPhone
```

## Referências

- [Flutter Emulator Guide](https://flutter.dev/docs/development/tools/android-studio#running-apps-on-the-emulator)
- [Android Emulator Documentation](https://developer.android.com/studio/run/emulator)
- [ADB Command Reference](https://developer.android.com/studio/command-line/adb)
