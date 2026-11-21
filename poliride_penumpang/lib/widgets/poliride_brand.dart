import 'package:flutter/material.dart';

class PolirideBrand extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final bool showBadge;
  final bool isCenter;
  final String badgeText;
  final Color? badgeBgColor;
  final Color? badgeTextColor;

  const PolirideBrand({
    super.key,
    this.iconSize = 32,
    this.fontSize = 22,
    this.showBadge = true,
    this.isCenter = false,
    this.badgeText = 'PENUMPANG',
    this.badgeBgColor,
    this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final rowContent = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // App Name
        RichText(
          text: TextSpan(
            text: 'Poli',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
              letterSpacing: 0.5,
            ),
            children: const [
              TextSpan(
                text: 'RIDE',
                style: TextStyle(
                  color: Color(0xFF0284C7),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        if (showBadge) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: badgeBgColor ?? const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF7DD3FC)),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: badgeTextColor ?? const Color(0xFF0369A1),
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ],
    );

    return isCenter ? Center(child: rowContent) : rowContent;
  }
}

class PolirideBigLogo extends StatelessWidget {
  final double size;

  const PolirideBigLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0284C7).withOpacity(0.3),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.two_wheeler_rounded,
              color: Colors.white,
              size: size * 0.55,
            ),
          ),
        ),
        const SizedBox(height: 14),
        const PolirideBrand(fontSize: 26, isCenter: true, showBadge: true),
        const SizedBox(height: 4),
        const Text(
          'Ojek Kampus Politeknik Negeri Lampung',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
