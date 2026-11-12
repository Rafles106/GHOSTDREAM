import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/poliride_brand.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _npmController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _authService = AuthService();
  bool _isLoading = false;
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  String _selectedGender = 'Laki-laki';
  bool _agreeTerms = true;

  @override
  void dispose() {
    _nameController.dispose();
    _npmController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui Syarat & Ketentuan'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = await _authService.register(
        name: _nameController.text,
        npm: _npmController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        gender: _selectedGender,
        major: 'Teknologi Informasi / TRPL',
        password: _passwordController.text,
      );

      if (!mounted) return;
      Navigator.pop(context, user.npm);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          tooltip: 'Kembali',
        ),
        centerTitle: true,
        title: const PolirideBrand(fontSize: 18),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Badge Pendaftaran Akun Baru
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Pendaftaran Akun Baru',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Title
                const Text(
                  'Daftar Akun Mahasiswa',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Bergabung bersama ribuan mahasiswa lainnya di kampus.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 20),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Field 1: Nama Lengkap
                      _buildField(
                        controller: _nameController,
                        label: 'Nama Lengkap*',
                        hint: 'cth: Garbon Pratama',
                        icon: Icons.person_outline_rounded,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Nama lengkap wajib diisi'
                            : null,
                        capitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 14),

                      // Field 2: NIM Mahasiswa
                      _buildField(
                        controller: _npmController,
                        label: 'NIM Mahasiswa*',
                        hint: 'cth: 22753012',
                        icon: Icons.badge_outlined,
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'NIM wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      // Field 3: Email Kampus
                      _buildField(
                        controller: _emailController,
                        label: 'Email Kampus*',
                        hint: 'cth: garbon@student.ac.id',
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val == null || !val.contains('@')
                            ? 'Masukkan email kampus yang valid'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      // Field 4: No. WhatsApp / HP Aktif
                      _buildField(
                        controller: _phoneController,
                        label: 'No. WhatsApp / HP Aktif*',
                        hint: 'cth: 081234567890',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Nomor WhatsApp wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      // Field 5: Jenis Kelamin
                      const Text(
                        'Jenis Kelamin*',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGenderChoice(
                              title: 'Laki-laki',
                              icon: Icons.male_rounded,
                              isSelected: _selectedGender == 'Laki-laki',
                              onTap: () => setState(() => _selectedGender = 'Laki-laki'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildGenderChoice(
                              title: 'Perempuan',
                              icon: Icons.female_rounded,
                              isSelected: _selectedGender == 'Perempuan',
                              onTap: () => setState(() => _selectedGender = 'Perempuan'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Field 6: Kata Sandi
                      _buildField(
                        controller: _passwordController,
                        label: 'Kata Sandi*',
                        hint: 'Minimal 6 karakter',
                        icon: Icons.lock_outline_rounded,
                        obscureText: _isPasswordObscured,
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                          icon: Icon(
                            _isPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            size: 20,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        validator: (val) => val == null || val.length < 4
                            ? 'Kata sandi minimal 4 karakter'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      // Field 7: Ulangi Kata Sandi
                      _buildField(
                        controller: _confirmPasswordController,
                        label: 'Ulangi Kata Sandi*',
                        hint: 'Ketik ulang kata sandi',
                        icon: Icons.lock_outline_rounded,
                        obscureText: _isConfirmPasswordObscured,
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _isConfirmPasswordObscured = !_isConfirmPasswordObscured),
                          icon: Icon(
                            _isConfirmPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            size: 20,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        validator: (val) => val != _passwordController.text
                            ? 'Konfirmasi kata sandi belum sama'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      // Checkbox Terms
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreeTerms,
                              activeColor: const Color(0xFF0284C7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              onChanged: (val) => setState(() => _agreeTerms = val ?? true),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Saya menyetujui ',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                children: const [
                                  TextSpan(
                                    text: 'Syarat & Ketentuan',
                                    style: TextStyle(
                                      color: Color(0xFF0284C7),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: ' serta '),
                                  TextSpan(
                                    text: 'Kebijakan Privasi',
                                    style: TextStyle(
                                      color: Color(0xFF0284C7),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: ' PoliRIDE'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Button Daftar
                      CustomButton(
                        text: 'Daftar',
                        isLoading: _isLoading,
                        backgroundColor: const Color(0xFF0284C7),
                        onPressed: _handleRegister,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Sudah punya akun? Masuk
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun?',
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          color: Color(0xFF0284C7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Hak Cipta Layanan Ojek Kampus PoliRIDE 2024',
                    style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderChoice({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0F2FE) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF0284C7) : const Color(0xFFCBD5E1),
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization capitalization = TextCapitalization.none,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return CustomTextField(
      controller: controller,
      label: label,
      hintText: hint,
      prefixIcon: icon,
      suffixIcon: suffixIcon,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: capitalization,
      validator: validator,
    );
  }
}
