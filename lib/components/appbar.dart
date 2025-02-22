import 'dart:ui';
import 'package:flutter/material.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  const GlassAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(title!, style: const TextStyle(color: Colors.white))
          : null,
      centerTitle: true,
      elevation: 0, // Remove shadow
      backgroundColor: Colors.transparent, // Transparent AppBar
      leading: leading ??
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      actions: actions,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Glass effect
          child: Container(
            color: Colors.black.withValues(alpha: 0.3), // Semi-transparent background
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
