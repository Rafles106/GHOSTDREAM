import '../models/user_model.dart';

class AuthService {
  static final Map<String, UserModel> _registeredUsers = {};
  static final Map<String, String> _registeredPasswords = {};

  // Static dummy active user matching Figma design (Garbon)
  static final UserModel dummyUser = UserModel(
    id: 'USR-2024-001',
    npm: '22753012',
    name: 'Garbon',
    email: 'garbon@student.polinela.ac.id',
    major: 'Teknologi Informasi / Teknologi Rekayasa Perangkat Lunak',
    phone: '+62 858-3920-1844',
    gender: 'Laki-laki',
    angkatan: '2024',
    semester: 'Semester 5',
    status: 'Mahasiswa Aktif',
    balance: 25750.0,
    points: 1250,
    tier: 'Gold',
    rating: 5.0,
  );

  /// Simulasi fungsi Login dengan NPM/Email/No. WhatsApp dan Password
  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    // Simulasi delay request jaringan
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

    // Mengembalikan data user Garbon dengan identitas yang dimasukkan
    return dummyUser.copyWith(
      npm: identifier.contains('@') ? '22753012' : identifier,
      email: identifier.contains('@')
          ? identifier
          : (identifier == '22753012' ? 'garbon@student.polinela.ac.id' : '$identifier@student.polinela.ac.id'),
    );
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
      phone: phone.isNotEmpty ? phone : '+62 812-3456-7890',
      gender: gender,
      major: major.isNotEmpty ? major : 'Teknologi Informasi / TRPL',
      balance: 25750.0,
      points: 100,
      tier: 'Bronze',
    );
    _registeredUsers[normalizedNpm] = user;
    _registeredUsers[normalizedEmail] = user;
    _registeredPasswords[user.id] = password;
    return user;
  }

  /// Simulasi Logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
