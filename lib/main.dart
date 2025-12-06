import 'package:app_produtividade/screens/home_screen.dart';
import 'package:app_produtividade/screens/eisenhower_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash.dart';
import 'screens/auth_screen.dart';
import 'database/database_initializer.dart';
import 'providers/tasks_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o banco de dados
  await DatabaseInitializer.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TasksNotifier())],
      child: MaterialApp(
        title: 'App Produtividade',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        // 🚀 Inicializa com SplashScreen
        home: const SplashScreen(),
        routes: {
          '/auth': (context) => const AuthScreen(),
          '/home': (context) => const HomeScreen(),
          '/eisenhower': (context) => const EisenhowerScreen(),
        },
      ),
    );
  }
}
