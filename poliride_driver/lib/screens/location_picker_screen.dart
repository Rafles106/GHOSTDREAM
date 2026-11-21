import 'package:flutter/material.dart';
import '../services/ride_service.dart';
import '../widgets/campus_map_placeholder.dart';
import '../widgets/custom_button.dart';

class LocationPickerScreen extends StatefulWidget {
  final String initialSpot;

  const LocationPickerScreen({
    super.key,
    this.initialSpot = 'Gedung GFS',
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late String _currentSelectedSpot;

  final List<Map<String, String>> _popularSpots = [
    {
      'name': 'Gedung GFS',
      'desc': 'Depan lobby utama • Tersedia ruang tunggu berteduh',
      'distance': '50 m',
    },
    {
      'name': 'Parkiran Gedung Kuliah Bersama (GKB)',
      'desc': 'Parkiran motor sisi timur • Dekat pos satpam',
      'distance': '120 m',
    },
    {
      'name': 'Parkiran GSD Polineks',
      'desc': 'Area lobby serbaguna • Pangkalan ojek aktif',
      'distance': '250 m',
    },
    {
      'name': 'Kantin Perikanan',
      'desc': 'Samping stand jus • Area tunggu mahasiswa',
      'distance': '400 m',
    },
    {
      'name': 'Gerbang Samping',
      'desc': 'Pintu akses kos mahasiswa sisi barat',
      'distance': '350 m',
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentSelectedSpot = widget.initialSpot;
  }

  void _showAllSpotsSheet() {
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
              const Text(
                'Pilih Lokasi Kampus Lainnya',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: RideService.campusSpots.length,
                  itemBuilder: (context, index) {
                    final spot = RideService.campusSpots[index];
                    final isSel = spot.name == _currentSelectedSpot;
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.location_on_rounded,
                          color: isSel ? const Color(0xFF0284C7) : const Color(0xFF94A3B8),
                        ),
                        title: Text(
                          spot.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                            color: isSel ? const Color(0xFF0284C7) : const Color(0xFF0F172A),
                          ),
                        ),
                        subtitle: Text(
                          spot.description,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                        trailing: isSel
                            ? const Icon(Icons.check_circle_rounded, color: Color(0xFF0284C7), size: 20)
                            : null,
                        onTap: () {
                          setState(() {
                            _currentSelectedSpot = spot.name;
                          });
                          Navigator.pop(context);
                        },
                      ),
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

  @override
  Widget build(BuildContext context) {
    final currentSpotData = _popularSpots.firstWhere(
      (s) => s['name'] == _currentSelectedSpot,
      orElse: () => {
        'name': _currentSelectedSpot,
        'desc': 'Area lingkungan kampus Polineks',
        'distance': '100 m',
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, _currentSelectedSpot),
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
        ),
        title: const Text(
          'Pilih Titik Jemput',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pilih titik jemput yang memiliki pangkalan ojek kampus atau shelter.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.help_outline_rounded, color: Color(0xFF64748B)),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map View occupying top portion
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.44,
            child: CampusMapPlaceholder(
              height: MediaQuery.of(context).size.height * 0.44,
              selectedLocation: _currentSelectedSpot,
              showDriver: true,
              showTrafficOverlay: true,
              badgeText: '35 Driver Siaga di Kampus',
              subLabel: 'Zona Rawan Macet Polineks',
            ),
          ),

          // Bottom Sheet Card (Matching Figma Screen 9)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.42,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Selected Spot Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: Color(0xFF16A34A),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentSpotData['name']!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                currentSpotData['desc']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: _showAllSpotsSheet,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: Size.zero,
                          ),
                          child: const Text(
                            'Ganti',
                            style: TextStyle(
                              color: Color(0xFF0284C7),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section: Pangkalan Populer
                  const Text(
                    'Pangkalan populer',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Popular Spots List
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: _popularSpots.length > 3 ? 3 : _popularSpots.length,
                      separatorBuilder: (context, index) => const Divider(height: 12, color: Color(0xFFF1F5F9)),
                      itemBuilder: (context, index) {
                        final spot = _popularSpots[index];
                        final isSelected = spot['name'] == _currentSelectedSpot;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _currentSelectedSpot = spot['name']!;
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFFE0F2FE) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.place_outlined,
                                    size: 18,
                                    color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        spot['name']!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                          color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF1E293B),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Jarak: ${spot['distance']}',
                                        style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle_rounded, color: Color(0xFF0284C7), size: 18),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Confirmation Button
                  CustomButton(
                    text: 'Konfirmasi Titik Jemput',
                    icon: Icons.check_circle_outline_rounded,
                    backgroundColor: const Color(0xFF0284C7),
                    onPressed: () {
                      Navigator.pop(context, _currentSelectedSpot);
                    },
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
