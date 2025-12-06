import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseFactory {
  static final DatabaseFactory _instance = DatabaseFactory._internal();
  static sqflite.Database? _database;
  static const String _dbName = 'app_produtividade.db';
  static const int _dbVersion = 3;
  static bool _ffiInitialized = false;

  factory DatabaseFactory() {
    return _instance;
  }

  DatabaseFactory._internal();

  /// Obtém a instância do banco de dados
  Future<sqflite.Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  /// Inicializa o banco de dados
  Future<sqflite.Database> _initDatabase() async {
    // Em desktop é obrigatório inicializar o factory FFI antes de usar sqflite
    if (!_ffiInitialized &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      sqflite.databaseFactory = databaseFactoryFfi;
      _ffiInitialized = true;
    }

    // Sqflite não funciona no Web
    if (Platform.isWindows ||
        Platform.isLinux ||
        Platform.isMacOS ||
        Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isFuchsia) {
      // ok
    } else {
      throw UnsupportedError('Plataforma não suportada pelo sqflite');
    }

    final dbPath = await sqflite.getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await sqflite.openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Cria as tabelas do banco
  Future<void> _onCreate(sqflite.Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        is_completed INTEGER DEFAULT 0,
        priority INTEGER DEFAULT 1,
        quadrant INTEGER DEFAULT 1,
        due_date TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_tasks_user_id ON tasks(user_id)
    ''');
  }

  /// Atualiza o schema do banco (usado em migrations)
  Future<void> _onUpgrade(
    sqflite.Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      // Adiciona coluna quadrant se não existir
      await db.execute(
        "ALTER TABLE tasks ADD COLUMN quadrant INTEGER DEFAULT 1",
      );
    }
    if (oldVersion < 3) {
      // Adiciona coluna due_date se não existir
      await db.execute(
        "ALTER TABLE tasks ADD COLUMN due_date TEXT",
      );
    }
  }

  /// Fecha a conexão com o banco
  Future<void> closeDatabase() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
  }

  /// Limpa o banco (útil para testes)
  Future<void> deleteDatabase() async {
    final dbPath = await sqflite.getDatabasesPath();
    final path = join(dbPath, _dbName);
    await sqflite.deleteDatabase(path);
  }
}
