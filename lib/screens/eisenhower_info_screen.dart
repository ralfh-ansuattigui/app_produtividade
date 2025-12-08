import 'package:flutter/material.dart';

class EisenhowerInfoScreen extends StatelessWidget {
  const EisenhowerInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sobre a Matriz de Eisenhower'),
          centerTitle: false,
          elevation: 2,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.bolt), text: 'Orientação Rápida'),
              Tab(icon: Icon(Icons.info), text: 'Sobre'),
            ],
          ),
        ),
        body: const TabBarView(children: [_QuickOrientationTab(), _AboutTab()]),
      ),
    );
  }
}

class _QuickOrientationTab extends StatelessWidget {
  const _QuickOrientationTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'A Matriz de Eisenhower ajuda a priorizar tarefas baseado em:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          _buildQuadrantInfo(
            color: Colors.red,
            quadrant: 'Quadrante 1',
            status: 'Urgente e Importante',
            advice: 'Crises e emergências. Faça imediatamente!',
            examples: [
              'Prazos críticos vencendo hoje',
              'Problemas urgentes que requerem ação imediata',
              'Situações de crise',
            ],
          ),
          const SizedBox(height: 16),
          _buildQuadrantInfo(
            color: Colors.green,
            quadrant: 'Quadrante 2',
            status: 'Não Urgente e Importante',
            advice: 'Planejamento e desenvolvimento. Agende!',
            examples: [
              'Desenvolvimento profissional',
              'Planos estratégicos',
              'Relacionamentos importantes',
              'Saúde e bem-estar',
            ],
          ),
          const SizedBox(height: 16),
          _buildQuadrantInfo(
            color: Colors.orange,
            quadrant: 'Quadrante 3',
            status: 'Urgente e Não Importante',
            advice: 'Interrupções e distrações. Delegue!',
            examples: [
              'Chamadas e reuniões de outros',
              'Emails urgentes mas sem relevância estratégica',
              'Atividades que parecem urgentes, mas não são importantes',
            ],
          ),
          const SizedBox(height: 16),
          _buildQuadrantInfo(
            color: Colors.blue,
            quadrant: 'Quadrante 4',
            status: 'Não Urgente e Não Importante',
            advice: 'Atividades triviais. Elimine!',
            examples: [
              'Redes sociais desnecessárias',
              'Entretenimento sem valor',
              'Atividades que apenas consomem tempo',
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 Dica: Invista Tempo no Quadrante 2',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  'O segredo da produtividade está em dedicar tempo às atividades importantes que não são urgentes. Isso previne crises e promove crescimento a longo prazo.',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuadrantInfo({
    required Color color,
    required String quadrant,
    required String status,
    required String advice,
    required List<String> examples,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quadrant,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      status,
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              advice,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Exemplos:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          ...examples
              .map(
                (example) => Padding(
                  padding: const EdgeInsets.only(top: 4, left: 8),
                  child: Text(
                    '• $example',
                    style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  const _AboutTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'A Matriz de Eisenhower',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          const Text(
            'A Matriz de Eisenhower é um método de gerenciamento de tempo desenvolvido pelo 34º Presidente dos Estados Unidos, Dwight D. Eisenhower. Também conhecida como "Matriz de Importância-Urgência" ou "Box Method", essa ferramenta revolucionou a forma como as pessoas priorizam suas atividades.',
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Origem e História',
            content:
                'Durante sua presidência, Eisenhower enfrentava constantemente decisões críticas entre tarefas urgentes e importantes. Ele desenvolveu essa matriz como uma estratégia pessoal de gestão de tempo. A metodologia ganhou reconhecimento global através do livro "The 7 Habits of Highly Effective People" de Stephen Covey, publicado em 1989.',
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Princípios Fundamentais',
            content:
                'A matriz divide as tarefas em dois eixos:\n\n• URGÊNCIA: O quão rapidamente a tarefa precisa ser feita\n• IMPORTÂNCIA: O quanto a tarefa contribui para seus objetivos de longo prazo\n\nEsta divisão cria 4 quadrantes que ajudam a identificar onde gastar seu tempo e energia.',
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Por Que Usar?',
            content:
                '✅ Clareza na priorização\n✅ Reduz o estresse causado por tarefas urgentes\n✅ Estimula o planejamento estratégico\n✅ Melhora a produtividade geral\n✅ Facilita a delegação de responsabilidades\n✅ Previne o desperdício de tempo',
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Estratégia Recomendada',
            content:
                'Dedique a maior parte do seu tempo ao Quadrante 2 (Não Urgente e Importante). Este é o quadrante do crescimento, onde você investe em:\n\n• Desenvolvimento profissional\n• Relacionamentos de qualidade\n• Planejamento e estratégia\n• Saúde e bem-estar\n• Inovação\n\nReduzindo o tempo no Quadrante 1 (crises) e eliminando os Quadrantes 3 e 4, você cria um ciclo de vida mais produtivo e satisfatório.',
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Usando este Aplicativo',
            content:
                'Este aplicativo implementa a Matriz de Eisenhower de forma visual e intuitiva. Você pode:\n\n• Criar tarefas e atribuí-las aos quadrantes apropriados\n• Reordenar tarefas dentro de cada quadrante\n• Mover tarefas entre quadrantes quando prioridades mudam\n• Visualizar todas as tarefas de um quadrante ampliado\n• Acompanhar estatísticas e progresso\n\nUse este aplicativo como uma ferramenta diária para manter o foco no que realmente importa!',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📚 Referências',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '• "The 7 Habits of Highly Effective People" - Stephen Covey\n• Dwight D. Eisenhower - Official Speeches\n• Time Management Theory and Practice',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 13, height: 1.6)),
      ],
    );
  }
}
