import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCloseButton extends StatelessWidget {
  final double size; // Size of the circular button
  final double iconSize; // Size of the "X" icon

  const GlassCloseButton({super.key, this.size = 35, this.iconSize = 18});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 50, // Adjust for status bar height
          right: 25,
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: size, // Set circular button size
                height: size, // Set circular button size
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    onPressed: () {
                      Navigator.pop(context, true); // Go back and reload list
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
