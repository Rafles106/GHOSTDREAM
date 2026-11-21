import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import 'login_screen.dart';

class ProfilScreen extends StatefulWidget {
  final UserModel? user;
  final VoidCallback? onLogout;
  final Function(UserModel updatedUser)? onUserUpdated;

  const ProfilScreen({
    super.key,
    this.user,
    this.onLogout,
    this.onUserUpdated,
  });

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool _autoPickupEnabled = true;
  String _preferredPayment = 'Tunai (Bayar Langsung ke Driver)';

  // Profil state variables yang bisa diedit
  late String _userName;
  late String _userNim;
  late String _userAngkatan;
  late String _userEmail;
  late String _userPhone;
  late String _userMajor;
  late int _userPoints;
  late String _userTier;
  int _selectedAvatarIndex = 0;
  String? _profileImagePath;

  // Pilihan tema avatar
  final List<List<Color>> _avatarGradients = [
    [const Color(0xFF38BDF8), const Color(0xFF0284C7)], // Biru Poliride
    [const Color(0xFF34D399), const Color(0xFF059669)], // Hijau Emerald
    [const Color(0xFFA78BFA), const Color(0xFF7C3AED)], // Ungu Modern
    [const Color(0xFFFBBF24), const Color(0xFFD97706)], // Oranye Amber
  ];

  @override
  void initState() {
    super.initState();
    final u = widget.user;
    _userName = u?.name ?? '';
    _userNim = u?.npm ?? '';
    _userAngkatan = (u?.angkatan.isNotEmpty == true) ? u!.angkatan : '';
    _userEmail = u?.email ?? '';
    _userPhone = (u?.phone.isNotEmpty == true) ? u!.phone : '';
    _userMajor = u?.major ?? '';
    _userPoints = u?.points ?? 0;
    _userTier = u?.tier ?? '';
    _profileImagePath = (u?.profilePicture.isNotEmpty == true) ? u!.profilePicture : null;
  }

