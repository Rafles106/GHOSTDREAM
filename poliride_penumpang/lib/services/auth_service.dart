import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    // Default logged in user for instant preview
    _currentUser = UserModel(
      id: 'USR-22753045',
      npm: '22753045',
      name: 'Fajar Pratama',
      email: 'fajar.pratama@polinela.ac.id',
      major: 'Teknologi Informasi (TRPL)',
      phone: '0812-7389-1122',
      gender: 'Laki-laki',
      angkatan: '2022',
      semester: 'Semester 5',
      status: 'Mahasiswa Aktif',
      balance: 25000.0,
      points: 120,
      tier: 'Silver Mahasiswa',
      rating: 4.9,
    );
  }

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  static final Map<String, UserModel> _registeredUsers = {
    '22753045': UserModel(
      id: 'USR-22753045',
      npm: '22753045',
      name: 'Fajar Pratama',
      email: 'fajar.pratama@polinela.ac.id',
      major: 'Teknologi Informasi (TRPL)',
      phone: '0812-7389-1122',
      balance: 25000.0,
      points: 120,
    ),
  };

  static final Map<String, String> _registeredPasswords = {
    'USR-22753045': '123456',
  };

  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (identifier.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('NPM / Email Mahasiswa dan Password wajib diisi');
    }

    final normalized = identifier.trim().toLowerCase();
    // Allow demo fast login
    if (normalized == 'demo' || normalized == '22753045' || normalized.contains('polinela')) {
      _currentUser = _registeredUsers['22753045']!;
      notifyListeners();
      return _currentUser!;
    }

    final user = _registeredUsers[normalized];
    if (user != null) {
      if (_registeredPasswords[user.id] != password && password != '123456') {
        throw Exception('Kata sandi salah. Silakan coba lagi.');
      }
      _currentUser = user;
      notifyListeners();
      return user;
    }

    // If not found in map, auto register for seamless test
    final newUser = UserModel(
      id: 'USR-${identifier.trim()}',
      npm: identifier.trim(),
      name: 'Mahasiswa Polinela',
      email: identifier.contains('@') ? identifier.trim() : '${identifier.trim()}@polinela.ac.id',
      major: 'Teknologi Informasi',
      phone: '0812-3456-7890',
      balance: 30000.0,
    );
    _currentUser = newUser;
    notifyListeners();
    return newUser;
  }

  Future<UserModel> register({
    required String name,
    required String npm,
    required String email,
    required String phone,
    required String password,
    String major = 'Teknologi Informasi',
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (name.trim().isEmpty || npm.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Semua data wajib diisi');
    }

    final user = UserModel(
      id: 'USR-${npm.trim()}',
      npm: npm.trim(),
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      major: major,
      balance: 20000.0,
      points: 50,
    );

    _registeredUsers[npm.trim().toLowerCase()] = user;
    _registeredUsers[email.trim().toLowerCase()] = user;
    _registeredPasswords[user.id] = password;
    _currentUser = user;
    notifyListeners();
    return user;
  }

  void topUpBalance(double amount) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        balance: _currentUser!.balance + amount,
        points: _currentUser!.points + (amount / 1000).round(),
      );
      notifyListeners();
    }
  }

  void deductBalance(double amount) {
    if (_currentUser != null && _currentUser!.balance >= amount) {
      _currentUser = _currentUser!.copyWith(
        balance: _currentUser!.balance - amount,
      );
      notifyListeners();
    }
  }

  void updateProfile({required String name, required String phone, required String major}) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        phone: phone,
        major: major,
      );
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
