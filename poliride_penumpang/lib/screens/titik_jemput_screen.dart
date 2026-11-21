import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/campus_spot_model.dart';
import '../models/ride_model.dart';
import '../services/ride_service.dart';
import '../widgets/osm_map_widget.dart';
import 'konfirmasi_pesanan_screen.dart';

class TitikJemputScreen extends StatefulWidget {
  final CampusSpot? preselectedDestination;

  const TitikJemputScreen({super.key, this.preselectedDestination});

  @override
  State<TitikJemputScreen> createState() => _TitikJemputScreenState();
}

class _TitikJemputScreenState extends State<TitikJemputScreen> {
  late CampusSpot _pickupSpot;
  late CampusSpot _destinationSpot;
  bool _isSelectingPickup = false; // toggle whether map taps update pickup or destination

  @override
  void initState() {
    super.initState();
    // Default pickup: Gedung GFS
    _pickupSpot = RideService.campusSpots.firstWhere(
      (s) => s.id == 'LOC-02',
      orElse: () => RideService.campusSpots[0],
    );

    // Default destination: GKB or preselected
    _destinationSpot = widget.preselectedDestination ??
        RideService.campusSpots.firstWhere(
          (s) => s.id == 'LOC-01',
          orElse: () => RideService.campusSpots[1],
        );
  }

  void _swapLocations() {
    setState(() {
      final temp = _pickupSpot;
      _pickupSpot = _destinationSpot;
      _destinationSpot = temp;
    });
  }

  void _onMapTap(LatLng point) {
    setState(() {
      if (_isSelectingPickup) {
        _pickupSpot = CampusSpot(
          id: 'CUSTOM-PICKUP',
          name: 'Titik Jemput di Peta',
          category: 'Kustom',
          description: 'Koordinat terpilih (${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)})',
          coordinate: point,
        );
      } else {
        _destinationSpot = CampusSpot(
          id: 'CUSTOM-DEST',
          name: 'Titik Tujuan di Peta',
          category: 'Kustom',
          description: 'Koordinat terpilih (${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)})',
          coordinate: point,
        );
      }
    });
  }

  void _selectSpotFromSheet(bool isPickup) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                isPickup ? 'Pilih Titik Penjemputan Kampus' : 'Pilih Titik Tujuan Kampus',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: RideService.campusSpots.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final spot = RideService.campusSpots[index];
                    final isSel = isPickup
                        ? spot.id == _pickupSpot.id
                        : spot.id == _destinationSpot.id;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isPickup
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFFEE2E2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPickup ? Icons.person_pin_circle_rounded : Icons.location_on_rounded,
                          color: isPickup ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        spot.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      subtitle: Text(
                        '${spot.category} • ${spot.distance}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                      trailing: isSel
                          ? const Icon(Icons.check_circle_rounded, color: Color(0xFF0284C7))
                          : null,
                      onTap: () {
                        setState(() {
                          if (isPickup) {
                            _pickupSpot = spot;
                          } else {
                            _destinationSpot = spot;
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _proceedToOrder() {
    if (_pickupSpot.id == _destinationSpot.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Titik jemput dan tujuan tidak boleh sama!'),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KonfirmasiPesananScreen(
          pickupSpot: _pickupSpot,
          destinationSpot: _destinationSpot,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pilih Titik Jemput & Tujuan',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. Full OpenStreetMap View
          Positioned.fill(
            child: OSMMapWidget(
              pickupLocation: _pickupSpot.coordinate,
              destinationLocation: _destinationSpot.coordinate,
              onTap: _onMapTap,
            ),
          ),

          // 2. Top Location Selection Panel
          Positioned(
            top: 12,
            left: 14,
            right: 14,
            child: Card(
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    // Pickup Row
                    InkWell(
                      onTap: () {
                        setState(() => _isSelectingPickup = true);
                        _selectSpotFromSheet(true);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Titik Penjemputan',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _pickupSpot.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1),
                    ),

                    // Destination Row
                    InkWell(
                      onTap: () {
                        setState(() => _isSelectingPickup = false);
                        _selectSpotFromSheet(false);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Titik Tujuan',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _destinationSpot.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.swap_vert_rounded, color: Color(0xFF0284C7)),
                            onPressed: _swapLocations,
                            tooltip: 'Tukar Lokasi',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Bottom Action Card
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Card(
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Quick chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: RideService.campusSpots.map((spot) {
                          final isDest = spot.id == _destinationSpot.id;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(spot.name.split('(').first.trim()),
                              selected: isDest,
                              selectedColor: const Color(0xFFE0F2FE),
                              onSelected: (val) {
                                if (val) setState(() => _destinationSpot = spot);
                              },
                              labelStyle: TextStyle(
                                fontSize: 11,
                                fontWeight: isDest ? FontWeight.bold : FontWeight.normal,
                                color: isDest ? const Color(0xFF0284C7) : const Color(0xFF475569),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Confirm Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _proceedToOrder,
                        icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                        label: const Text(
                          'Lanjut Konfirmasi Pesanan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0284C7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
