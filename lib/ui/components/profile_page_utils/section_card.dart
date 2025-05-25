import 'package:flutter/material.dart';
import '../utility/button.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.children,
    required this.backgroundColor,
    required this.foregroundTextColor,
    required this.editButtonColor,
    this.onEdit,
  });

  final String        title;
  final IconData      icon;
  final Color         iconColor;
  final List<Widget>  children;
  final Color         backgroundColor;
  final Color         foregroundTextColor;
  final Color         editButtonColor;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: foregroundTextColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: foregroundTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
            if (onEdit != null) ...[
              const SizedBox(height: 24),
              Button(
                label          : 'Modifica',
                onPressed      : onEdit!,
                background     : editButtonColor,
                foreground     : Colors.black,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
