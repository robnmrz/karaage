import 'package:flutter/material.dart';
import 'package:karaage/theme.dart';

class CustomSearchbar extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const CustomSearchbar({
    super.key,
    required this.hintText,
    required this.icon,
    this.controller,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).extension<KaraageColors>()!;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: themeColors.textTertiary),
        suffixIcon: Icon(icon, color: themeColors.textTertiary),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: themeColors.accent!,
            width: 1.0,
          ), // Border color when focused
        ),
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.3), // Transparent effect
      ),
      style: TextStyle(color: Colors.white, fontSize: 16),
      cursorColor: themeColors.accent,
    );
  }
}
