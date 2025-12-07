import 'package:flutter/material.dart';

class QuadrantHelper {
  static String getName(int quadrant) {
    switch (quadrant) {
      case 1:
        return 'Urgente e Importante';
      case 2:
        return 'Não Urgente e Importante';
      case 3:
        return 'Urgente e Não Importante';
      case 4:
        return 'Não Urgente e Não Importante';
      default:
        return 'Desconhecido';
    }
  }

  static Color getColor(int quadrant) {
    switch (quadrant) {
      case 1:
        return Colors.red[700]!;
      case 2:
        return Colors.green[700]!;
      case 3:
        return Colors.orange[700]!;
      case 4:
        return Colors.blue[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  static IconData getIcon(int quadrant) {
    switch (quadrant) {
      case 1:
        return Icons.crisis_alert;
      case 2:
        return Icons.calendar_today;
      case 3:
        return Icons.people_alt;
      case 4:
        return Icons.delete_outline;
      default:
        return Icons.help_outline;
    }
  }

  static String getAction(int quadrant) {
    switch (quadrant) {
      case 1:
        return '🔥 Faça imediatamente!';
      case 2:
        return '📅 Agende e planeje';
      case 3:
        return '👥 Delegue se possível';
      case 4:
        return '🗑️ Considere eliminar';
      default:
        return '';
    }
  }
}
