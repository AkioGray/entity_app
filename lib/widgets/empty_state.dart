import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'animated_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryCyan = isDark ? const Color(0xFF00E5FF) : const Color(0xFF06B6D4);
    final Color primaryPurple = isDark ? const Color(0xFFAB55F7) : const Color(0xFF9333EA);
    final Color textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final Color textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: primaryCyan.withValues(alpha: 0.15), blurRadius: 40, spreadRadius: 10),
                      BoxShadow(color: primaryPurple.withValues(alpha: 0.1), blurRadius: 40, spreadRadius: -10),
                    ],
                  ),
                ),
                Icon(icon, size: 64, color: primaryCyan),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(color: textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: textSecondary, fontSize: 14, height: 1.5),
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                child: AnimatedEntityButton(
                  text: buttonText!,
                  colors: [primaryCyan, primaryPurple],
                  onPressed: onButtonPressed!,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}