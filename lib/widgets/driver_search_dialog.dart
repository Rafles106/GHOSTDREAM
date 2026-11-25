import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DriverSearchDialog extends StatefulWidget {
  final String? orderId;
  final VoidCallback onDriverFound;
  final VoidCallback onCancel;

  const DriverSearchDialog({
    super.key,
    this.orderId,
    required this.onDriverFound,
    required this.onCancel,
  });

  @override
  State<DriverSearchDialog> createState() => _DriverSearchDialogState();
}

class _DriverSearchDialogState extends State<DriverSearchDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _hasTriggeredFound = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleDriverMatched() {
    if (_hasTriggeredFound || !mounted) return;
    _hasTriggeredFound = true;

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onDriverFound();
    });
  }

  Widget _buildSearchingContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Container(
                    width: 60 + (_animController.value * 60),
                    height: 60 + (_animController.value * 60),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF0284C7).withOpacity(
                        (1 - _animController.value) * 0.4,
                      ),
                    ),
                  );
                },
              ),
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFF0284C7),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.two_wheeler_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Mencari Driver PoliRide...',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Menunggu mitra driver yang tersedia di area kampus Polinela menerima pesanan...',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onCancel();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFEF4444),
            side: const BorderSide(color: Color(0xFFFCA5A5)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Batalkan Pencarian'),
        ),
      ],
    );
  }

  Widget _buildDriverFoundContent({
    required String driverName,
    required String plateNumber,
    required String vehicleInfo,
  }) {
    final nameText = driverName.trim().isNotEmpty ? driverName.trim() : 'Driver';
    final plateText =
    plateNumber.trim().isNotEmpty ? ' (${plateNumber.trim()})' : '';
    final vehicleText =
    vehicleInfo.trim().isNotEmpty ? ' • ${vehicleInfo.trim()}' : '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Color(0xFFDCFCE7),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF16A34A),
              size: 44,
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Driver Ditemukan!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$nameText$plateText$vehicleText sedang menuju ke titik penjemputan Anda.',
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderId = widget.orderId;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: orderId == null || orderId.isEmpty
            ? _buildSearchingContent()
            : StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .doc(orderId)
              .snapshots(),
          builder: (context, snapshot) {
            final raw = snapshot.data?.data();
            final data = raw is Map<String, dynamic>
                ? raw
                : <String, dynamic>{};

            final status = (data['status'] ?? 'menunggu').toString();
            final driverName = (data['driverName'] ?? '').toString();
            final plateNumber = (data['plateNumber'] ?? '').toString();
            final vehicleInfo = (data['vehicleInfo'] ?? '').toString();

            final isMatched = driverName.trim().isNotEmpty &&
                (status == 'diterima' ||
                    status == 'menuju_jemput' ||
                    status == 'dalam_perjalanan');

            if (isMatched) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _handleDriverMatched();
              });
              return _buildDriverFoundContent(
                driverName: driverName,
                plateNumber: plateNumber,
                vehicleInfo: vehicleInfo,
              );
            }

            return _buildSearchingContent();
          },
        ),
      ),
    );
  }
}