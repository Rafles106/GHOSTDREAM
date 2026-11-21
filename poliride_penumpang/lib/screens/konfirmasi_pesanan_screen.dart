import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/campus_spot_model.dart';
import '../models/ride_model.dart';
import '../services/auth_service.dart';
import '../services/ride_service.dart';
import '../widgets/driver_search_dialog.dart';
import '../widgets/osm_map_widget.dart';
import 'detail_aktivitas_screen.dart';

class KonfirmasiPesananScreen extends StatefulWidget {
  final CampusSpot pickupSpot;
  final CampusSpot destinationSpot;

  const KonfirmasiPesananScreen({
    super.key,
    required this.pickupSpot,
    required this.destinationSpot,
  });

  @override
  State<KonfirmasiPesananScreen> createState() => _KonfirmasiPesananScreenState();
}

class _KonfirmasiPesananScreenState extends State<KonfirmasiPesananScreen> {
  final AuthService _auth = AuthService();
  final RideService _rideService = RideService();
  final TextEditingController _noteController = TextEditingController();

  RideType _selectedVehicle = RideType.poliRide;
  String _selectedPayment = 'PoliPay (Saldo)';

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _handlePlaceOrder() {
    final fare = _selectedVehicle == RideType.poliCar ? 12000.0 : 5000.0;
    final userBalance = _auth.currentUser?.balance ?? 0.0;

    if (_selectedPayment == 'PoliPay (Saldo)' && userBalance < fare) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saldo PoliPay tidak cukup. Silakan isi saldo atau pilih metode Tunai.'),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Show Driver Search Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DriverSearchDialog(
        onDriverFound: () async {
          final newOrder = await _rideService.createOrder(
            pickup: widget.pickupSpot.name,
            pickupCoord: widget.pickupSpot.coordinate,
            destination: widget.destinationSpot.name,
            destinationCoord: widget.destinationSpot.coordinate,
            type: _selectedVehicle,
            paymentMethod: _selectedPayment,
            pickupNote: _noteController.text.trim().isNotEmpty
                ? _noteController.text.trim()
                : null,
          );

          if (_selectedPayment == 'PoliPay (Saldo)') {
            _auth.deductBalance(fare);
          }

          if (!mounted) return;

          // Navigate to Live Tracking
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DetailAktivitasScreen(order: newOrder),
            ),
          );
        },
        onCancel: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pencarian driver dibatalkan.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final curFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
    final fare = _selectedVehicle == RideType.poliCar ? 12000.0 : 5000.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Konfirmasi Pemesanan',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. OpenStreetMap Route Preview
          SizedBox(
            height: 220,
            width: double.infinity,
            child: OSMMapWidget(
              pickupLocation: widget.pickupSpot.coordinate,
              destinationLocation: widget.destinationSpot.coordinate,
              isInteractive: true,
              showRecenterButton: false,
            ),
          ),

          // 2. Booking Options Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route summary card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.radio_button_checked_rounded, color: Color(0xFF10B981), size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.pickupSpot.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Container(
                            height: 16,
                            width: 2,
                            color: const Color(0xFFCBD5E1),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, color: Color(0xFFEF4444), size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.destinationSpot.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Vehicle choice
                  const Text(
                    'Pilih Layanan Kendaraan',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildVehicleCard(
                          type: RideType.poliRide,
                          name: 'PoliRide',
                          desc: 'Motor Cepat Kampus',
                          price: 'Rp 5.000',
                          icon: Icons.two_wheeler_rounded,
                          color: const Color(0xFF0284C7),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildVehicleCard(
                          type: RideType.poliCar,
                          name: 'PoliCar',
                          desc: 'Mobil Rombongan',
                          price: 'Rp 12.000',
                          icon: Icons.directions_car_rounded,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Payment method
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPayment,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                            value: 'PoliPay (Saldo)',
                            child: Row(
                              children: [
                                const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF0284C7), size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  'PoliPay Saldo (${curFormat.format(_auth.currentUser?.balance ?? 0)})',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const DropdownMenuItem(
                            value: 'Tunai (Bayar ke Driver)',
                            child: Row(
                              children: [
                                Icon(Icons.money_rounded, color: Color(0xFF10B981), size: 20),
                                SizedBox(width: 10),
                                Text('Tunai (Bayar ke Driver)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          const DropdownMenuItem(
                            value: 'QRIS Polinela',
                            child: Row(
                              children: [
                                Icon(Icons.qr_code_scanner_rounded, color: Color(0xFFF59E0B), size: 20),
                                SizedBox(width: 10),
                                Text('QRIS Polinela', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedPayment = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pickup note
                  const Text(
                    'Catatan Penjemputan (Opsional)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Tunggu di depan lobi pakai jaket hitam',
                      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom Checkout Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total Tarif Kampus',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      Text(
                        curFormat.format(fare),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _handlePlaceOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0284C7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Pesan Sekarang',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard({
    required RideType type,
    required String name,
    required String desc,
    required String price,
    required IconData icon,
    required Color color,
  }) {
    final isSel = _selectedVehicle == type;
    return InkWell(
      onTap: () => setState(() => _selectedVehicle = type),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSel ? color.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSel ? color : const Color(0xFFE2E8F0),
            width: isSel ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 26),
                if (isSel)
                  Icon(Icons.check_circle_rounded, color: color, size: 18),
              ],
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text(desc, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            const SizedBox(height: 6),
            Text(
              price,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
