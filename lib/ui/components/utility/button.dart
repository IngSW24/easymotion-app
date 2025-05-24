import 'package:flutter/material.dart';
import '../../Theme/Theme.dart';

class Button extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color background;
  final Color foreground;
  final double borderRadius;
  final double minHeight;

  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.background = Colors.white,
    this.foreground = Colors.black,
    this.borderRadius = 24,
    this.minHeight = 42,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        padding: const EdgeInsets.symmetric(vertical: 12),
        minimumSize: Size.fromHeight(minHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: DesignTokens.primaryBlue, width: 3),
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}