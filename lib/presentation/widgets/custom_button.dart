import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon; // Added icon parameter

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.icon, // Initialized icon
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      // Use the theme's ElevatedButton style and override if not primary
      style: isPrimary
          ? theme.elevatedButtonTheme.style
          : ElevatedButton.styleFrom(
              // For a secondary/logout button, use a different color
              backgroundColor: theme.colorScheme.error, // or theme.disabledColor
              foregroundColor: Colors.white,
              shape: theme.elevatedButtonTheme.style?.shape?.resolve({}) ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: theme.elevatedButtonTheme.style?.padding?.resolve({}),
              textStyle: theme.elevatedButtonTheme.style?.textStyle?.resolve({}),
            ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(text),
        ],
      ),
    );
  }
}