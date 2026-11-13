import 'package:flutter/material.dart';
import '../models/driver_model.dart';

class PenghasilanScreen extends StatefulWidget {
  final DriverModel driver;

  const PenghasilanScreen({super.key, required this.driver});

  @override
  State<PenghasilanScreen> createState() => _PenghasilanScreenState();
}

class _PenghasilanScreenState extends State<PenghasilanScreen> {
  int _selectedPeriod = 0; // 0: Hari Ini, 1: Mingguan, 2: Bulanan

  final List<Map<String, dynamic>> _todayTrips = [
    {
      'title': 'Trip Mahasiswa',
      'route': 'Gedung SFS ➔ Gedung GSG',
      'time': 'Hari ini • 11:20 WIB',
      'fare': 3000,
      'payment': 'Tunai',
    },
    {
      'title': 'Trip Mahasiswa',
      'route': 'GKB ➔ Kantin Perikanan',
      'time': 'Hari ini • 10:45 WIB',
      'fare': 3000,
      'payment': 'Tunai',
    },
    {
      'title': 'Trip Mahasiswa',
      'route': 'Asrama Mahasiswa Putri ➔ Graha Polinema',
      'time': 'Hari ini • 09:15 WIB',
      'fare': 3000,
      'payment': 'Tunai',
    },
    {
      'title': 'Trip Mahasiswa',
      'route': 'Gerbang Depan ➔ Gedung GFS',
      'time': 'Hari ini • 08:30 WIB',
      'fare': 3000,
      'payment': 'Tunai',
    },
    {
      'title': 'Trip Mahasiswa',
      'route': 'Gedung GSG ➔ Gedung Utama & Rektorat',
      'time': 'Hari ini • 07:50 WIB',
      'fare': 3000,
      'payment': 'Tunai',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Menghitung pendapatan berdasarkan tab
    final pendapatan = _selectedPeriod == 0
        ? 'Rp 85.000'
        : _selectedPeriod == 1
            ? 'Rp 590.000'
            : 'Rp 2.450.000';

    final totalTrip = _selectedPeriod == 0
        ? '7 Trip'
        : _selectedPeriod == 1
            ? '48 Trip'
            : '198 Trip';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Judul & Filter Periode (Hari Ini, Mingguan, Bulanan)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ringkasan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _buildPeriodTab(0, 'Hari Ini'),
                    _buildPeriodTab(1, 'Mingguan'),
                    _buildPeriodTab(2, 'Bulanan'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Card Ringkasan: "Pendapatan" (Ubah dari Pendapatan Bersih sesuai instruksi)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pendapatan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pendapatan,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Lunas Tunai',
                        style: TextStyle(fontSize: 11, color: Color(0xFF16A34A), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(height: 44, width: 1, color: const Color(0xFFE2E8F0)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Antaran',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        totalTrip,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tarif Flat Kampus',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Aktivitas Terakhir (Trip Mahasiswa)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Aktivitas Terakhir',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Menampilkan seluruh riwayat trip')),
                  );
                },
                child: const Text(
                  'Semua →',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // List item trip (Semua bonus insentif sudah dihapus sesuai instruksi)
          ..._todayTrips.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE0F2FE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.two_wheeler_rounded, color: Color(0xFF0284C7), size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['route'] as String,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['time'] as String,
                              style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '+Rp ${(item['fare'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item['payment'] as String,
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPeriodTab(int index, String label) {
    final isSelected = _selectedPeriod == index;
    return InkWell(
      onTap: () => setState(() => _selectedPeriod = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
