import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OSMMapWidget extends StatefulWidget {
  final LatLng initialCenter;
  final double initialZoom;
  final LatLng? pickupLocation;
  final LatLng? destinationLocation;
  final LatLng? driverLocation;
  final List<LatLng>? routePoints;
  final List<Marker>? additionalMarkers;
  final void Function(LatLng)? onTap;
  final bool isInteractive;
  final bool showRecenterButton;
  final MapController? mapController;

  const OSMMapWidget({
    super.key,
    this.initialCenter = const LatLng(-5.3578, 105.2335), // Polinela Center
    this.initialZoom = 16.5,
    this.pickupLocation,
    this.destinationLocation,
    this.driverLocation,
    this.routePoints,
    this.additionalMarkers,
    this.onTap,
    this.isInteractive = true,
    this.showRecenterButton = true,
    this.mapController,
  });

  @override
  State<OSMMapWidget> createState() => _OSMMapWidgetState();
}

class _OSMMapWidgetState extends State<OSMMapWidget> {
  late final MapController _controller;

  // Batas wilayah operasional kampus Polinela & Rajabasa
  static final LatLngBounds _polinelaBounds = LatLngBounds(
    const LatLng(-5.3700, 105.2200),
    const LatLng(-5.3450, 105.2500),
  );

  @override
  void initState() {
    super.initState();
    _controller = widget.mapController ?? MapController();
  }

  void _recenter() {
    if (widget.pickupLocation != null && widget.destinationLocation != null) {
      final bounds = LatLngBounds(
        widget.pickupLocation!,
        widget.destinationLocation!,
      );
      _controller.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(50),
        ),
      );
    } else if (widget.pickupLocation != null) {
      _controller.move(widget.pickupLocation!, 17.0);
    } else {
      _controller.move(widget.initialCenter, widget.initialZoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[];

    // Marker Pickup (Hijau)
    if (widget.pickupLocation != null) {
      markers.add(
        Marker(
          point: widget.pickupLocation!,
          width: 50,
          height: 50,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.person_pin_circle_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Marker Tujuan (Merah)
    if (widget.destinationLocation != null) {
      markers.add(
        Marker(
          point: widget.destinationLocation!,
          width: 50,
          height: 50,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Marker Driver (Motor Biru)
    if (widget.driverLocation != null) {
      markers.add(
        Marker(
          point: widget.driverLocation!,
          width: 54,
          height: 54,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0284C7).withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.white, width: 2.5),
            ),
            child: const Icon(
              Icons.two_wheeler_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      );
    }

    if (widget.additionalMarkers != null) {
      markers.addAll(widget.additionalMarkers!);
    }

    // Polylines Rute
    final polylines = <Polyline>[];
    if (widget.routePoints != null && widget.routePoints!.isNotEmpty) {
      polylines.add(
        Polyline(
          points: widget.routePoints!,
          strokeWidth: 5.0,
          color: const Color(0xFF0284C7),
        ),
      );
    } else if (widget.pickupLocation != null && widget.destinationLocation != null) {
      // Direct / Interpolated route polyline
      final midPoint = LatLng(
        (widget.pickupLocation!.latitude + widget.destinationLocation!.latitude) / 2,
        (widget.pickupLocation!.longitude + widget.destinationLocation!.longitude) / 2,
      );
      polylines.add(
        Polyline(
          points: [
            widget.pickupLocation!,
            midPoint,
            widget.destinationLocation!,
          ],
          strokeWidth: 4.5,
          color: const Color(0xFF0284C7),
        ),
      );
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialCenter: widget.initialCenter,
            initialZoom: widget.initialZoom,
            minZoom: 14.0,
            maxZoom: 19.0,
            cameraConstraint: CameraConstraint.contain(
              bounds: _polinelaBounds,
            ),
            interactionOptions: InteractionOptions(
              flags: widget.isInteractive
                  ? InteractiveFlag.all
                  : InteractiveFlag.none,
            ),
            onTap: widget.onTap != null
                ? (tapPosition, point) => widget.onTap!(point)
                : null,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.poliride.penumpang',
              maxZoom: 19,
            ),
            if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
            MarkerLayer(markers: markers),
          ],
        ),

        // Attribution Badge OSM
        Positioned(
          bottom: 6,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '© OpenStreetMap contributors',
              style: TextStyle(fontSize: 9, color: Color(0xFF475569)),
            ),
          ),
        ),

        // Floating Recenter Button
        if (widget.showRecenterButton && widget.isInteractive)
          Positioned(
            top: 14,
            right: 14,
            child: Material(
              color: Colors.white,
              elevation: 3,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _recenter,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.my_location_rounded,
                    color: Color(0xFF0284C7),
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