  @override
  void didUpdateWidget(ProfilScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.user != oldWidget.user && widget.user != null) {
      final u = widget.user!;
      setState(() {
        _userName = u.name;
        _userNim = u.npm;
        _userAngkatan = u.angkatan.isNotEmpty ? u.angkatan : _userAngkatan;
        _userEmail = u.email;
        _userPhone = u.phone.isNotEmpty ? u.phone : _userPhone;
        _userMajor = u.major;
        _userPoints = u.points;
        _userTier = u.tier;
        if (u.profilePicture.isNotEmpty) {
          _profileImagePath = u.profilePicture;
        }
      });
    }
  }

  void _showEditProfileModal(BuildContext context) {
    final nameController = TextEditingController(text: _userName);
    final nimController = TextEditingController(text: _userNim);
    final angkatanController = TextEditingController(text: _userAngkatan);
    final majorController = TextEditingController(text: _userMajor);
    final emailController = TextEditingController(text: _userEmail);
    final phoneController = TextEditingController(text: _userPhone);
    int tempAvatarIndex = _selectedAvatarIndex;
    String? tempImagePath = _profileImagePath;

    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Header Edit
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.edit_note_rounded, color: Color(0xFF0284C7), size: 26),
                            SizedBox(width: 8),
                            Text(
                              'Edit Data Akun & Profil',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Form Fields
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          // Preview Avatar & Tombol Buka Galeri HP
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: _avatarGradients[tempAvatarIndex],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        border: Border.all(color: const Color(0xFFBAE6FD), width: 3),
                                      ),
                                      child: ClipOval(
                                        child: (tempImagePath != null && tempImagePath!.isNotEmpty)
                                            ? Image.file(
                                                File(tempImagePath!),
                                                width: 90,
                                                height: 90,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => const Center(
                                                  child: Icon(Icons.person, color: Colors.white, size: 44),
                                                ),
                                              )
                                            : const Center(
                                                child: Icon(Icons.person, color: Colors.white, size: 44),
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () async {
                                          final ImagePicker picker = ImagePicker();
                                          final XFile? image = await picker.pickImage(
                                            source: ImageSource.gallery,
                                            imageQuality: 85,
                                          );
                                          if (image != null) {
                                            setModalState(() {
                                              tempImagePath = image.path;
                                            });
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0284C7),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2),
                                          ),
                                          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Tombol Buka Galeri HP
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF0284C7)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  ),
                                  icon: const Icon(Icons.photo_library_rounded, size: 16, color: Color(0xFF0284C7)),
                                  label: const Text(
                                    'Buka Galeri Foto HP',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                                  ),
                                  onPressed: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 85,
                                    );
                                    if (image != null) {
                                      setModalState(() {
                                        tempImagePath = image.path;
                                      });
                                    }
                                  },
                                ),
                                if (tempImagePath != null && tempImagePath!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  TextButton(
                                    onPressed: () {
                                      setModalState(() {
                                        tempImagePath = null;
                                      });
                                    },
                                    child: const Text('Hapus Foto Kustom', style: TextStyle(color: Color(0xFFEF4444), fontSize: 11)),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Pilih Avatar Style
                          const Text(
                            'Pilih Warna Tema Avatar',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_avatarGradients.length, (idx) {
                              final isSelected = tempAvatarIndex == idx;
                              return GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    tempAvatarIndex = idx;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: _avatarGradients[idx],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF0F172A) : Colors.transparent,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _avatarGradients[idx][1].withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: isSelected
                                      ? const Center(child: Icon(Icons.check, color: Colors.white, size: 20))
                                      : null,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 20),

                          // Field Nama Lengkap
                          _buildEditField(
                            controller: nameController,
                            label: 'Nama Lengkap Mahasiswa',
                            icon: Icons.person_outline_rounded,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),

                          // Field NIM & Angkatan (Row)
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: _buildEditField(
                                  controller: nimController,
                                  label: 'NIM / NPM Mahasiswa',
                                  icon: Icons.badge_outlined,
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return 'NIM wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: _buildEditField(
                                  controller: angkatanController,
                                  label: 'Angkatan',
                                  icon: Icons.calendar_today_outlined,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Field Fakultas / Jurusan
                          _buildEditField(
                            controller: majorController,
                            label: 'Jurusan / Program Studi',
                            icon: Icons.school_outlined,
                          ),
                          const SizedBox(height: 14),

                          // Field Email Kampus
                          _buildEditField(
                            controller: emailController,
                            label: 'Email Resmi Kampus',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 14),

                          // Field No. WhatsApp
                          _buildEditField(
                            controller: phoneController,
                            label: 'Nomor WhatsApp / HP Aktif',
                            icon: Icons.phone_android_rounded,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 24),

                          // Tombol Simpan & Batal
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0284C7),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    elevation: 2,
                                  ),
                                  icon: const Icon(Icons.save_rounded, size: 18),
                                  label: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  onPressed: () {
                                    if (formKey.currentState?.validate() ?? false) {
                                      final newName = nameController.text.trim();
                                      final newNim = nimController.text.trim();
                                      final newAngkatan = angkatanController.text.trim();
                                      final newMajor = majorController.text.trim();
                                      final newEmail = emailController.text.trim();
                                      final newPhone = phoneController.text.trim();

                                      setState(() {
                                        _userName = newName;
                                        _userNim = newNim;
                                        _userAngkatan = newAngkatan;
                                        _userMajor = newMajor;
                                        _userEmail = newEmail;
                                        _userPhone = newPhone;
                                        _selectedAvatarIndex = tempAvatarIndex;
                                        _profileImagePath = tempImagePath;
                                      });

                                      // Callback to parent DashboardScreen
                                      final updatedUser = (widget.user ??
                                              UserModel(
                                                id: 'USR-2024-001',
                                                npm: newNim,
                                                name: newName,
                                                email: newEmail,
                                                major: newMajor,
                                              ))
                                          .copyWith(
                                        name: newName,
                                        npm: newNim,
                                        angkatan: newAngkatan,
                                        major: newMajor,
                                        email: newEmail,
                                        phone: newPhone,
                                        profilePicture: tempImagePath ?? '',
                                      );

                                      if (widget.onUserUpdated != null) {
                                        widget.onUserUpdated!(updatedUser);
                                      }

                                      Navigator.pop(ctx);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                                              SizedBox(width: 8),
                                              Text('Profil mahasiswa berhasil diperbarui! 🎉'),
                                            ],
                                          ),
                                          backgroundColor: Color(0xFF16A34A),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF0284C7), size: 20),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Color(0xFFDC2626)),
            SizedBox(width: 8),
            Text('Konfirmasi Keluar'),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun mahasiswa POLIRIDE?',
          style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              if (widget.onLogout != null) {
                widget.onLogout!();
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('SOS Darurat & Satpam'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Menghubungi Posko Keamanan & Satpam Kampus (24 Jam).',
              style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
            ),
            SizedBox(height: 10),
            Text('Lokasi Anda saat ini akan dibagikan ke petugas piket satpam.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Panggilan darurat terhubung ke Posko Satpam Kampus.'),
                  backgroundColor: Color(0xFFDC2626),
                ),
              );
            },
            child: const Text('Panggil Satpam'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Metode Pembayaran Utama',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            ListTile(
              leading: const Icon(Icons.money, color: Color(0xFF16A34A)),
              title: const Text('Tunai (Bayar Langsung ke Driver)'),
              subtitle: const Text('Sesuai tarif flat kampus tanpa perlu saldo'),
              trailing: _preferredPayment.startsWith('Tunai') ? const Icon(Icons.check_circle, color: Color(0xFF0284C7)) : null,
              onTap: () {
                setState(() => _preferredPayment = 'Tunai (Bayar Langsung ke Driver)');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_2, color: Color(0xFF0284C7)),
              title: const Text('QRIS Statis Driver'),
              subtitle: const Text('Scan langsung ke barcode driver saat tiba'),
              trailing: _preferredPayment.startsWith('QRIS') ? const Icon(Icons.check_circle, color: Color(0xFF0284C7)) : null,
              onTap: () {
                setState(() => _preferredPayment = 'QRIS Statis Driver');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profil Header Card matching Column 8 in Figma
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Avatar, Name, NIM, Edit Button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: _avatarGradients[_selectedAvatarIndex],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: const Color(0xFFBAE6FD), width: 3),
                          ),
                          child: ClipOval(
                            child: (_profileImagePath != null && _profileImagePath!.isNotEmpty)
                                ? Image.file(
                                    File(_profileImagePath!),
                                    width: 62,
                                    height: 62,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Center(
                                      child: Icon(Icons.person, color: Colors.white, size: 36),
                                    ),
                                  )
                                : const Center(
                                    child: Icon(Icons.person, color: Colors.white, size: 36),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.school, size: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'NIM: $_userNim • Angkatan $_userAngkatan',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _userMajor,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF0284C7)),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF0284C7)),
                        backgroundColor: const Color(0xFFF0F9FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      onPressed: () => _showEditProfileModal(context),
                      icon: const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF0284C7)),
                      label: const Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Stats Box (Perjalanan, Poin, Tier) - NO SALDO!
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('48', 'Perjalanan', Icons.route_rounded, const Color(0xFF0284C7)),
                      Container(height: 32, width: 1, color: const Color(0xFFCBD5E1)),
                      _buildStatColumn('${_userPoints.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}', 'Poin', Icons.stars_rounded, const Color(0xFFEAB308)),
                      Container(height: 32, width: 1, color: const Color(0xFFCBD5E1)),
                      _buildStatColumn(_userTier, 'Tier Member', Icons.military_tech_rounded, const Color(0xFFF59E0B)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // SEKSI 1: IDENTITAS AKADEMIK
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Identitas Akademik',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              InkWell(
                onTap: () => _showEditProfileModal(context),
                child: const Text(
                  'Ubah Data ✎',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildProfileItem(
                  icon: Icons.school_outlined,
                  iconColor: const Color(0xFF0284C7),
                  iconBg: const Color(0xFFE0F2FE),
                  title: 'Fakultas & Jurusan',
                  subtitle: _userMajor,
                  onTap: () => _showEditProfileModal(context),
                ),
                const Divider(height: 1, indent: 56),
                _buildProfileItem(
                  icon: Icons.email_outlined,
                  iconColor: const Color(0xFF0284C7),
                  iconBg: const Color(0xFFE0F2FE),
                  title: 'Email Kampus',
                  subtitle: _userEmail,
                  trailingBadge: 'Terverifikasi',
                  badgeColor: const Color(0xFF16A34A),
                  badgeBg: const Color(0xFFDCFCE7),
                  onTap: () => _showEditProfileModal(context),
                ),
                const Divider(height: 1, indent: 56),
                _buildProfileItem(
                  icon: Icons.phone_android_rounded,
                  iconColor: const Color(0xFF0284C7),
                  iconBg: const Color(0xFFE0F2FE),
                  title: 'No. WhatsApp',
                  subtitle: _userPhone,
                  trailingBadge: 'Aktif',
                  badgeColor: const Color(0xFF16A34A),
                  badgeBg: const Color(0xFFDCFCE7),
                  onTap: () => _showEditProfileModal(context),
                ),
                const Divider(height: 1, indent: 56),
                _buildProfileItem(
                  icon: Icons.badge_outlined,
                  iconColor: const Color(0xFF0284C7),
                  iconBg: const Color(0xFFE0F2FE),
                  title: 'KTM Digital',
                  subtitle: 'Terverifikasi Mahasiswa Aktif',
                  trailing: const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18),
                  onTap: () => _showEditProfileModal(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // SEKSI 2: PREFERENSI & KENYAMANAN
          const Text(
            'Preferensi & Kenyamanan',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.location_on_outlined, color: Color(0xFF0284C7), size: 20),
                  ),
                  title: const Text('Titik Jemput Otomatis', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Gedung SFS (Depan)', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  trailing: Switch(
                    value: _autoPickupEnabled,
                    activeColor: const Color(0xFF0284C7),
                    onChanged: (val) {
                      setState(() {
                        _autoPickupEnabled = val;
                      });
                    },
                  ),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.payments_outlined, color: Color(0xFF0284C7), size: 20),
                  ),
                  title: const Text('Metode Bayar Utama', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: Text(_preferredPayment, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                  onTap: _showPaymentMethodSheet,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // SEKSI 3: KEAMANAN & LAYANAN
          const Text(
            'Keamanan & Layanan',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                // SOS Darurat Satpam Kampus (Baris Merah matching Figma)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shield_rounded, color: Color(0xFFDC2626), size: 20),
                  ),
                  title: const Text('SOS Darurat & Satpam', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
                  subtitle: const Text('Posko Satpam Kampus 24 Jam', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    ),
                    onPressed: _showEmergencyDialog,
                    child: const Text('Panggil', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.map_outlined, color: Color(0xFF0284C7), size: 20),
                  ),
                  title: const Text('Panduan Aman Rute Gedung Polinema', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Panduan rute aman kampus POLIRIDE')),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.headset_mic_outlined, color: Color(0xFF0284C7), size: 20),
                  ),
                  title: const Text('Hubungi Admin PoliRIDE', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Chat CS Admin PoliRIDE terbuka')),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.description_outlined, color: Color(0xFF0284C7), size: 20),
                  ),
                  title: const Text('Syarat & Tata Tertib Pengguna', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Syarat & Ketentuan Pengguna')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tombol Keluar Akun Mahasiswa
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFDC2626)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              icon: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 18),
              label: const Text(
                'Keluar Akun Mahasiswa',
                style: TextStyle(
                  color: Color(0xFFDC2626),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _handleLogout,
            ),
          ),
          const SizedBox(height: 16),

          // Footer Versi Aplikasi matching Figma
          const Center(
            child: Column(
              children: [
                Text(
                  'POLIRIDE Mahasiswa v1.2.0 • Build 2024.11',
                  style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 2),
                Text(
                  'Politeknik Negeri Malang Smart Campus Transit',
                  style: TextStyle(fontSize: 10, color: Color(0xFFCBD5E1)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    String? trailingBadge,
    Color? badgeColor,
    Color? badgeBg,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      trailing: trailingBadge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: badgeBg ?? const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                trailingBadge,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: badgeColor ?? const Color(0xFF15803D),
                ),
              ),
            )
          : (trailing ?? const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF94A3B8))),
    );
  }
}
