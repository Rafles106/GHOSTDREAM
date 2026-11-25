import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/campus_spot_model.dart';
import '../models/pickup_point.dart';
import '../widgets/osm_map_widget.dart';
import 'konfirmasi_pesanan_screen.dart';

class TitikJemputScreen extends StatefulWidget {
  final CampusSpot? preselectedDestination;

  const TitikJemputScreen({super.key, this.preselectedDestination});

  @override
  State<TitikJemputScreen> createState() => _TitikJemputScreenState();
}

class _TitikJemputScreenState extends State<TitikJemputScreen> {
  static const LatLng _defaultPolinelaCoord = LatLng(-5.3578, 105.2335);

  late final List<CampusSpot> _campusSpots;
  late CampusSpot _pickupSpot;
  late CampusSpot _destinationSpot;
  bool _isSelectingPickup = false;

  @override
  void initState() {
    super.initState();

    _campusSpots = polinelaPickupPoints.map((point) {
      final hasCoordinate = point.latLng != null;
      return CampusSpot(
        id: 'POL-${point.id.padLeft(2, '0')}',
        name: point.name,
        category: 'Titik Jemput Polinela',
        description: hasCoordinate
            ? 'Koordinat: ${point.lat!.toStringAsFixed(6)}, ${point.lng!.toStringAsFixed(6)}'
            : 'Koordinat belum diisi (${point.name})',
        coordinate: point.latLng ?? _defaultPolinelaCoord,
      );
    }).toList();

    _pickupSpot = _campusSpots.firstWhere(
          (s) => s.name.toLowerCase().contains('perpustakaan'),
      orElse: () => _campusSpots.first,
    );

    _destinationSpot = widget.preselectedDestination ??
        _campusSpots.firstWhere(
              (s) => s.name.toLowerCase() == 'gkb',
          orElse: () =>
          _campusSpots.length > 1 ? _campusSpots[1] : _campusSpots.first,
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
          description:
          'Koordinat terpilih (${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)})',
          coordinate: point,
        );
      } else {
        _destinationSpot = CampusSpot(
          id: 'CUSTOM-DEST',
          name: 'Titik Tujuan di Peta',
          category: 'Kustom',
          description:
          'Koordinat terpilih (${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)})',
          coordinate: point,
        );
      }
    });
  }

  void _selectSpotFromSheet(bool isPickup) {
    String query = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredSpots = query.trim().isEmpty
                ? _campusSpots
                : _campusSpots
                .where((s) => s.name
                .toLowerCase()
                .contains(query.trim().toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Column(
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
                      isPickup
                          ? 'Pilih Titik Penjemputan (${filteredSpots.length} titik)'
                          : 'Pilih Titik Tujuan (${filteredSpots.length} titik)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      onChanged: (value) => setModalState(() => query = value),
                      decoration: InputDecoration(
                        hintText:
                        'Cari titik di Polinela (misal: GKB, Akademik, Kantin QB)...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredSpots.length,
                        separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final spot = filteredSpots[index];
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
                                isPickup
                                    ? Icons.person_pin_circle_rounded
                                    : Icons.location_on_rounded,
                                color: isPickup
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444),
                                size: 20,
                              ),
                            ),
                            title: Text(
                              spot.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                isSel ? FontWeight.bold : FontWeight.w600,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            subtitle: Text(
                              spot.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            trailing: isSel
                                ? const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF0284C7),
                            )
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
              ),
            );
          },
        );
      },
    );
  }

  void _proceedToOrder() {
    final sameSpotId = _pickupSpot.id == _destinationSpot.id;
    final sameCoord =
        _pickupSpot.coordinate.latitude == _destinationSpot.coordinate.latitude &&
            _pickupSpot.coordinate.longitude ==
                _destinationSpot.coordinate.longitude;

    if (sameSpotId || sameCoord) {
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
          Positioned.fill(
            child: OSMMapWidget(
              pickupLocation: _pickupSpot.coordinate,
              destinationLocation: _destinationSpot.coordinate,
              onTap: _onMapTap,
            ),
          ),
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
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF64748B),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1),
                    ),
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
                            icon: const Icon(
                              Icons.swap_vert_rounded,
                              color: Color(0xFF0284C7),
                            ),
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _campusSpots.map((spot) {
                          final isDest = spot.id == _destinationSpot.id;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(spot.name),
                              selected: isDest,
                              selectedColor: const Color(0xFFE0F2FE),
                              onSelected: (val) {
                                if (val) setState(() => _destinationSpot = spot);
                              },
                              labelStyle: TextStyle(
                                fontSize: 11,
                                fontWeight:
                                isDest ? FontWeight.bold : FontWeight.normal,
                                color: isDest
                                    ? const Color(0xFF0284C7)
                                    : const Color(0xFF475569),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _proceedToOrder,
                        icon: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                        ),
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