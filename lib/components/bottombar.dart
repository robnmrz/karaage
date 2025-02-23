import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const GlassBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // Blur effect
        child: Container(
          color: Colors.black.withValues(alpha: 0.4), // Glass effect background
          padding: EdgeInsets.only(top: 10), // Add padding
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent, // Transparent background
            elevation: 0, // Remove shadow
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withValues(alpha: 0.7),
            currentIndex: selectedIndex,
            onTap: onItemTapped,
            iconSize: 20,
            type: BottomNavigationBarType.fixed, // Ensures no shifting animation
            enableFeedback: false, // Disables the tap animation effect
            selectedFontSize: 10, // Prevents font from animating
            unselectedFontSize: 10, // Keeps it consistent
            items: [
              BottomNavigationBarItem(icon: _noTapEffectIcon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Icons.find_in_page_outlined), label: 'Details'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Panels'),
            ],
          ),
        ),
      ),
    );
  }

  // Wraps icons in a GestureDetector to disable tap animation
  Widget _noTapEffectIcon(IconData icon) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Prevents tap animation
      child: Icon(icon),
    );
  }

}
