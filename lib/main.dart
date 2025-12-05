import 'package:app_produtividade/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'screens/splash.dart'; // sua tela de splash
//import 'screens/home.dart'; // se quiser separar MyHomePage em outro arquivo

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // 🚀 Inicializa com SplashScreen
      home: const SplashScreen(),
      routes: {'/home': (context) => const HomeScreen()},
    );
  }
}
