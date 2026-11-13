import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'login_screen.dart';

class ProfilScreen extends StatefulWidget {
  final UserModel? user;
  final VoidCallback? onLogout;

  const ProfilScreen({
    super.key,
    this.user,
    this.onLogout,
  });

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool _autoPickupEnabled = true;
  String _preferredPayment = 'Tunai (Bayar Langsung ke Driver)';

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
    final user = widget.user;
    final userName = user?.name ?? 'Gorbon';
    final userNim = user?.npm ?? '2341720001';
    final userEmail = user?.email ?? 'gorbon@polinema.ac.id';
    final userMajor = user?.major ?? 'Teknologi Informasi / D-IV TI';
    final userPoints = user?.points ?? 1250;
    final userTier = user?.tier ?? 'Gold';

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
                            gradient: const LinearGradient(
                              colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: const Color(0xFFBAE6FD), width: 3),
                          ),
                          child: const Center(
                            child: Icon(Icons.person, color: Colors.white, size: 36),
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
                            userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'NIM: $userNim • Angkatan 2023',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userMajor,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF0284C7)),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Form edit profil terbuka.')),
                        );
                      },
                      icon: const Icon(Icons.edit_outlined, size: 13, color: Color(0xFF475569)),
                      label: const Text('Edit', style: TextStyle(fontSize: 11, color: Color(0xFF475569))),
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
                      _buildStatColumn('${userPoints.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}', 'Poin', Icons.stars_rounded, const Color(0xFFEAB308)),
                      Container(height: 32, width: 1, color: const Color(0xFFCBD5E1)),
                      _buildStatColumn(userTier, 'Tier Member', Icons.military_tech_rounded, const Color(0xFFF59E0B)),
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
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sinkronisasi data SSO Polinema aktif.')),
                  );
                },
                child: const Text(
                  'Lihat Detail',
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
                  subtitle: 'Teknologi Informasi / D-IV TI',
                ),
                const Divider(height: 1, indent: 56),
                _buildProfileItem(
                  icon: Icons.email_outlined,
                  iconColor: const Color(0xFF0284C7),
                  iconBg: const Color(0xFFE0F2FE),
                  title: 'Email Kampus',
                  subtitle: userEmail,
                  trailingBadge: 'Terverifikasi',
                  badgeColor: const Color(0xFF16A34A),
                  badgeBg: const Color(0xFFDCFCE7),
                ),
                const Divider(height: 1, indent: 56),
                _buildProfileItem(
                  icon: Icons.phone_android_rounded,
                  iconColor: const Color(0xFF0284C7),
                  iconBg: const Color(0xFFE0F2FE),
                  title: 'No. WhatsApp',
                  subtitle: '+62 812-3456-7890',
                  trailingBadge: 'Aktif',
                  badgeColor: const Color(0xFF16A34A),
                  badgeBg: const Color(0xFFDCFCE7),
                ),
                const Divider(height: 1, indent: 56),
                _buildProfileItem(
                  icon: Icons.badge_outlined,
                  iconColor: const Color(0xFF0284C7),
                  iconBg: const Color(0xFFE0F2FE),
                  title: 'KTM Digital',
                  subtitle: 'Terverifikasi Mahasiswa Aktif',
                  trailing: const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18),
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
  }) {
    return ListTile(
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
          : trailing,
    );
  }
}
