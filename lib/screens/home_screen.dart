import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Produtividade"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bem-vindo ao App Produtividade!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Exemplo: navegar para tela Eisenhower
                Navigator.pushNamed(context, '/eisenhower');
              },
              child: const Text("Matriz de Eisenhower"),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Exemplo: navegar para tela Pareto
                Navigator.pushNamed(context, '/pareto');
              },
              child: const Text("Análise de Pareto"),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Exemplo: navegar para tela GUT
                Navigator.pushNamed(context, '/gut');
              },
              child: const Text("Matriz GUT"),
            ),
          ],
        ),
      ),
    );
  }
}
