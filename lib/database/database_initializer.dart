import 'database_factory.dart' as dbfactory;

class DatabaseInitializer {
  /// Inicializa o banco de dados
  static Future<bool> initialize() async {
    try {
      final databaseFactory = dbfactory.DatabaseFactory();
      final db = await databaseFactory.database;

      // Verifica se as tabelas foram criadas
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'",
      );

      final tableNames = tables.map((t) => t['name'] as String).toList();

      if (!tableNames.contains('users')) {
        throw Exception('Tabela users não foi criada');
      }

      if (!tableNames.contains('tasks')) {
        throw Exception('Tabela tasks não foi criada');
      }

      return true;
    } catch (e) {
      print('❌ Erro ao inicializar banco: $e');
      return false;
    }
  }

  /// Obtém informações sobre o banco
  static Future<Map<String, dynamic>> getDatabaseInfo() async {
    try {
      final db = await dbfactory.DatabaseFactory().database;

      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'",
      );

      final tableNames = tables.map((t) => t['name'] as String).toList();

      return {
        'success': true,
        'tables': tableNames,
        'path': db.path,
        'isOpen': db.isOpen,
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
