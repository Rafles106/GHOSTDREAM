import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/ride_model.dart';
import '../services/ride_service.dart';
import '../widgets/osm_map_widget.dart';
import '../widgets/rating_dialog.dart';
import 'chat_screen.dart';

class DetailAktivitasScreen extends StatefulWidget {
  final RideOrder order;

  const DetailAktivitasScreen({super.key, required this.order});

  @override
  State<DetailAktivitasScreen> createState() => _DetailAktivitasScreenState();
}

class _DetailAktivitasScreenState extends State<DetailAktivitasScreen> {
  final RideService _rideService = RideService();
  late RideOrder _currentOrder;
  Timer? _mockMovementTimer;

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
    _rideService.addListener(_onServiceUpdate);

    // Simulate driver moving towards pickup
    _startDriverMovementSimulation();
  }

  @override
  void dispose() {
    _mockMovementTimer?.cancel();
    _rideService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted && _rideService.activeOrder != null) {
      setState(() {
        _currentOrder = _rideService.activeOrder!;
      });
    }
  }

  void _startDriverMovementSimulation() {
    int step = 0;
    _mockMovementTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      if (_currentOrder.status == RideStatus.selesai || _currentOrder.status == RideStatus.dibatalkan) {
        timer.cancel();
        return;
      }

      step++;
      final driverCurrent = _currentOrder.driverCurrentCoord ?? _currentOrder.pickupCoord;

      if (_currentOrder.status == RideStatus.menujuJemput) {
        // Move towards pickup
        final newLat = driverCurrent.latitude + (_currentOrder.pickupCoord.latitude - driverCurrent.latitude) * 0.35;
        final newLng = driverCurrent.longitude + (_currentOrder.pickupCoord.longitude - driverCurrent.longitude) * 0.35;
        _rideService.updateDriverPosition(LatLng(newLat, newLng));

        if (step >= 3) {
          _rideService.setOrderStatus(RideStatus.dalamPerjalanan);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Driver telah tiba dan perjalanan dimulai! 🚀'),
              backgroundColor: Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else if (_currentOrder.status == RideStatus.dalamPerjalanan) {
        // Move towards destination
        final newLat = driverCurrent.latitude + (_currentOrder.destinationCoord.latitude - driverCurrent.latitude) * 0.4;
        final newLng = driverCurrent.longitude + (_currentOrder.destinationCoord.longitude - driverCurrent.longitude) * 0.4;
        _rideService.updateDriverPosition(LatLng(newLat, newLng));
      }
    });
  }

  void _completeRide() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RatingDialog(
        driverName: _currentOrder.driverName,
        onSubmit: (rating, review) {
          _rideService.completeActiveOrder(rating: rating, review: review);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Terima kasih telah memberikan ulasan! Perjalanan selesai.'),
              backgroundColor: Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  void _cancelRide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Batalkan Pesanan?'),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan perjalanan ini? Driver sudah bersiap menuju lokasi Anda.',
          style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak, Lanjutkan'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _rideService.cancelActiveOrder(reason: 'Dibatalkan oleh penumpang');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pesanan berhasil dibatalkan.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusText = _currentOrder.status == RideStatus.menujuJemput
        ? 'Driver Menuju Titik Jemput'
        : _currentOrder.status == RideStatus.dalamPerjalanan
            ? 'Sedang Dalam Perjalanan'
            : _currentOrder.status == RideStatus.selesai
                ? 'Perjalanan Selesai'
                : 'Pesanan Dibatalkan';

    final statusColor = _currentOrder.status == RideStatus.menujuJemput
        ? const Color(0xFF0284C7)
        : _currentOrder.status == RideStatus.dalamPerjalanan
            ? const Color(0xFF10B981)
            : _currentOrder.status == RideStatus.selesai
                ? const Color(0xFF059669)
                : const Color(0xFFEF4444);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _currentOrder.id,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. Live OpenStreetMap
          Positioned.fill(
            child: OSMMapWidget(
              pickupLocation: _currentOrder.pickupCoord,
              destinationLocation: _currentOrder.destinationCoord,
              driverLocation: _currentOrder.driverCurrentCoord,
            ),
          ),

          // 2. Status Pill at Top
          Positioned(
            top: 14,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Driver & Trip Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Driver Details
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: const Color(0xFFE0F2FE),
                        child: const Icon(Icons.two_wheeler_rounded, color: Color(0xFF0284C7), size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentOrder.driverName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                                const SizedBox(width: 4),
                                Text(
                                  '${_currentOrder.driverRating} (${_currentOrder.driverTrips} trip)',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_currentOrder.vehicleInfo} • ${_currentOrder.plateNumber}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Chat Button
                      IconButton.filledTonal(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(driverName: _currentOrder.driverName),
                            ),
                          );
                        },
                        icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF0284C7)),
                        style: IconButton.styleFrom(backgroundColor: const Color(0xFFE0F2FE)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Route overview
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Jemput:', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                          Text(_currentOrder.pickup, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFF94A3B8)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Tujuan:', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                          Text(_currentOrder.destination, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Bottom Action Buttons
                  if (_currentOrder.status == RideStatus.menujuJemput ||
                      _currentOrder.status == RideStatus.dalamPerjalanan)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _cancelRide,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFEF4444),
                              side: const BorderSide(color: Color(0xFFFCA5A5)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Batalkan'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _completeRide,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Selesai (Sampai)'),
                          ),
                        ),
                      ],
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0284C7),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Kembali ke Beranda'),
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
}
