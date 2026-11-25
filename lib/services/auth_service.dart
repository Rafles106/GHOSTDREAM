import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    _auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        _currentUser = null;
        notifyListeners();
      } else if (_currentUser == null || _currentUser!.id != firebaseUser.uid) {
        await ensureSessionLoaded();
      }
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _auth.currentUser != null || _currentUser != null;

  Future<UserModel?> ensureSessionLoaded() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      return null;
    }

    try {
      final uid = firebaseUser.uid;
      final doc = await _db.collection('passengers').doc(uid).get();
      final data = doc.data() ?? {};

      final user = UserModel.fromJson({
        ...data,
        'id': data['id'] ?? uid,
        'email': (data['email'] ?? firebaseUser.email ?? '').toString(),
      });

      _currentUser = user;
      notifyListeners();
      return user;
    } catch (_) {
      return null;
    }
  }

  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    final rawInput = identifier.trim();
    if (rawInput.isEmpty || password.trim().isEmpty) {
      throw Exception('NPM / Email Mahasiswa dan Kata Sandi wajib diisi');
    }

    if (password.length < 6) {
      throw Exception('Kata sandi minimal 6 karakter');
    }

    try {
      String emailToUse = rawInput;

      // Jika input bukan email (misalnya NPM), cari dokumen penumpang di Firestore
      if (!rawInput.contains('@')) {
        final snap = await _db
            .collection('passengers')
            .where('npm', isEqualTo: rawInput)
            .limit(1)
            .get();

        if (snap.docs.isEmpty) {
          throw Exception(
            'NPM tidak ditemukan. Silakan daftar dulu atau masuk pakai Email.',
          );
        }

        emailToUse = (snap.docs.first.data()['email'] ?? '').toString();
        if (emailToUse.isEmpty || !emailToUse.contains('@')) {
          throw Exception('Email untuk NPM tersebut belum terdaftar.');
        }
      }

      final credential = await _auth.signInWithEmailAndPassword(
        email: emailToUse.toLowerCase(),
        password: password,
      );

      final uid = credential.user!.uid;
      final doc = await _db.collection('passengers').doc(uid).get();
      final data = doc.data() ?? {};

      final user = UserModel.fromJson({
        ...data,
        'id': data['id'] ?? uid,
        'email': (data['email'] ?? credential.user?.email ?? '').toString(),
      });

      _currentUser = user;
      notifyListeners();
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e.code));
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<UserModel> register({
    required String name,
    required String npm,
    required String email,
    required String phone,
    required String password,
    String major = 'Teknologi Informasi',
  }) async {
    final cleanName = name.trim();
    final cleanNpm = npm.trim();
    final cleanEmail = email.trim().toLowerCase();
    final cleanPhone = phone.trim();
    final cleanMajor = major.trim();

    if (cleanName.isEmpty ||
        cleanNpm.isEmpty ||
        cleanEmail.isEmpty ||
        password.trim().isEmpty) {
      throw Exception('Semua data wajib diisi');
    }

    if (!cleanEmail.contains('@')) {
      throw Exception('Format email tidak valid');
    }

    if (password.length < 6) {
      throw Exception('Kata sandi minimal 6 karakter');
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final uid = credential.user!.uid;

      final user = UserModel(
        id: uid,
        npm: cleanNpm,
        name: cleanName,
        email: cleanEmail,
        major: cleanMajor,
        phone: cleanPhone,
        balance: 20000.0,
        points: 50,
      );

      await _db.collection('passengers').doc(uid).set({
        ...user.toJson(),
        'uid': uid,
        'role': 'passenger',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _currentUser = user;
      notifyListeners();
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapAuthError(e.code));
    } catch (e) {
      throw Exception('Gagal mendaftarkan akun penumpang: $e');
    }
  }

  Future<void> topUpBalance(double amount) async {
    if (_currentUser == null) return;
    final updatedBalance = _currentUser!.balance + amount;
    final updatedPoints = _currentUser!.points + (amount / 1000).round();

    _currentUser = _currentUser!.copyWith(
      balance: updatedBalance,
      points: updatedPoints,
    );
    notifyListeners();

    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _db.collection('passengers').doc(uid).update({
        'balance': updatedBalance,
        'points': updatedPoints,
      });
    }
  }

  Future<void> deductBalance(double amount) async {
    if (_currentUser == null || _currentUser!.balance < amount) return;
    final updatedBalance = _currentUser!.balance - amount;

    _currentUser = _currentUser!.copyWith(balance: updatedBalance);
    notifyListeners();

    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _db.collection('passengers').doc(uid).update({
        'balance': updatedBalance,
      });
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String major,
  }) async {
    if (_currentUser == null) return;
    final cleanName = name.trim();
    final cleanPhone = phone.trim();
    final cleanMajor = major.trim();

    _currentUser = _currentUser!.copyWith(
      name: cleanName,
      phone: cleanPhone,
      major: cleanMajor,
    );
    notifyListeners();

    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _db.collection('passengers').doc(uid).update({
        'name': cleanName,
        'phone': cleanPhone,
        'major': cleanMajor,
      });
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email ini sudah terdaftar.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password':
        return 'Kata sandi minimal 6 karakter.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau kata sandi salah.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah.';
      default:
        return 'Autentikasi gagal ($code).';
    }
  }
}