import 'package:flutter/material.dart';
import '../screens/about_app_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      child: Column(
        children: [
          // Cabeçalho do Drawer com Logo
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Grande
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Nome do App
                const Text(
                  'App Produtividade',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Tagline
                Text(
                  'Organize suas tarefas',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Itens do Menu
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home,
                  title: 'Início',
                  route: '/home',
                  isSelected: currentRoute == '/home',
                ),
                const Divider(height: 1),
                _buildDrawerItem(
                  context,
                  icon: Icons.grid_4x4,
                  title: 'Matriz de Eisenhower',
                  route: '/eisenhower',
                  isSelected: currentRoute == '/eisenhower',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.pie_chart,
                  title: 'Análise de Pareto',
                  route: '/pareto',
                  isSelected: currentRoute == '/pareto',
                  enabled: false,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.assessment,
                  title: 'Matriz GUT',
                  route: '/gut',
                  isSelected: currentRoute == '/gut',
                  enabled: false,
                ),
                const Divider(height: 1, thickness: 2),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Configurações',
                  route: '/settings',
                  isSelected: currentRoute == '/settings',
                  enabled: false,
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Sobre o App'),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => const AboutAppScreen(),
                    );
                  },
                ),
              ],
            ),
          ),

          // Rodapé
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Versão 1.2.0-dev',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    bool isSelected = false,
    bool enabled = true,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: enabled
            ? (isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[700])
            : Colors.grey[400],
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: enabled ? Colors.black87 : Colors.grey[400],
        ),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      enabled: enabled,
      onTap: enabled
          ? () {
              Navigator.pop(context); // Fecha o drawer
              if (!isSelected) {
                Navigator.pushReplacementNamed(context, route);
              }
            }
          : null,
      trailing: !enabled
          ? Chip(
              label: const Text('Em breve', style: TextStyle(fontSize: 10)),
              backgroundColor: Colors.grey[300],
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.symmetric(horizontal: 6),
            )
          : null,
    );
  }
}
