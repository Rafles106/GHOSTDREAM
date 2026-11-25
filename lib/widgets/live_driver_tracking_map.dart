import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LiveDriverTrackingMap extends StatefulWidget {
  final String orderId;
  final double height;

  const LiveDriverTrackingMap({
    super.key,
    required this.orderId,
    this.height = 240,
  });

  @override
  State<LiveDriverTrackingMap> createState() => _LiveDriverTrackingMapState();
}

class _LiveDriverTrackingMapState extends State<LiveDriverTrackingMap> {
  final MapController _mapController = MapController();
  LatLng? _lastCenteredPos;

  String _statusLabel(String rawStatus) {
    switch (rawStatus) {
      case 'menuju_jemput':
      case 'diterima':
        return 'Driver sedang menuju titik jemput';
      case 'dalam_perjalanan':
        return 'Dalam perjalanan menuju tujuan';
      case 'selesai':
        return 'Perjalanan telah selesai';
      case 'dibatalkan':
        return 'Pesanan dibatalkan';
      default:
        return 'Menunggu driver';
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderDocStream = FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: orderDocStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return SizedBox(
            height: widget.height,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final raw = snapshot.data?.data();
        final data = raw is Map<String, dynamic> ? raw : null;
        if (data == null) {
          return SizedBox(
            height: widget.height,
            child: const Center(child: Text('Data perjalanan tidak ditemukan.')),
          );
        }

        final status = (data['status'] ?? 'menunggu').toString();
        final pickupLat = (data['pickupLat'] as num?)?.toDouble() ?? -5.3578;
        final pickupLng = (data['pickupLng'] as num?)?.toDouble() ?? 105.2335;
        final destLat =
            (data['destinationLat'] as num?)?.toDouble() ?? -5.3558;
        final destLng =
            (data['destinationLng'] as num?)?.toDouble() ?? 105.2338;

        final hasDriverCoord =
            data['driverCurrentLat'] != null && data['driverCurrentLng'] != null;
        final driverLat =
            (data['driverCurrentLat'] as num?)?.toDouble() ?? pickupLat;
        final driverLng =
            (data['driverCurrentLng'] as num?)?.toDouble() ?? pickupLng;

        final pickupPos = LatLng(pickupLat, pickupLng);
        final destPos = LatLng(destLat, destLng);
        final driverPos = LatLng(driverLat, driverLng);

        final bool isGoingToDestination = status == 'dalam_perjalanan';
        final targetPos = isGoingToDestination ? destPos : pickupPos;
        final routePoints = hasDriverCoord
            ? [driverPos, targetPos]
            : [pickupPos, destPos];

        if (hasDriverCoord) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            if (_lastCenteredPos == null ||
                _lastCenteredPos!.latitude != driverPos.latitude ||
                _lastCenteredPos!.longitude != driverPos.longitude) {
              _lastCenteredPos = driverPos;
              try {
                _mapController.move(driverPos, _mapController.camera.zoom);
              } catch (_) {}
            }
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.two_wheeler,
                    size: 18,
                    color: Color(0xFF0284C7),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _statusLabel(status),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0369A1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: widget.height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: hasDriverCoord ? driverPos : pickupPos,
                    initialZoom: 16.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.poliride.penumpang',
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: routePoints,
                          strokeWidth: 4.5,
                          color: isGoingToDestination
                              ? const Color(0xFF0284C7)
                              : const Color(0xFF10B981),
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: pickupPos,
                          width: 34,
                          height: 34,
                          child: const Icon(
                            Icons.location_on,
                            color: Color(0xFF16A34A),
                            size: 32,
                          ),
                        ),
                        if (hasDriverCoord)
                          Marker(
                            point: driverPos,
                            width: 40,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.two_wheeler,
                                color: Color(0xFF0284C7),
                                size: 24,
                              ),
                            ),
                          ),
                        Marker(
                          point: destPos,
                          width: 34,
                          height: 34,
                          child: const Icon(
                            Icons.location_pin,
                            color: Color(0xFFEF4444),
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}