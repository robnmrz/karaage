import 'dart:ui';
import 'package:flutter/material.dart';

/// Glass Effect Floating Bottom Bar with Vertical Dividers
class FloatingBottomBar extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onForwardPressed;
  final VoidCallback onSearchPressed;
  final String chapterString;
  final bool isBackDisabled;
  final bool isForwardDisabled;

  const FloatingBottomBar({
    super.key,
    required this.onBackPressed,
    required this.onForwardPressed,
    required this.onSearchPressed,
    required this.chapterString,
    required this.isBackDisabled,
    required this.isForwardDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Glass effect
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black.withValues(
              alpha: 0.3,
            ), // Semi-transparent background
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
            ), // Light border
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconButton(
                icon: Icons.arrow_back,
                onPressed: isBackDisabled ? null : onBackPressed,
                isDisabled: isBackDisabled,
              ),
              _buildDivider(), // Divider between buttons
              Text(
                chapterString,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              _buildDivider(), // Divider between buttons
              _buildIconButton(
                icon: Icons.arrow_forward,
                onPressed: onForwardPressed,
                isDisabled: isForwardDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a single icon button with optional disabled state
  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isDisabled,
  }) {
    return IconButton(
      icon: Icon(icon, color: isDisabled ? Colors.grey : Colors.white),
      onPressed: isDisabled ? null : onPressed,
    );
  }

  /// Builds a vertical divider
  Widget _buildDivider() {
    return Container(
      width: 1.5, // Thin divider
      height: 25, // Half the height of the bar
      color: Colors.white.withValues(alpha: 0.4), // Semi-transparent white
    );
  }
}
