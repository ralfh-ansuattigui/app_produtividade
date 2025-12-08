import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header com gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Logo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'App Produtividade',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Versão 1.2.0-dev',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Conteúdo principal
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Seção Desenvolvedor
                  _buildSection(
                    title: '👨‍💻 Desenvolvedor',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Nome', 'Ansuattigui Rocha'),
                        _buildInfoRow('GitHub', '@ralfh-ansuattigui'),
                        _buildInfoRow('Email', 'ralfh@example.com'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Seção Sobre
                  _buildSection(
                    title: '📋 Sobre',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Um aplicativo multiplataforma de gerenciamento de tarefas implementando a Matriz de Eisenhower para produtividade pessoal.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.6,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildPlatformBadge('Android'),
                            _buildPlatformBadge('iOS'),
                            _buildPlatformBadge('Web'),
                            _buildPlatformBadge('Windows'),
                            _buildPlatformBadge('macOS'),
                            _buildPlatformBadge('Linux'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Seção Stack Técnico
                  _buildSection(
                    title: '⚙️ Stack Técnico',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTechItem('Flutter 3.10.3+'),
                        _buildTechItem('Dart 3.0+'),
                        _buildTechItem('Provider 6.0.0'),
                        _buildTechItem('SQLite + Drift'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Seção Roadmap
                  _buildSection(
                    title: '🗺️ Próximos Passos (v1.2.0)',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRoadmapItem(
                          'Aba de Estatísticas',
                          'Métricas dinâmicas por quadrante',
                        ),
                        _buildRoadmapItem(
                          'Análise de Pareto',
                          'Visualização 80/20 das tarefas',
                        ),
                        _buildRoadmapItem(
                          'Matriz GUT',
                          'Gravidade, Urgência, Tendência',
                        ),
                        _buildRoadmapItem(
                          'Calendário',
                          'Visualização de prazos',
                        ),
                        _buildRoadmapItem(
                          'Sincronização na Nuvem',
                          'Backup automático e multi-dispositivo',
                        ),
                        _buildRoadmapItem(
                          'Notificações',
                          'Alertas de tarefas vencidas',
                        ),
                        _buildRoadmapItem(
                          'Modo Escuro',
                          'Tema completo dark mode',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Seção Licença
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📄 Licença',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Este projeto está sob a licença MIT.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Footer com botão
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fechar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformBadge(String platform) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        platform,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTechItem(String tech) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(tech, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildRoadmapItem(String feature, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 8, top: 1),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
