import 'package:flutter/material.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final bool isDark;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 16.0,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final highlightColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutSine,
      builder: (context, value, child) {
        final opacity = value < 0.75 ? value : 1.5 - value; 
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Color.lerp(baseColor, highlightColor, opacity),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
      },
    );
  }
}