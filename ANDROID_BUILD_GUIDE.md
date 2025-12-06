# Guia de Build Android - App Produtividade

## Pré-requisitos

1. **Flutter SDK** instalado
   ```bash
   flutter --version
   ```

2. **Android SDK** (via Android Studio)
   - Mínimo: API 21 (Android 5.0)
   - Alvo: API 34+ (Android 14+)

3. **Java JDK 17** ou superior
   ```bash
   java -version
   ```

4. **Aceitar licenças Android**
   ```bash
   flutter doctor --android-licenses
   ```

## Configuração

### 1. Verificar Ambiente

```bash
flutter doctor
```

### 2. Obter Dependências

```bash
flutter pub get
```

## Build

### Debug Build (para testes)

```bash
flutter build apk --debug
```

Arquivo gerado: `build/app/outputs/flutter-apk/app-debug.apk`

### Release Build (para distribuição)

#### Opção 1: Com Gradle (recomendado para Play Store)

```bash
flutter build appbundle --release
```

Arquivo gerado: `build/app/outputs/bundle/release/app-release.aab`

#### Opção 2: APK Release

```bash
flutter build apk --release --split-per-abi
```

Gera 3 APKs otimizados:

- `app-armeabi-v7a-release.apk`
- `app-arm64-v8a-release.apk`
- `app-x86_64-release.apk`

## Execução em Dispositivo

### Listar Dispositivos Disponíveis

```bash
flutter devices
```

### Instalar e Executar (Debug)

```bash
flutter run
```

### Instalar APK Manualmente

```bash
adb install build/app/outputs/flutter-apk/app-debug.apk
```

## Assinatura de Release (Produção)

Para publicar na Google Play Store, você precisa:

1. **Criar Keystore**
   ```bash
   keytool -genkey -v -keystore ~/my-release-key.jks -keyalg RSA -keysize 2048 -validity 10950 -alias my-key-alias
   ```

2. **Configurar em android/key.properties**
   ```properties
   storePassword=YOUR_PASSWORD
   keyPassword=YOUR_KEY_PASSWORD
   keyAlias=my-key-alias
   storeFile=../my-release-key.jks
   ```

3. **Atualizar android/app/build.gradle.kts** para usar a keystore

4. **Build Release Assinado**
   ```bash
   flutter build appbundle --release
   ```

## Configurações Atuais

- **Application ID**: com.produtividade.app
- **Namespace**: com.produtividade.app
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: 34+ (Android 14+)
- **Version**: 1.0.0+1

### Permissões Configuradas

- `INTERNET` - Comunicação futura com servidor
- `READ_EXTERNAL_STORAGE` - Acesso ao banco de dados local
- `WRITE_EXTERNAL_STORAGE` - Acesso ao banco de dados local
- `VIBRATE` - Feedback de vibração
- `POST_NOTIFICATIONS` - Notificações push

## Troubleshooting

### Build Fails

1. Executar limpeza
   ```bash
   flutter clean
   flutter pub get
   ```

2. Verificar compatibilidade do JDK
   ```bash
   java -version
   ```

### Device Not Found

1. Ativar USB Debugging no dispositivo
2. Conectar via USB
3. Autorizar computador no dispositivo
4. Executar: `adb devices`

### Gradle Sync Fails

```bash
cd android
./gradlew clean
cd ..
flutter pub get
```

## Próximos Passos

- [ ] Gerar App Icon para Android (usando
      `flutter pub add flutter_launcher_icons`)
- [ ] Configurar Splash Screen
- [ ] Implementar notificações push
- [ ] Publicar na Google Play Store
- [ ] Configurar assinatura com chave privada (antes de produção)

## Referências

- [Flutter Android Build Documentation](https://flutter.dev/docs/deployment/android)
- [Google Play Console](https://play.google.com/console)
- [Android Developer Documentation](https://developer.android.com/)
