import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/poliride_brand.dart';
import 'dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _npmController = TextEditingController();
  final _majorController = TextEditingController(text: 'Teknologi Informasi');
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isPasswordObscured = true;
  bool _agreeToTerms = true;

  final List<String> _majors = [
    'Teknologi Informasi',
    'Budidaya Tanaman Perkebunan',
    'Teknologi Pertanian',
    'Peternakan',
    'Perikanan & Kelautan',
    'Ekonomi & Bisnis',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _npmController.dispose();
    _majorController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui ketentuan layanan PoliRide'),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.register(
        name: _nameController.text.trim(),
        npm: _npmController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        major: _majorController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi Berhasil! Selamat datang di PoliRide 🎉'),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const PolirideBrand(fontSize: 18),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Daftar Akun Baru',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Lengkapi data mahasiswa Politeknik Negeri Lampung untuk kemudahan transportasi kampus.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                CustomTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap Mahasiswa *',
                  hintText: 'Contoh: Fajar Pratama',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _npmController,
                  label: 'NPM (Nomor Pokok Mahasiswa) *',
                  hintText: 'Contoh: 22753045',
                  prefixIcon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'NPM wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                // Jurusan Dropdown
                const Text(
                  'Jurusan di Polinela *',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _majors.contains(_majorController.text) ? _majorController.text : _majors.first,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    prefixIcon: const Icon(Icons.school_outlined, size: 20, color: Color(0xFF64748B)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  items: _majors.map((m) => DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 14)))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _majorController.text = val);
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _emailController,
                  label: 'Email Kampus / Mahasiswa *',
                  hintText: 'npm@polinela.ac.id atau email aktif',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                    if (!v.contains('@')) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _phoneController,
                  label: 'Nomor WhatsApp Aktif *',
                  hintText: 'Contoh: 081234567890',
                  prefixIcon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Nomor WhatsApp wajib diisi' : null,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _passwordController,
                  label: 'Kata Sandi *',
                  hintText: 'Minimal 6 karakter',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: _isPasswordObscured,
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                    onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? 'Sandi minimal 6 karakter' : null,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Konfirmasi Kata Sandi *',
                  hintText: 'Ketik ulang sandi Anda',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: _isPasswordObscured,
                  validator: (v) {
                    if (v != _passwordController.text) return 'Konfirmasi sandi tidak sesuai';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreeToTerms,
                        activeColor: const Color(0xFF0284C7),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (v) => setState(() => _agreeToTerms = v ?? false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Saya menyetujui Ketentuan Layanan dan Kebijakan Privasi PoliRide untuk mahasiswa Polinela.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                CustomButton(
                  text: 'Daftar Sekarang',
                  isLoading: _isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
