import 'package:app_produtividade/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'screens/splash.dart';
import 'screens/auth_screen.dart';
import 'database/database_initializer.dart';

void main() async {
  // Garante que o Flutter binding está inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o banco de dados
  final dbInitialized = await DatabaseInitializer.initialize();
  if (!dbInitialized) {
    debugPrint(
      '⚠️ Aviso: Banco de dados pode não estar funcionando corretamente',
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Produtividade',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // 🚀 Inicializa com SplashScreen
      home: const SplashScreen(),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
