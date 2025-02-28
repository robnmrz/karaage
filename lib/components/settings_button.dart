import 'dart:ui';
import 'package:flutter/material.dart';

class GlassSettingsButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isHorizontalScroll;

  const GlassSettingsButton({
    super.key,
    required this.onPressed,
    required this.isHorizontalScroll,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      right: 70,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: IconButton(
                icon: Icon(
                  isHorizontalScroll
                      ? Icons.swap_horiz_rounded
                      : Icons.swap_vert_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: onPressed,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
