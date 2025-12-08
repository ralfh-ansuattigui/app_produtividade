# Changelog - App Produtividade

## [1.1.0] - 2025-12-07

### ✨ Destaques

**Matriz de Eisenhower**

- Reordenação de tarefas dentro do quadrante (ReorderableListView)
- Drag & drop entre quadrantes com detecção consistente de toque
- Botão de lupa em cada quadrante para abrir visão ampliada (modal) com
  descrição e prazo
- Inclusão rápida por duplo clique mesmo com tarefas já existentes

**Interface e Informações**

- Novo splash/home com logo atualizado
- Abas de informação sobre a Matriz (Orientação Rápida e Sobre)
- Popup "Sobre o App" com desenvolvedor, versão e roadmap
- Numeração de tarefas e fontes maiores para melhor leitura

**Estrutura**

- Introdução de `EisenhowerInfoScreen` e `AboutAppScreen`
- Ajustes no `AppDrawer` e `CustomAppBar` para integração dos novos fluxos

---

## [1.0.0] - 2024-12-07

### 🎉 Release Inicial

#### ✨ Funcionalidades Implementadas

**Matriz de Eisenhower**

- Grid 2x2 com 4 quadrantes de priorização
- Labels nas bordas (horizontal: IMPORTANTE/NÃO IMPORTANTE, vertical:
  URGENTE/NÃO URGENTE)
- Sistema drag-and-drop para mover tarefas entre quadrantes
- Duplo clique em áreas vazias para adicionar tarefas rapidamente
- Indicadores visuais de cores por quadrante:
  - Q1 (Urgente e Importante): Vermelho
  - Q2 (Não Urgente e Importante): Verde
  - Q3 (Urgente e Não Importante): Laranja
  - Q4 (Não Urgente e Não Importante): Azul

**Gerenciamento de Tarefas**

- Criar tarefas com título e descrição opcional
- Seleção de urgência e importância via SegmentedButton
- Definir prazos opcionais
- Indicadores de prazo com alertas visuais:
  - ⚠ VENCIDA (vermelho)
  - ⏰ HOJE (laranja escuro)
  - 📅 1 dia (laranja claro)
  - 📅 2 dias (amarelo)
- Visualização detalhada de tarefas
- Marcar tarefas como completas
- Excluir tarefas

**Interface do Usuário**

- CustomAppBar com logo gradiente e título
- AppDrawer com navegação e badges "Em breve"
- Tema Material 3 com cores consistentes:
  - Primary: Indigo (#6366F1)
  - Secondary: Purple (#8B5CF6)
  - Accent: Green (#10B981)
- HomeScreen com:
  - Banner de boas-vindas com gradiente
  - Grid 2x2 de ferramentas de produtividade
  - Card de resumo de tarefas (preparado para dados futuros)
- Splash Screen com logo e carregamento
- Tela de autenticação (placeholder)

**Otimizações**

- Labels reduzidos ao mínimo (50x28px, fontes 10-11px)
- Remoção de botões redundantes
- Simplificação de código:
  - Removido parâmetro `isCompact` não utilizado
  - Criado `QuadrantHelper` para evitar duplicação
  - Eliminado método wrapper `_moveTask`
- Tamanhos de fonte fixos (sem condicionais desnecessários)

#### 🗄️ Tecnologia

- Flutter 3.10.3+
- Material Design 3
- Provider para gerenciamento de estado
- SQLite para persistência de dados
- Suporte a Android (testado em Android 16)

#### 📋 Funcionalidades Futuras (Preparadas)

- Análise de Pareto (80/20)
- Matriz GUT (Gravidade, Urgência, Tendência)
- Calendário com visualização de prazos
- Configurações do app

---

### 🎯 Próximas Versões Planejadas

**v1.2.0** (Próximo)

- Implementação da Análise de Pareto
- Implementação da Matriz GUT
- Calendário com visualização de tarefas
- **Aba de Estatísticas no Eisenhower**:
  - Mover widget de estatísticas da HomeScreen para EisenhowerScreen
  - Implementar TabBar com 2 abas (Matriz | Estatísticas)
  - Estatísticas dinâmicas com Consumer<TasksNotifier>:
    - Total de tarefas por quadrante
    - Tarefas concluídas vs pendentes
    - Tarefas com prazo vencido/hoje/próximos dias
    - Gráficos de distribuição por quadrante
  - Otimização de espaço na tela principal

**v1.3.0**

- Sistema de notificações para prazos
- Backup e restauração de dados
- Temas claro/escuro
- Relatórios de produtividade exportáveis

**v2.0.0**

- Sincronização em nuvem
- Compartilhamento de tarefas
- Suporte a projetos/categorias
- Widget para tela inicial do Android
