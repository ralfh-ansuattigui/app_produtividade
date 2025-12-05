import 'package:bcrypt/bcrypt.dart';

class AuthService {
  /// Gera um hash bcrypt para a senha
  String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  /// Verifica se a senha corresponde ao hash
  bool verifyPassword(String password, String hash) {
    try {
      return BCrypt.checkpw(password, hash);
    } catch (e) {
      return false;
    }
  }

  /// Valida se a senha atende aos requisitos de segurança
  Map<String, bool> validatePassword(String password) {
    return {
      'has_min_length': password.length >= 6,
      'has_uppercase': password.contains(RegExp(r'[A-Z]')),
      'has_lowercase': password.contains(RegExp(r'[a-z]')),
      'has_number': password.contains(RegExp(r'[0-9]')),
      'has_special': password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    };
  }

  /// Valida se o email é válido
  bool validateEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Valida se o username é válido
  bool validateUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]{3,20}$');
    return usernameRegex.hasMatch(username);
  }
}
