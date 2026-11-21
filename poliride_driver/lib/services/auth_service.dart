import '../models/user_model.dart';

class AuthService {
  static final Map<String, UserModel> _registeredUsers = {};
  static final Map<String, String> _registeredPasswords = {};

  /// Login - akan dihubungkan ke database nyata
  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    // TODO: Hubungkan ke database / API backend
    await Future.delayed(const Duration(milliseconds: 500));

    if (identifier.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('NPM/No. HP/Email dan Password wajib diisi');
    }

    if (password.length < 4) {
      throw Exception('Password minimal 4 karakter');
    }

    final normalizedIdentifier = identifier.trim().toLowerCase();
    final registeredUser = _registeredUsers[normalizedIdentifier];
    if (registeredUser != null) {
      if (_registeredPasswords[registeredUser.id] != password) {
        throw Exception('Kata sandi yang Anda masukkan salah');
      }
      return registeredUser;
    }

    throw Exception('Akun tidak ditemukan. Silakan daftar terlebih dahulu.');
  }

  Future<UserModel> register({
    required String name,
    required String npm,
    required String email,
    required String phone,
    required String gender,
    required String major,
    required String password,
  }) async {
    // TODO: Hubungkan ke database / API backend
    await Future.delayed(const Duration(milliseconds: 500));

    if (name.trim().isEmpty ||
        npm.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty) {
      throw Exception('Semua data berbintang (*) wajib diisi');
    }

    if (!email.contains('@')) {
      throw Exception('Format email kampus tidak valid');
    }

    if (password.length < 4) {
      throw Exception('Kata sandi minimal 4 karakter');
    }

    final normalizedNpm = npm.trim().toLowerCase();
    final normalizedEmail = email.trim().toLowerCase();
    if (_registeredUsers.containsKey(normalizedNpm) ||
        _registeredUsers.containsKey(normalizedEmail)) {
      throw Exception('NPM atau email sudah terdaftar');
    }

    final user = UserModel(
      id: 'USR-${npm.trim()}',
      npm: npm.trim(),
      name: name.trim(),
      email: email.trim(),
      phone: phone.isNotEmpty ? phone : '',
      gender: gender,
      major: major.isNotEmpty ? major : '',
      balance: 0.0,
      points: 0,
      tier: 'Bronze',
    );
    _registeredUsers[normalizedNpm] = user;
    _registeredUsers[normalizedEmail] = user;
    _registeredPasswords[user.id] = password;
    return user;
  }

  /// Logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
