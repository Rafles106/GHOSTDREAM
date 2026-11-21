import 'package:flutter/material.dart';

class CampusMapPlaceholder extends StatelessWidget {
  final VoidCallback? onOrderTap;
  final String? selectedLocation;
  final double height;
  final bool showDriver;
  final bool showTrafficOverlay;
  final String? badgeText;
  final String? subLabel;

  const CampusMapPlaceholder({
    super.key,
    this.onOrderTap,
    this.selectedLocation,
    this.height = 200,
    this.showDriver = true,
    this.showTrafficOverlay = true,
    this.badgeText,
    this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE5EEF3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Realistic vector map painter
            Positioned.fill(
              child: CustomPaint(
                painter: RealisticCampusMapPainter(
                  showTraffic: showTrafficOverlay,
                ),
              ),
            ),

            // Traffic / status badge top left
            if (badgeText != null || showTrafficOverlay)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: showTrafficOverlay ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        badgeText ?? '35 Driver Siaga di Kampus',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Top right compass / GPS icon
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.my_location_rounded,
                  size: 16,
                  color: Color(0xFF0284C7),
                ),
              ),
            ),

            // Moving Driver Pin Marker
            if (showDriver)
              Positioned(
                left: 70,
                bottom: height * 0.35,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0284C7).withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.two_wheeler_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Driver (Badar)',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Center / Destination Marker (Gedung GFS)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Text(
                      selectedLocation ?? 'Gedung GFS',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Icon(
                    Icons.location_on,
                    size: 34,
                    color: Color(0xFF0284C7),
                  ),
                  Container(
                    width: 10,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Sub Label (e.g. Zona Rawan Macet Polineks)
            Positioned(
              bottom: 10,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      subLabel ?? 'Zona Rawan Macet Polineks (Jam Pulang Kuliah)',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                  if (onOrderTap != null)
                    InkWell(
                      onTap: onOrderTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Pilih di Peta',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 12),
                          ],
                        ),
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
}

class RealisticCampusMapPainter extends CustomPainter {
  final bool showTraffic;

  RealisticCampusMapPainter({this.showTraffic = true});

  @override
  void paint(Canvas canvas, Size size) {
    // Background Campus Ground
    final groundPaint = Paint()..color = const Color(0xFFE8F0E8);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), groundPaint);

    // Green Fields / Garden zones
    final parkPaint = Paint()..color = const Color(0xFFD4EAD6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20, 20, size.width * 0.35, size.height * 0.4),
        const Radius.circular(16),
      ),
      parkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.6, size.height * 0.45, size.width * 0.35, size.height * 0.45),
        const Radius.circular(16),
      ),
      parkPaint,
    );

    // Main Roads
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadBorderPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 22
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(-20, size.height * 0.75);
    path.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.7,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.65,
      size.height * 0.3,
      size.width + 20,
      size.height * 0.25,
    );

    final crossPath = Path();
    crossPath.moveTo(size.width * 0.2, -20);
    crossPath.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.35,
      size.width * 0.5,
      size.height * 0.5,
    );
    crossPath.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.65,
      size.width * 0.7,
      size.height + 20,
    );

    // Draw borders then roads
    canvas.drawPath(path, roadBorderPaint);
    canvas.drawPath(crossPath, roadBorderPaint);
    canvas.drawPath(path, roadPaint);
    canvas.drawPath(crossPath, roadPaint);

    // Campus Buildings
    final buildingPaint = Paint()..color = const Color(0xFFCBD5E1);
    final buildingStroke = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Building 1: GKB
    final gkbRect = Rect.fromLTWH(size.width * 0.08, size.height * 0.15, 65, 45);
    canvas.drawRRect(RRect.fromRectAndRadius(gkbRect, const Radius.circular(6)), buildingPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(gkbRect, const Radius.circular(6)), buildingStroke);

    // Building 2: GSD Polineks
    final gsdRect = Rect.fromLTWH(size.width * 0.68, size.height * 0.12, 75, 42);
    canvas.drawRRect(RRect.fromRectAndRadius(gsdRect, const Radius.circular(6)), buildingPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(gsdRect, const Radius.circular(6)), buildingStroke);

    // Building 3: Kantin
    final kantinRect = Rect.fromLTWH(size.width * 0.15, size.height * 0.75, 55, 38);
    canvas.drawRRect(RRect.fromRectAndRadius(kantinRect, const Radius.circular(6)), buildingPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(kantinRect, const Radius.circular(6)), buildingStroke);

    // Building 4: Gedung GFS (Center)
    final gfsRect = Rect.fromLTWH(size.width * 0.52, size.height * 0.55, 75, 45);
    canvas.drawRRect(RRect.fromRectAndRadius(gfsRect, const Radius.circular(6)), buildingPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(gfsRect, const Radius.circular(6)), buildingStroke);

    // Route Highlight (Dotted Cyan/Blue line)
    final routePaint = Paint()
      ..color = const Color(0xFF0284C7)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final tripPath = Path();
    tripPath.moveTo(60, size.height * 0.75);
    tripPath.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.68,
      size.width * 0.5,
      size.height * 0.52,
    );
    canvas.drawPath(tripPath, routePaint);

    // Traffic Jam / Heatzone overlay
    if (showTraffic) {
      final trafficGlow = Paint()
        ..color = const Color(0x55F87171)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
      canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.68), 35, trafficGlow);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
