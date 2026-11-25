import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../models/ride_model.dart';
import '../services/ride_service.dart';
import 'detail_aktivitas_screen.dart';

class AktivitasScreen extends StatefulWidget {
  const AktivitasScreen({super.key});

  @override
  State<AktivitasScreen> createState() => _AktivitasScreenState();
}

class _AktivitasScreenState extends State<AktivitasScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RideService _rideService = RideService();
  final NumberFormat _rupiahNumberFormat = NumberFormat('#,##0', 'en_US');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  String _formatRupiah(double amount) {
    final formatted = _rupiahNumberFormat.format(amount.round()).replaceAll(',', '.');
    return 'Rp $formatted';
  }

  String _formatTimestamp(dynamic createdAt) {
    if (createdAt is! Timestamp) {
      return 'Baru saja';
    }
    try {
      final dt = createdAt.toDate();
      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      final year = dt.year.toString();
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');
      return '$day/$month/$year $hour:$minute';
    } catch (_) {
      return 'Baru saja';
    }
  }

  RideOrder _mapDocToOrder(QueryDocumentSnapshot doc) {
    final rawData = doc.data();
    final data =
    rawData is Map<String, dynamic> ? rawData : <String, dynamic>{};

    final pickupLat = (data['pickupLat'] as num?)?.toDouble() ??
        RideService.polinelaCenter.latitude;
    final pickupLng = (data['pickupLng'] as num?)?.toDouble() ??
        RideService.polinelaCenter.longitude;
    final destLat = (data['destinationLat'] as num?)?.toDouble() ??
        RideService.polinelaCenter.latitude;
    final destLng = (data['destinationLng'] as num?)?.toDouble() ??
        RideService.polinelaCenter.longitude;

    final driverLat = (data['driverCurrentLat'] as num?)?.toDouble();
    final driverLng = (data['driverCurrentLng'] as num?)?.toDouble();

    return RideOrder(
      id: (data['id'] ?? doc.id).toString(),
      type: RideType.poliRide,
      title: (data['title'] ?? 'Perjalanan PoliRide').toString(),
      pickup: (data['pickup'] ?? 'Titik Jemput').toString(),
      pickupCoord: LatLng(pickupLat, pickupLng),
      destination: (data['destination'] ?? 'Titik Tujuan').toString(),
      destinationCoord: LatLng(destLat, destLng),
      dateTime: _formatTimestamp(data['createdAt']),
      fare: (data['fare'] as num?)?.toDouble() ?? 5000.0,
      status: _parseStatus((data['status'] ?? 'menunggu').toString()),
      driverName: (data['driverName'] ?? '').toString(),
      driverPhone: (data['driverPhone'] ?? '').toString(),
      vehicleInfo: (data['vehicleInfo'] ?? '').toString(),
      plateNumber: (data['plateNumber'] ?? '').toString(),
      driverRating: (data['driverRating'] as num?)?.toDouble() ?? 4.9,
      driverTrips: (data['driverTrips'] as num?)?.toInt() ?? 0,
      driverCurrentCoord: (driverLat != null && driverLng != null)
          ? LatLng(driverLat, driverLng)
          : null,
      paymentMethod: (data['paymentMethod'] ?? 'Tunai').toString(),
      pickupNote: data['pickupNote']?.toString(),
      distance: (data['distance'] ?? '-').toString(),
      duration: (data['duration'] ?? '-').toString(),
      cancellationReason: data['cancellationReason']?.toString(),
      ratingGiven: (data['ratingGiven'] as num?)?.toDouble(),
      review: data['review']?.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Riwayat Aktivitas',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF0284C7),
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: const Color(0xFF0284C7),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Selesai'),
            Tab(text: 'Dibatalkan'),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _rideService.watchMyOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Gagal memuat riwayat: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
              ),
            );
          }

          final rawSnapshot = snapshot.data;
          final docs = rawSnapshot is QuerySnapshot
              ? rawSnapshot.docs
              : <QueryDocumentSnapshot>[];

          final allOrders = docs.map(_mapDocToOrder).toList();
          final completed =
          allOrders.where((o) => o.status == RideStatus.selesai).toList();
          final cancelled =
          allOrders.where((o) => o.status == RideStatus.dibatalkan).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOrderList(
                orders: completed,
                emptyMessage: 'Belum ada riwayat perjalanan selesai.',
                isCancelled: false,
              ),
              _buildOrderList(
                orders: cancelled,
                emptyMessage: 'Tidak ada pesanan yang dibatalkan.',
                isCancelled: true,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderList({
    required List<RideOrder> orders,
    required String emptyMessage,
    required bool isCancelled,
  }) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 56,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];
        final badgeColor = isCancelled
            ? const Color(0xFFEF4444)
            : const Color(0xFF10B981);

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailAktivitasScreen(order: order),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
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
                    Text(
                      order.dateTime,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isCancelled ? 'Dibatalkan' : 'Selesai',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${order.pickup} → ${order.destination}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                if (isCancelled &&
                    order.cancellationReason != null &&
                    order.cancellationReason!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Alasan: ${order.cancellationReason}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.paymentMethod,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF475569),
                      ),
                    ),
                    Text(
                      _formatRupiah(order.fare),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}