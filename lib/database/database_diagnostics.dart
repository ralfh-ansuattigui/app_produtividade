import 'package:flutter/material.dart';
import 'database_factory.dart' as dbfactory;
import 'database_initializer.dart';

class DatabaseDiagnostics {
  /// Realiza diagnóstico completo do banco
  static Future<void> runDiagnostics() async {
    debugPrint('\n========== DATABASE DIAGNOSTICS ==========');

    try {
      // 1. Verificar inicialização
      debugPrint('\n1️⃣ Inicializando banco de dados...');
      final initialized = await DatabaseInitializer.initialize();
      debugPrint(
        initialized
            ? '✅ Banco inicializado com sucesso'
            : '❌ Falha na inicialização',
      );

      // 2. Obter info do banco
      debugPrint('\n2️⃣ Obtendo informações do banco...');
      final info = await DatabaseInitializer.getDatabaseInfo();
      if (info['success']) {
        debugPrint('✅ Banco está aberto');
        debugPrint('   Caminho: ${info['path']}');
        debugPrint('   Tabelas: ${(info['tables'] as List).join(', ')}');
      } else {
        debugPrint('❌ Erro: ${info['error']}');
      }

      // 3. Verificar tabelas
      debugPrint('\n3️⃣ Verificando estrutura das tabelas...');
      try {
        final db = await dbfactory.DatabaseFactory().database;

        // Check users table
        final usersInfo = await db.rawQuery("PRAGMA table_info(users)");
        if (usersInfo.isNotEmpty) {
          debugPrint('✅ Tabela users encontrada');
          debugPrint('   Colunas: ${usersInfo.length}');
          for (var col in usersInfo) {
            debugPrint('     - ${col['name']}: ${col['type']}');
          }
        }

        // Check tasks table
        final tasksInfo = await db.rawQuery("PRAGMA table_info(tasks)");
        if (tasksInfo.isNotEmpty) {
          debugPrint('✅ Tabela tasks encontrada');
          debugPrint('   Colunas: ${tasksInfo.length}');
        }
      } catch (e) {
        debugPrint('❌ Erro ao verificar tabelas: $e');
      }

      // 4. Testar inserção
      debugPrint('\n4️⃣ Testando inserção no banco...');
      try {
        final db = await dbfactory.DatabaseFactory().database;

        // Contar usuários existentes
        final count = await db.rawQuery('SELECT COUNT(*) as count FROM users');
        final userCount = (count[0]['count'] as int?) ?? 0;
        debugPrint('✅ Total de usuários: $userCount');
      } catch (e) {
        debugPrint('❌ Erro ao consultar usuários: $e');
      }
    } catch (e) {
      debugPrint('❌ Erro geral: $e');
    }

    debugPrint('\n=========================================\n');
  }

  /// Reseta o banco (deleta e recria)
  static Future<bool> resetDatabase() async {
    try {
      debugPrint('🔄 Resertando banco de dados...');

      // Fechar conexão
      await dbfactory.DatabaseFactory().closeDatabase();

      // Deletar arquivo
      await dbfactory.DatabaseFactory().deleteDatabase();

      // Reinicializar
      final initialized = await DatabaseInitializer.initialize();

      if (initialized) {
        debugPrint('✅ Banco resetado com sucesso');
        return true;
      } else {
        debugPrint('❌ Falha ao reinicializar banco');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Erro ao resetar banco: $e');
      return false;
    }
  }
}
