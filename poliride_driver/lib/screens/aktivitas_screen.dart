import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/ride_model.dart';
import '../models/user_model.dart';
import '../services/ride_service.dart';
import 'map_screen.dart';

class AktivitasScreen extends StatefulWidget {
  final UserModel? user;
  final Function(String pickup, String destination)? onReorder;
  final VoidCallback? onBackToHome;

  const AktivitasScreen({
    super.key,
    this.user,
    this.onReorder,
    this.onBackToHome,
  });

  @override
  State<AktivitasScreen> createState() => _AktivitasScreenState();
}

class _AktivitasScreenState extends State<AktivitasScreen> {
  int _selectedTabIndex = 0; // 0: Dalam Proses, 1: Riwayat, 2: Dibatalkan
  String _cancelledFilter = 'Semua';
  bool _hasActiveOrder = false;
  bool _showMiniMap = true;

  // Koordinat simulasi rute kampus Polinela / Polinema
  static const LatLng _pickupLocation = LatLng(-5.3585, 105.2320); // Gerbang Samping
  static const LatLng _driverLocation = LatLng(-5.3578, 105.2330); // Driver on way
  static const LatLng _destLocation = LatLng(-5.3565, 105.2345); // Gedung SFS

  void _showCancelOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Batalkan Pesanan?'),
        content: const Text(
          'Pembatalan sebelum driver tiba bebas penalti dan tidak dikenakan denda.',
          style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kembali', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _hasActiveOrder = false;
                _selectedTabIndex = 2; // Pindah ke tab Dibatalkan
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pesanan berhasil dibatalkan bebas denda.'),
                  backgroundColor: Color(0xFF64748B),
                ),
              );
            },
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  void _showChatBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFE0F2FE),
                    child: const Icon(Icons.two_wheeler, color: Color(0xFF0284C7)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Raden R. (Driver)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('Honda Vario 125 • N 4602 GA', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Hari ini 08:35 WIB', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(maxWidth: 260),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'Halo kak, saya menuju titik jemput Gerbang Samping ya.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(maxWidth: 260),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'Siap pak, saya pakai jaket abu-abu di dekat pos jaga.',
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(maxWidth: 260),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'Driver sudah siap di lokasi jemput depan gerbang!',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF166534)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Ketik pesan ke driver...',
                          hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF0284C7),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pesan terkirim ke driver.')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReceiptDialog(RideOrder order) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bukti Resi Perjalanan',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('LUNAS (TUNAI)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF166534))),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(order.id, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            const Divider(height: 24),
            _buildReceiptRow('Layanan', order.title),
            _buildReceiptRow('Tanggal & Waktu', order.dateTime),
            _buildReceiptRow('Driver', '${order.driverName} (${order.plateNumber ?? "-"})'),
            _buildReceiptRow('Titik Jemput', order.pickup),
            _buildReceiptRow('Tujuan Pengantaran', order.destination),
            _buildReceiptRow('Metode Pembayaran', 'Tunai ke Driver'),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Tarif', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(
                  'Rp ${order.fare.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Color(0xFF0284C7)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup Resi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSatpamContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.local_police_rounded, color: Color(0xFF0284C7)),
            SizedBox(width: 8),
            Text('Pos Satpam Kampus'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Layanan Posko Keamanan 24 Jam Politeknik:',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            SizedBox(height: 12),
            Text('• Hotline Satpam: (0721) 703995 / Ext 110', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            SizedBox(height: 4),
            Text('• Posko Gerbang Utama & Posko SFS', style: TextStyle(fontSize: 13)),
            SizedBox(height: 4),
            Text('• Melayani laporan barang tertinggal, tarif tidak sesuai, dan keamanan.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.phone, size: 16),
            label: const Text('Hubungi'),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menghubungi Pos Satpam Kampus...')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = widget.user?.name ?? 'Gorbon';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Aktivitas Pesanan matching screenshot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AKTIVITAS PESANAN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tag_rounded, size: 13, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      _hasActiveOrder ? '24708910' : 'RIWAYAT',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Tab Navigation matching Capsule Pill design in Figma
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildPillTab(
                    index: 0,
                    title: 'Dalam Proses',
                    count: _hasActiveOrder ? 1 : 0,
                  ),
                ),
                Expanded(
                  child: _buildPillTab(
                    index: 1,
                    title: 'Riwayat',
                    count: RideService.completedOrders.length,
                  ),
                ),
                Expanded(
                  child: _buildPillTab(
                    index: 2,
                    title: 'Dibatalkan',
                    count: RideService.cancelledOrders.length,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tab Content switcher
          if (_selectedTabIndex == 0) _buildActiveOrderView(),
          if (_selectedTabIndex == 1) _buildCompletedOrdersView(),
          if (_selectedTabIndex == 2) _buildCancelledOrdersView(),
        ],
      ),
    );
  }

  Widget _buildPillTab({required int index, required String title, required int count}) {
    final isSelected = _selectedTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedTabIndex = index),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0284C7) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 1: DALAM PROSES (Screen 5)
  Widget _buildActiveOrderView() {
    final active = RideService.activeOrder;
    if (!_hasActiveOrder || active == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.two_wheeler_outlined, size: 48, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tidak Ada Pesanan Aktif',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Yuk pesan PoliRide untuk antar-jemput di area kampus!',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() {
                    _hasActiveOrder = true;
                  });
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Buat Pesanan Baru'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Alert Strip
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF86EFAC)),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xFF15803D), size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'STATUS PESANAN AKTIF • ESTIMASI TIBA: 3 MENIT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF166534),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Ongoing Order Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Driver Info Row
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFBAE6FD), width: 2),
                        ),
                        child: const Center(
                          child: Icon(Icons.person, color: Colors.white, size: 28),
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
                          child: const Icon(Icons.two_wheeler, size: 10, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              active.driverName,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, size: 10, color: Color(0xFFD97706)),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${active.driverRating}',
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${active.vehicleInfo} • ${active.plateNumber}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  // Call button
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Menghubungi nomor telepon ${active.driverName}...')),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCFCE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.phone, size: 18, color: Color(0xFF15803D)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Chat button
                  InkWell(
                    onTap: _showChatBottomSheet,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0F2FE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chat_bubble_rounded, size: 18, color: Color(0xFF0284C7)),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Route Points matching design
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.radio_button_checked, color: Color(0xFF16A34A), size: 18),
                      Container(
                        width: 2,
                        height: 30,
                        color: const Color(0xFFCBD5E1),
                      ),
                      const Icon(Icons.location_on, color: Color(0xFFEF4444), size: 18),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'JEMPUT',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                        ),
                        Text(
                          active.pickup,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        Text(
                          active.pickupNote ?? 'Samping pos jaga satpam',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'TUJUAN PENGANTARAN',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
                        ),
                        Text(
                          active.destination,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        Text(
                          active.destinationNote ?? 'Lobby utama gedung',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Driver speech note bubble
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline_rounded, size: 15, color: Color(0xFF0284C7)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        active.driverNote ?? 'Driver siap di titik jemput!',
                        style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF475569)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Tarif & Action button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tarif PoliRide', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      Text(
                        'Rp ${active.fare.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    ),
                    icon: const Icon(Icons.map_rounded, size: 15),
                    label: const Text('Lihat Posisi Driver di Peta', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PolirideMapScreen()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Live Mini Map Widget (OpenStreetMap with Markers)
        if (_showMiniMap) ...[
          Container(
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: _driverLocation,
                      initialZoom: 16.2,
                      minZoom: 14.0,
                      maxZoom: 18.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.poliride.app',
                      ),
                      // Polyline menghubungkan jemput -> driver -> tujuan
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: const [
                              _pickupLocation,
                              _driverLocation,
                              _destLocation,
                            ],
                            strokeWidth: 4.0,
                            color: const Color(0xFF0284C7),
                          ),
                        ],
                      ),
                      // Marker Jemput, Driver, Tujuan
                      MarkerLayer(
                        markers: [
                          const Marker(
                            point: _pickupLocation,
                            width: 32,
                            height: 32,
                            child: Icon(Icons.location_on, color: Color(0xFF16A34A), size: 30),
                          ),
                          Marker(
                            point: _driverLocation,
                            width: 36,
                            height: 36,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF0284C7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.two_wheeler, color: Colors.white, size: 20),
                            ),
                          ),
                          const Marker(
                            point: _destLocation,
                            width: 32,
                            height: 32,
                            child: Icon(Icons.location_pin, color: Color(0xFFEF4444), size: 30),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.radar_rounded, size: 14, color: Color(0xFF0284C7)),
                          SizedBox(width: 4),
                          Text('Live Tracking Driver', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Tombol Bukti Chat & Batalkan Pesanan
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF0284C7)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                icon: const Icon(Icons.chat_outlined, size: 16, color: Color(0xFF0284C7)),
                label: const Text('Bukti Chat', style: TextStyle(color: Color(0xFF0284C7), fontSize: 13, fontWeight: FontWeight.bold)),
                onPressed: _showChatBottomSheet,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                icon: const Icon(Icons.cancel_outlined, size: 16, color: Color(0xFFEF4444)),
                label: const Text('Batalkan Pesanan', style: TextStyle(color: Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.bold)),
                onPressed: _showCancelOrderDialog,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Riwayat Perjalanan Kampus Header & Preview Card
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Riwayat Perjalanan Kampus',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            InkWell(
              onTap: () => setState(() => _selectedTabIndex = 1),
              child: const Text(
                'Lihat Semua →',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Satu card riwayat preview (jika ada)
        if (RideService.completedOrders.isNotEmpty) ...[
          _buildCompletedOrderCard(RideService.completedOrders.first),
          const SizedBox(height: 14),
        ],

        // Banner Barang Tertinggal di Kampus
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.backpack_outlined, color: Color(0xFFD97706), size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Barang tertinggal di Kampus?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    SizedBox(height: 2),
                    Text(
                      'Seluruh perjalanan tercatat dan terpantau tim keamanan Polinema.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF0284C7)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                ),
                onPressed: _showSatpamContactDialog,
                child: const Text('Bantuan', style: TextStyle(fontSize: 11, color: Color(0xFF0284C7))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // TAB 2: RIWAYAT / SELESAI (Screen 6)
  Widget _buildCompletedOrdersView() {
    final list = RideService.completedOrders;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sub-filter pill
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Selesai: ${list.length} Perjalanan',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Bulan Ini', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'Belum ada riwayat perjalanan selesai.',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
            ),
          )
        else
          ...list.map((order) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildCompletedOrderCard(order),
              )),

        const SizedBox(height: 8),

        // Kendala atau Barang Tertinggal Footer Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.shield_outlined, color: Color(0xFF0284C7), size: 20),
                  SizedBox(width: 8),
                  Text('Kendala atau Barang Tertinggal?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Tindak penipuan atau tarif tidak sesuai dapat dilaporkan ke Satpam Polinema.',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0284C7)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(Icons.phone, size: 16, color: Color(0xFF0284C7)),
                  label: const Text('Hubungi Pos Satpam Kampus (24 Jam)', style: TextStyle(color: Color(0xFF0284C7), fontSize: 12, fontWeight: FontWeight.bold)),
                  onPressed: _showSatpamContactDialog,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCompletedOrderCard(RideOrder order) {
    final isFood = order.type == RideType.poliFood;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card: Icon, Title, Price, Status chip
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isFood ? const Color(0xFFFFEDD5) : const Color(0xFFE0F2FE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFood ? Icons.lunch_dining : Icons.two_wheeler_rounded,
                  color: isFood ? const Color(0xFFEA580C) : const Color(0xFF0284C7),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      order.dateTime,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rp ${order.fare.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('Selesai', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 18),

          // Rute atau Food Items
          if (isFood) ...[
            Row(
              children: [
                const Icon(Icons.storefront_outlined, size: 16, color: Color(0xFFEA580C)),
                const SizedBox(width: 8),
                Text(order.pickup, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.fastfood_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 8),
                Expanded(child: Text(order.foodItems ?? 'Pesanan Makanan', style: const TextStyle(fontSize: 12, color: Color(0xFF475569)))),
              ],
            ),
          ] else ...[
            Row(
              children: [
                const Icon(Icons.radio_button_checked, size: 14, color: Color(0xFF16A34A)),
                const SizedBox(width: 8),
                Expanded(child: Text('Jemput: ${order.pickup}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Color(0xFFEF4444)),
                const SizedBox(width: 8),
                Expanded(child: Text('Tujuan: ${order.destination}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
              ],
            ),
          ],

          if (order.driverName.isNotEmpty && !isFood) ...[
            const SizedBox(height: 6),
            Text(
              'Driver: ${order.driverName} (${order.plateNumber ?? order.vehicleInfo})',
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ],

          if (order.review != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '⭐️ ${order.review}',
                style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF475569)),
              ),
            ),
          ],

          const SizedBox(height: 12),
          // Action buttons: Bukti Resi & Pesan Lagi
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onPressed: () => _showReceiptDialog(order),
                  child: const Text('Bukti Resi', style: TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onPressed: () {
                    if (widget.onReorder != null) {
                      widget.onReorder!(order.pickup, order.destination);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Membuat pesanan ulang ke ${order.destination}...')),
                      );
                    }
                  },
                  child: const Text('Pesan Lagi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 3: DIBATALKAN (Screen 7)
  Widget _buildCancelledOrdersView() {
    final allCancelled = RideService.cancelledOrders;
    final filtered = _cancelledFilter == 'Semua'
        ? allCancelled
        : allCancelled.where((o) => o.cancellationType == _cancelledFilter).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Smart Ride Notice Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.verified_user_rounded, color: Color(0xFF16A34A), size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart ride and PoliRide 100% Bebas Penalti',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF166534)),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Pembatalan tanpa penalti jika dibatalkan oleh sistem atau pengemudi dalam 5 menit pertama.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF15803D)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Filter chips: Semua, Batal Otomatis, Batal Pengemudi, Batal Pemesan
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('Semua'),
              _buildFilterChip('Batal Otomatis'),
              _buildFilterChip('Batal Pengemudi'),
              _buildFilterChip('Batal Pemesan'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        if (filtered.isEmpty) ...[
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text('Tidak ada riwayat pembatalan pada filter ini.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            ),
          ),
        ] else ...[
          ...filtered.map((order) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildCancelledOrderCard(order),
              )),
        ],

        const SizedBox(height: 10),

        // Ketentuan Pembatalan POLIRIDE Card matching Screen 7
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: Color(0xFF0284C7), size: 18),
                  SizedBox(width: 8),
                  Text('Ketentuan Pembatalan POLIRIDE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 8),
              _buildBulletPoint('Bebas Biaya: Pembatalan dalam 2 menit setelah driver menerima pesanan tidak dikenakan denda apapun.'),
              _buildBulletPoint('Denda Driver: Driver yang membatalkan sepihak tanpa alasan darurat akan diberikan sanksi skor performa.'),
              _buildBulletPoint('Batas Harian: Akun mahasiswa yang membatalkan lebih dari 3 kali berturut-turut akan terkena cooldown 30 menit.'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEF2F2),
                    foregroundColor: const Color(0xFFDC2626),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Color(0xFFFECACA)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(Icons.support_agent_rounded, size: 16),
                  label: const Text('Pusat Bantuan & Komplain CS Satpam', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  onPressed: _showSatpamContactDialog,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _cancelledFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {
          setState(() {
            _cancelledFilter = label;
          });
        },
        selectedColor: const Color(0xFF0284C7),
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? Colors.white : const Color(0xFF64748B),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? const Color(0xFF0284C7) : const Color(0xFFCBD5E1),
          ),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      ),
    );
  }

  Widget _buildCancelledOrderCard(RideOrder order) {
    final isDriverCancel = order.cancellationType == 'Batal Pengemudi';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDriverCancel ? const Color(0xFFEF4444) : const Color(0xFFF97316),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isDriverCancel ? 'DIBATALKAN DRIVER' : 'DIBATALKAN PEMESAN',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Text(
                order.dateTime,
                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.two_wheeler_rounded, size: 16, color: Color(0xFF0284C7)),
              const SizedBox(width: 6),
              Text(order.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.radio_button_checked, size: 12, color: Color(0xFF16A34A)),
              const SizedBox(width: 6),
              Expanded(child: Text('Jemput: ${order.pickup}', style: const TextStyle(fontSize: 12))),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.location_on, size: 12, color: Color(0xFFEF4444)),
              const SizedBox(width: 6),
              Expanded(child: Text('Tujuan: ${order.destination}', style: const TextStyle(fontSize: 12))),
            ],
          ),
          const SizedBox(height: 8),

          // Alasan pembatalan box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDriverCancel ? const Color(0xFFFEF2F2) : const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDriverCancel ? const Color(0xFFFEE2E2) : const Color(0xFFFFEDD5),
              ),
            ),
            child: Text(
              order.cancellationReason ?? 'Pesanan dibatalkan sesuai permintaan.',
              style: TextStyle(
                fontSize: 11,
                color: isDriverCancel ? const Color(0xFF991B1B) : const Color(0xFF9A3412),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Mencari driver baru untuk rute ${order.destination}...')),
                    );
                  },
                  child: const Text('Cari Driver Ulang', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tarif Rp 0 (Pembatalan bebas penalti)')),
                  );
                },
                child: const Text('Detail Refund', style: TextStyle(fontSize: 12, color: Color(0xFF475569))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
