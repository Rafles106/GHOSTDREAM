import 'package:latlong2/latlong.dart';

class PickupPoint {
  final String id;
  final String name;
  final double? lat;
  final double? lng;

  const PickupPoint({
    required this.id,
    required this.name,
    this.lat,
    this.lng,
  });

  LatLng? get latLng {
    if (lat == null || lng == null) return null;
    return LatLng(lat!, lng!);
  }

  PickupPoint copyWith({
    String? id,
    String? name,
    double? lat,
    double? lng,
  }) {
    return PickupPoint(
      id: id ?? this.id,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }
}

const List<PickupPoint> polinelaPickupPoints = [
  PickupPoint(id: '1', name: 'Perpustakaan', lat: -5.358654208250729, lng: 105.23249099007546),
  PickupPoint(id: '2', name: 'Akademik', lat: -5.358636675506418, lng: 105.2329928666672),
  PickupPoint(id: '3', name: 'CB', lat: -5.358233130059224, lng: 105.23299664924609),
  PickupPoint(id: '4', name: 'Al-Bana Baru', lat: -5.357598819124216, lng: 105.23366912999046),
  PickupPoint(id: '5', name: 'KHD', lat: -5.358428474129233, lng: 105.23379630945665),
  PickupPoint(id: '6', name: 'Budidaya Tanaman Pangan', lat: -5.356789627862878, lng: 105.23060878676785),
  PickupPoint(id: '7', name: 'Gedung Nusa Indah', lat: -5.357750773537774, lng: 105.23390869868321),
  PickupPoint(id: '8', name: 'Agro Ecotourism', lat: -5.358127518906818, lng: 105.23512111892738),
  PickupPoint(id: '9', name: 'Perumahan Polinela', lat: null, lng: null),
  PickupPoint(id: '10', name: 'Al-Bana Wanita', lat: -5.357360469825549, lng: 105.23289070983746),
  PickupPoint(id: '11', name: 'Poliklinik', lat: -5.3570652241213175, lng: 105.23310539317575),
  PickupPoint(id: '12', name: 'Gedung HMJ', lat: -5.356776129233694, lng: 105.23323049639687),
  PickupPoint(id: '13', name: 'Gedung Serba Guna', lat: -5.356962195638394, lng: 105.23236095170459),
  PickupPoint(id: '14', name: 'Gedung H', lat: -5.356668487486087, lng: 105.23259880229539),
  PickupPoint(id: '15', name: 'Gedung Sakura', lat: -5.356354788560414, lng: 105.23236404066488),
  PickupPoint(id: '16', name: 'Gedung Seroja', lat: -5.355882702137992, lng: 105.23169682341192),
  PickupPoint(id: '17', name: 'Gedung Analisis', lat: -5.3559657401648915, lng: 105.2321416349131),
  PickupPoint(id: '18', name: 'Gedung Ekbis', lat: null, lng: null),
  PickupPoint(id: '19', name: 'Jurusan Perikanan dan Kelautan', lat: -5.357429802639942, lng: 105.23233194998738),
  PickupPoint(id: '20', name: 'Kantin QB', lat: -5.357717830954302, lng: 105.23204859614731),
  PickupPoint(id: '21', name: 'Gedung Laboratorium Perikanan', lat: -5.357459834441129, lng: 105.23157680324412),
  PickupPoint(id: '22', name: 'Laboratorium Kesehatan dan Lingkungan Perikanan', lat: -5.358310033122837, lng: 105.23186333807833),
  PickupPoint(id: '23', name: 'Gedung MP', lat: -5.357750466735643, lng: 105.23116133693523),
  PickupPoint(id: '24', name: 'Teknologi Perbenihan STEFA', lat: -5.3564134991668615, lng: 105.22947647523213),
  PickupPoint(id: '25', name: 'Pilot Plant Agroindustri dan Energi Terbarukan', lat: -5.356364034102781, lng: 105.22861189254309),
  PickupPoint(id: '26', name: 'Lab TRKI', lat: -5.356045594588586, lng: 105.22865834917448),
  PickupPoint(id: '27', name: 'Lab TRE', lat: -5.355855242397496, lng: 105.22857973025982),
  PickupPoint(id: '28', name: 'GKB', lat: -5.3551398380581565, lng: 105.22852227175832),
  PickupPoint(id: '29', name: 'SFS', lat: -5.354498851947344, lng: 105.22860322810547),
  PickupPoint(id: '30', name: 'Embung Polinela', lat: -5.353985609086531, lng: 105.22942491903913),
  PickupPoint(id: '31', name: 'Pura-Pura Cafe', lat: -5.353626377350992, lng: 105.22913953044448),
  PickupPoint(id: '32', name: 'Polinela Organic Farm (POF)', lat: -5.353002899922743, lng: 105.22877935755795),
  PickupPoint(id: '33', name: 'Penangkar Bibit Sawit', lat: -5.352198038086073, lng: 105.22863594104768),
  PickupPoint(id: '34', name: 'Kantor Gedung Belakang', lat: -5.351123494244851, lng: 105.22770423495236),
  PickupPoint(id: '35', name: 'Polinela Fresh Farm (PFF)', lat: -5.354127127776081, lng: 105.22847926074128),
  PickupPoint(id: '36', name: 'Kantin Belakang / GKB', lat: -5.355604404365692, lng: 105.22857258307111),
  PickupPoint(id: '37', name: 'Polihidro Farm', lat: -5.358151473019345, lng: 105.23415971675195),
  PickupPoint(id: '38', name: 'Lab Perjalanan Wisata', lat: -5.358196717007914, lng: 105.23579296965555),
  PickupPoint(id: '39', name: 'Pati Seri', lat: -5.357809489065584, lng: 105.23445990600241),
  PickupPoint(id: '40', name: 'Foto Copy', lat: -5.357811026802095, lng: 105.23434098070702),
  PickupPoint(id: '41', name: 'UKM BS', lat: -5.357791036227118, lng: 105.2342266888647),
  PickupPoint(id: '42', name: 'Kantin Sudiyo', lat: -5.357781809807682, lng: 105.23411703047545),
  PickupPoint(id: '43', name: 'Gedung Arsip', lat: -5.35672845931923, lng: 105.23301426858707),
  PickupPoint(id: '44', name: 'UKM Smart', lat: -5.356697704533741, lng: 105.23284128633924),
  PickupPoint(id: '45', name: 'UKM Garda / Sukma / BEM', lat: -5.357112894003314, lng: 105.23218024702705),
  PickupPoint(id: '46', name: 'UKM Al-Bana / Kopma', lat: -5.356809959489318, lng: 105.23217561357399),
  PickupPoint(id: '47', name: 'UKM EC / MPM', lat: -5.35681764818443, lng: 105.23205668827859),
  PickupPoint(id: '48', name: 'UKM Poltapala', lat: -5.35713596007691, lng: 105.23203969895067),
  PickupPoint(id: '49', name: 'Gedung PPA', lat: -5.356119514263945, lng: 105.23134931442611),
  PickupPoint(id: '50', name: 'Lahan TPTH', lat: -5.356789627862878, lng: 105.23060878676785),
  PickupPoint(id: '51', name: 'Lahan Pembibitan', lat: -5.356694674114727, lng: 105.23081024388577),
]

List<PickupPoint> searchPolinelaPickupPoints(String query) {
  final trimmed = query.trim().toLowerCase();
  if (trimmed.isEmpty) return polinelaPickupPoints;
  return polinelaPickupPoints
      .where((point) => point.name.toLowerCase().contains(trimmed))
      .toList();
}