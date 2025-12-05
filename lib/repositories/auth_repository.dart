import '../database/database_factory.dart' as db;
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final db.DatabaseFactory _databaseFactory = db.DatabaseFactory();
  final AuthService _authService = AuthService();

  /// Registra um novo usuário
  Future<User> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final database = await _databaseFactory.database;

      // Valida entrada
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception('Username, email e password são obrigatórios');
      }

      if (password.length < 6) {
        throw Exception('Senha deve ter no mínimo 6 caracteres');
      }

      // Verifica se usuário/email já existe
      final existingUser = await database.query(
        'users',
        where: 'username = ? OR email = ?',
        whereArgs: [username, email],
      );

      if (existingUser.isNotEmpty) {
        throw Exception('Username ou email já está cadastrado');
      }

      // Cria hash da senha
      final passwordHash = _authService.hashPassword(password);
      final now = DateTime.now();

      // Insere novo usuário
      final id = await database.insert('users', {
        'username': username,
        'email': email,
        'password_hash': passwordHash,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      });

      return User(
        id: id,
        username: username,
        email: email,
        passwordHash: passwordHash,
        createdAt: now,
        updatedAt: now,
      );
    } catch (e) {
      throw Exception('Erro ao registrar usuário: ${e.toString()}');
    }
  }

  /// Autentica um usuário (login)
  Future<User> login({
    required String username,
    required String password,
  }) async {
    try {
      final database = await _databaseFactory.database;

      // Busca o usuário
      final result = await database.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      if (result.isEmpty) {
        throw Exception('Usuário ou senha inválidos');
      }

      final user = User.fromMap(result.first);

      // Verifica a senha
      final isPasswordValid = _authService.verifyPassword(
        password,
        user.passwordHash,
      );

      if (!isPasswordValid) {
        throw Exception('Usuário ou senha inválidos');
      }

      return user;
    } catch (e) {
      throw Exception('Erro ao fazer login: ${e.toString()}');
    }
  }

  /// Obtém um usuário por ID
  Future<User?> getUserById(int id) async {
    final db = await _databaseFactory.database;

    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (result.isEmpty) {
      return null;
    }

    return User.fromMap(result.first);
  }

  /// Obtém um usuário por username
  Future<User?> getUserByUsername(String username) async {
    final db = await _databaseFactory.database;

    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isEmpty) {
      return null;
    }

    return User.fromMap(result.first);
  }

  /// Atualiza um usuário
  Future<void> updateUser(User user) async {
    final db = await _databaseFactory.database;

    final updatedUser = user.copyWith(updatedAt: DateTime.now());

    await db.update(
      'users',
      updatedUser.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  /// Deleta um usuário
  Future<void> deleteUser(int id) async {
    final db = await _databaseFactory.database;

    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
