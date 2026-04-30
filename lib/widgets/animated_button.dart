import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedEntityButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final List<Color> colors;
  final bool isOutlined;

  const AnimatedEntityButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.colors,
    this.isOutlined = false,
  });

  @override
  State<AnimatedEntityButton> createState() => _AnimatedEntityButtonState();
}

class _AnimatedEntityButtonState extends State<AnimatedEntityButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: isDisabled ? null : (_) {
        setState(() => _isPressed = false);
        widget.onPressed!();
      },
      onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: widget.isOutlined
                  ? null
                  : LinearGradient(colors: widget.colors, begin: Alignment.centerLeft, end: Alignment.centerRight),
              border: widget.isOutlined
                  ? Border.all(color: widget.colors.last.withValues(alpha: 0.5), width: 2)
                  : null,
              boxShadow: widget.isOutlined || _isPressed || isDisabled
                  ? []
                  : [BoxShadow(color: widget.colors.last.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            alignment: Alignment.center,
            child: Text(
              widget.text.toUpperCase(),
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                color: widget.isOutlined ? widget.colors.last : (widget.colors.contains(Colors.white) ? const Color(0xFF0F172A) : Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}