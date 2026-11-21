import 'dart:async';
import 'package:flutter/material.dart';

class DriverSearchDialog extends StatefulWidget {
  final VoidCallback onDriverFound;
  final VoidCallback onCancel;

  const DriverSearchDialog({
    super.key,
    required this.onDriverFound,
    required this.onCancel,
  });

  @override
  State<DriverSearchDialog> createState() => _DriverSearchDialogState();
}

class _DriverSearchDialogState extends State<DriverSearchDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _driverFound = false;
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Simulate driver matching after 2.5 seconds
    _searchTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _driverFound = true;
        });
        Timer(const Duration(milliseconds: 1500), () {
          if (mounted) {
            Navigator.pop(context);
            widget.onDriverFound();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_driverFound) ...[
              // Radar animation
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
                'Menghubungkan ke mitra driver terdekat di area kampus Polinela...',
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
                  _searchTimer?.cancel();
                  Navigator.pop(context);
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
            ] else ...[
              // Driver found view
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
              const Text(
                'Budi Santoso (BE 4892 AF) sedang menuju ke titik penjemputan Anda.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
