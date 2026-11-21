import 'package:flutter/material.dart';

class RatingDialog extends StatefulWidget {
  final String driverName;
  final void Function(double rating, String review) onSubmit;

  const RatingDialog({
    super.key,
    required this.driverName,
    required this.onSubmit,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 5.0;
  final TextEditingController _commentController = TextEditingController();
  final Set<String> _selectedBadges = {'Tepat Waktu', 'Ramah'};

  final List<String> _quickBadges = [
    'Tepat Waktu',
    'Ramah',
    'Berkendara Aman',
    'Motor Bersih',
    'Hafal Rute Kampus',
    'Sopan',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.star_rounded,
                  color: Color(0xFFD97706),
                  size: 38,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Perjalanan Selesai!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Bagaimana pengalaman perjalanan Anda bersama ${widget.driverName}?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),

            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starNum = index + 1;
                return IconButton(
                  iconSize: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  icon: Icon(
                    starNum <= _rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: starNum <= _rating
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFFCBD5E1),
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = starNum.toDouble();
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),

            // Quick Badges
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _quickBadges.map((badge) {
                final isSelected = _selectedBadges.contains(badge);
                return FilterChip(
                  label: Text(badge),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedBadges.add(badge);
                      } else {
                        _selectedBadges.remove(badge);
                      }
                    });
                  },
                  selectedColor: const Color(0xFFE0F2FE),
                  checkmarkColor: const Color(0xFF0284C7),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? const Color(0xFF0284C7)
                        : const Color(0xFF475569),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF0284C7)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Comment Field
            TextField(
              controller: _commentController,
              maxLines: 3,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Tulis ulasan tambahan untuk driver (opsional)...',
                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF0284C7), width: 1.5),
                ),
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Lewati'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final review = _commentController.text.trim().isNotEmpty
                          ? _commentController.text.trim()
                          : _selectedBadges.join(', ');
                      widget.onSubmit(_rating, review);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Kirim Penilaian'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
