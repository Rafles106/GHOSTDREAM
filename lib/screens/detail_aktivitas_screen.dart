import 'package:cloud_firestore/cloud_firestore.dart';
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
  String _firestoreStatus = 'menunggu';

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
  }

  RideStatus _parseStatus(String rawStatus) {
    switch (rawStatus) {
      case 'dalam_perjalanan':
      case 'dalamPerjalanan':
        return RideStatus.dalamPerjalanan;
      case 'selesai':
        return RideStatus.selesai;
      case 'dibatalkan':
        return RideStatus.dibatalkan;
      case 'menuju_jemput':
      case 'menujuJemput':
      case 'diterima':
      case 'menunggu':
      default:
        return RideStatus.menujuJemput;
    }
  }

  void _syncOrderFromDoc(Map<String, dynamic>? data) {
    if (data == null) return;

    final statusStr = (data['status'] ?? 'menunggu').toString();
    _firestoreStatus = statusStr;

    final driverLat = (data['driverCurrentLat'] as num?)?.toDouble();
    final driverLng = (data['driverCurrentLng'] as num?)?.toDouble();
    final driverCoord = (driverLat != null && driverLng != null)
        ? LatLng(driverLat, driverLng)
        : _currentOrder.driverCurrentCoord;

    _currentOrder = _currentOrder.copyWith(
      driverName: (data['driverName'] ?? _currentOrder.driverName).toString(),
      driverPhone:
      (data['driverPhone'] ?? _currentOrder.driverPhone)?.toString(),
      vehicleInfo:
      (data['vehicleInfo'] ?? _currentOrder.vehicleInfo).toString(),
      plateNumber:
      (data['plateNumber'] ?? _currentOrder.plateNumber).toString(),
      driverRating: (data['driverRating'] as num?)?.toDouble() ??
          _currentOrder.driverRating,
      driverTrips:
      (data['driverTrips'] as num?)?.toInt() ?? _currentOrder.driverTrips,
      driverCurrentCoord: driverCoord,
      status: _parseStatus(statusStr),
    );
  }

  void _completeRide() {
    final driverDisplay = _currentOrder.driverName.isNotEmpty
        ? _currentOrder.driverName
        : 'Driver';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => RatingDialog(
        driverName: driverDisplay,
        onSubmit: (rating, review) async {
          await _rideService.completeActiveOrder(
            orderId: _currentOrder.id,
            rating: rating,
            review: review,
          );
          if (!mounted) return;
          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Terima kasih telah memberikan ulasan! Perjalanan selesai.',
              ),
              backgroundColor: Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _cancelRide() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Batalkan Pesanan?'),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan perjalanan ini?',
          style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Tidak, Lanjutkan'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _rideService.cancelActiveOrder(
                orderId: _currentOrder.id,
                reason: 'Dibatalkan oleh penumpang',
              );
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pesanan berhasil dibatalkan.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _rideService.watchOrder(_currentOrder.id),
      builder: (context, snapshot) {
        final Object? rawDoc = snapshot.data;
        Map<String, dynamic>? docData;
        if (rawDoc is DocumentSnapshot) {
          final Object? rawMap = rawDoc.data();
          if (rawMap is Map<String, dynamic>) {
            docData = rawMap;
          }
        }

        _syncOrderFromDoc(docData);

        final isWaitingDriver = _firestoreStatus == 'menunggu' &&
            _currentOrder.driverName.trim().isEmpty;

        final statusText = isWaitingDriver
            ? 'Menunggu Konfirmasi Driver'
            : _currentOrder.status == RideStatus.menujuJemput
            ? 'Driver Menuju Titik Jemput'
            : _currentOrder.status == RideStatus.dalamPerjalanan
            ? 'Sedang Menuju Lokasi Tujuan'
            : _currentOrder.status == RideStatus.selesai
            ? 'Perjalanan Selesai'
            : 'Pesanan Dibatalkan';

        final statusColor = isWaitingDriver
            ? const Color(0xFFF59E0B)
            : _currentOrder.status == RideStatus.menujuJemput
            ? const Color(0xFF0284C7)
            : _currentOrder.status == RideStatus.dalamPerjalanan
            ? const Color(0xFF10B981)
            : _currentOrder.status == RideStatus.selesai
            ? const Color(0xFF059669)
            : const Color(0xFFEF4444);

        final driverName = _currentOrder.driverName.trim().isNotEmpty
            ? _currentOrder.driverName
            : 'Mencari Driver...';
        final vehicleSummary = [
          if (_currentOrder.vehicleInfo.trim().isNotEmpty)
            _currentOrder.vehicleInfo.trim(),
          if (_currentOrder.plateNumber.trim().isNotEmpty)
            _currentOrder.plateNumber.trim(),
        ].join(' • ');

        final activeDriverCoord =
            _currentOrder.driverCurrentCoord ?? _currentOrder.pickupCoord;

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
              Positioned.fill(
                child: OSMMapWidget(
                  initialCenter: activeDriverCoord,
                  pickupLocation: _currentOrder.pickupCoord,
                  destinationLocation: _currentOrder.destinationCoord,
                  driverLocation: isWaitingDriver ? null : activeDriverCoord,
                  routePoints: [
                    _currentOrder.pickupCoord,
                    if (!isWaitingDriver) activeDriverCoord,
                    _currentOrder.destinationCoord,
                  ],
                ),
              ),
              Positioned(
                top: 14,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
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
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
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
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 38,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 26,
                            backgroundColor: Color(0xFFE0F2FE),
                            child: Icon(
                              Icons.two_wheeler_rounded,
                              color: Color(0xFF0284C7),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driverName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 16,
                                      color: Color(0xFFF59E0B),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_currentOrder.driverRating} (${_currentOrder.driverTrips} trip)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                  ],
                                ),
                                if (vehicleSummary.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    vehicleSummary,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0284C7),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton.filledTonal(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ChatScreen(driverName: driverName),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Color(0xFF0284C7),
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFFE0F2FE),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Jemput:',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  _currentOrder.pickup,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Tujuan:',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  _currentOrder.destination,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_currentOrder.status == RideStatus.menujuJemput ||
                          _currentOrder.status == RideStatus.dalamPerjalanan)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _cancelRide,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFEF4444),
                                  side: const BorderSide(
                                    color: Color(0xFFFCA5A5),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
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
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0284C7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
      },
    );
  }
}