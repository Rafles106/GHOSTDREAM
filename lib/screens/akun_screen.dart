import 'package:flutter/material.dart';
import '../models/driver_model.dart';
import 'login_screen.dart';

class AkunScreen extends StatefulWidget {
  final DriverModel driver;
  final ValueChanged<DriverModel>? onDriverUpdated;
  final VoidCallback? onLogout;

  const AkunScreen({
    super.key,
    required this.driver,
    this.onDriverUpdated,
    this.onLogout,
  });

  @override
  State<AkunScreen> createState() => _AkunScreenState();
}

class _AkunScreenState extends State<AkunScreen> {
  late DriverModel _driver;

  @override
  void initState() {
    super.initState();
    _driver = widget.driver;
  }

  @override
  void didUpdateWidget(AkunScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.driver != oldWidget.driver) {
      setState(() {
        _driver = widget.driver;
      });
    }
  }

  void _showEditProfileModal() {
    final nameController = TextEditingController(text: _driver.name);
    final phoneController = TextEditingController(text: _driver.phone);
    final emailController = TextEditingController(text: _driver.email);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 14,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ubah Data Profil Mitra',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const Divider(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildEditField(controller: nameController, label: 'Nama Lengkap Mitra', icon: Icons.person_outline),
                  const SizedBox(height: 14),
                  _buildEditField(controller: phoneController, label: 'Nomor WhatsApp / HP', icon: Icons.phone_android),
                  const SizedBox(height: 14),
                  _buildEditField(controller: emailController, label: 'Email Terdaftar', icon: Icons.email_outlined),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      final updated = _driver.copyWith(
                        name: nameController.text.trim(),
                        phone: phoneController.text.trim(),
                        email: emailController.text.trim(),
                      );
                      setState(() => _driver = updated);
                      if (widget.onDriverUpdated != null) {
                        widget.onDriverUpdated!(updated);
                      }
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profil mitra berhasil diperbarui!')),
                      );
                    },
                    child: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditVehicleModal() {
    final vehicleController = TextEditingController(text: _driver.vehicleModel);
    final plateController = TextEditingController(text: _driver.vehiclePlate);
    final taxController = TextEditingController(text: _driver.vehicleTaxDate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 14,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ubah Data Kendaraan Operasional',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const Divider(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildEditField(controller: vehicleController, label: 'Merk & Tipe Motor', icon: Icons.two_wheeler),
                  const SizedBox(height: 14),
                  _buildEditField(controller: plateController, label: 'Nomor Plat Polisi (Nopol)', icon: Icons.confirmation_number_outlined),
                  const SizedBox(height: 14),
                  _buildEditField(controller: taxController, label: 'Masa Pajak Kendaraan', icon: Icons.event_available_outlined),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      final updated = _driver.copyWith(
                        vehicleModel: vehicleController.text.trim(),
                        vehiclePlate: plateController.text.trim(),
                        vehicleTaxDate: taxController.text.trim(),
                      );
                      setState(() => _driver = updated);
                      if (widget.onDriverUpdated != null) {
                        widget.onDriverUpdated!(updated);
                      }
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data kendaraan operasional diperbarui!')),
                      );
                    },
                    child: const Text('Simpan Data Kendaraan', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField({required TextEditingController controller, required String label, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF0284C7), size: 20),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ),
      ],
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.shield_rounded, color: Color(0xFFDC2626)),
            SizedBox(width: 8),
            Text('SOS Pos Satpam Kampus'),
          ],
        ),
        content: const Text(
          'Menghubungi Posko Keamanan Satpam Polinela (24 Jam). Lokasi koordinat Anda akan dibagikan ke tim satpam.',
          style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
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

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Istirahat / Keluar'),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun driver PoliRIDE atau istirahat panjang?',
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card Profil Driver matching Column 7 in Figma
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
                Row(
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
                            child: Icon(Icons.two_wheeler_rounded, color: Colors.white, size: 34),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Color(0xFF16A34A),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, size: 10, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _driver.name,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'MITRA RESMI',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ID Mitra: ${_driver.mitraId} • Bergabung ${_driver.joinedYear}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF0284C7)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      onPressed: _showEditProfileModal,
                      child: const Text('Edit', style: TextStyle(fontSize: 12, color: Color(0xFF0284C7), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Stats Driver (Rating, Total Trip, Penerimaan) matching Column 7
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
                      _buildDriverStat(
                        icon: Icons.star_rounded,
                        iconColor: const Color(0xFFEAB308),
                        value: '${_driver.rating}',
                        label: 'Rating Driver',
                      ),
                      Container(height: 32, width: 1, color: const Color(0xFFCBD5E1)),
                      _buildDriverStat(
                        icon: Icons.receipt_long_rounded,
                        iconColor: const Color(0xFF0284C7),
                        value: '${_driver.totalTrips}',
                        label: 'Total Trip',
                      ),
                      Container(height: 32, width: 1, color: const Color(0xFFCBD5E1)),
                      _buildDriverStat(
                        icon: Icons.percent_rounded,
                        iconColor: const Color(0xFF16A34A),
                        value: '${_driver.acceptanceRate}%',
                        label: 'Penerimaan',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // SEKSI 1: KENDARAAN TERDAFTAR matching Column 7
          const Text(
            'Kendaraan Terdaftar',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0F2FE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.two_wheeler_rounded, color: Color(0xFF0284C7), size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _driver.vehicleModel,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: const Color(0xFFCBD5E1)),
                                ),
                                child: Text(
                                  _driver.vehiclePlate,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF334155)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _driver.vehicleTaxDate,
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF16A34A), fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF0284C7)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 15, color: Color(0xFF0284C7)),
                    label: const Text('Ubah Data Kendaraan', style: TextStyle(color: Color(0xFF0284C7), fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: _showEditVehicleModal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // SEKSI 2: LEGALITAS & DOKUMEN KAMPUS matching Column 7
          const Text(
            'Legalitas & Dokumen Kampus',
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
                _buildDocumentTile(
                  title: 'SIM C Kendaraan Roda 2',
                  status: 'Terverifikasi',
                  statusColor: const Color(0xFF16A34A),
                  statusBg: const Color(0xFFDCFCE7),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildDocumentTile(
                  title: 'Uji Operasional Kampus',
                  status: 'Lulus Uji Kelayakan',
                  statusColor: const Color(0xFF16A34A),
                  statusBg: const Color(0xFFDCFCE7),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildDocumentTile(
                  title: 'SKCK & Verifikasi Satpam',
                  status: 'Terverifikasi',
                  statusColor: const Color(0xFF16A34A),
                  statusBg: const Color(0xFFDCFCE7),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // SEKSI 3: PENGATURAN OPERASIONAL matching Column 7
          const Text(
            'Pengaturan Operasional',
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
                SwitchListTile(
                  title: const Text('Terima Order Otomatis', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Order terdekat langsung diterima tanpa konfirmasi', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  value: _driver.isAutoAccept,
                  activeColor: const Color(0xFF0284C7),
                  onChanged: (val) {
                    setState(() => _driver = _driver.copyWith(isAutoAccept: val));
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  title: const Text('Alarm Notifikasi Kencang', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Bunyikan suara keras saat ada pesanan baru masuk', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  value: _driver.isLoudAlert,
                  activeColor: const Color(0xFF0284C7),
                  onChanged: (val) {
                    setState(() => _driver = _driver.copyWith(isLoudAlert: val));
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: const Text('Navigasi Peta Default', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Google Maps', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                    ],
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigasi default diatur ke OpenStreetMap / Google Maps')),
                    );
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: const Text('Bahasa Aplikasi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Bahasa Indonesia', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                    ],
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // SEKSI 4: PUSAT BANTUAN & KEAMANAN matching Column 7
          const Text(
            'Pusat Bantuan & Keamanan',
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
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shield_rounded, color: Color(0xFFDC2626), size: 20),
                  ),
                  title: const Text('SOS Pos Satpam Polinela', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
                  subtitle: const Text('Posko Keamanan Satpam 24 Jam', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
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
                  leading: const Icon(Icons.description_outlined, color: Color(0xFF0284C7), size: 20),
                  title: const Text('Syarat & Ketentuan Kemitraan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.help_outline_rounded, color: Color(0xFF0284C7), size: 20),
                  title: const Text('FAQ Seputar Mitra Kampus', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tombol Keluar Akun / Istirahat Panjang
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
                'Keluar Akun / Istirahat Panjang',
                style: TextStyle(color: Color(0xFFDC2626), fontSize: 13, fontWeight: FontWeight.bold),
              ),
              onPressed: _handleLogout,
            ),
          ),
          const SizedBox(height: 16),

          // Footer Versi Aplikasi
          const Center(
            child: Column(
              children: [
                Text(
                  'POLIRIDE Driver v1.2.0 • Build 2024.11',
                  style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 2),
                Text(
                  'Politeknik Negeri Malang / Lampung Mitra Kampus',
                  style: TextStyle(fontSize: 10, color: Color(0xFFCBD5E1)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDriverStat({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildDocumentTile({
    required String title,
    required String status,
    required Color statusColor,
    required Color statusBg,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: statusBg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          status,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
        ),
      ),
    );
  }
}
