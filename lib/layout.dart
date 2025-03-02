import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:karaage/screens/homepage.dart';
import 'package:karaage/components/bottom_bar.dart';
import 'package:karaage/screens/search.dart';
import 'package:karaage/screens/profile.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  // Define a GlobalKey for HomePage's State
  final GlobalKey<HomeScreenState> _homePageKey = GlobalKey<HomeScreenState>();

  // Pages List
  List<Widget> _pages = [HomeScreen(), SearchScreen(), ProfileScreen()];

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(key: _homePageKey), // Assign the key here
      SearchScreen(),
      ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        _homePageKey.currentState
            ?.reloadMangas(); // Access the state method safely
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/karaage_app_bg.jpg', // Same background as HomePage
            fit: BoxFit.cover,
          ),
        ),

        /// Apply blur effect over the background
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
            child: Container(
              color: Colors.black.withValues(
                alpha: 0.5,
              ), // Adjust opacity if needed
            ),
          ),
        ),

        /// Main content with blur effect
        Scaffold(
          backgroundColor:
              Colors.transparent, // Make Scaffold background transparent
          extendBody: true,
          body: IndexedStack(index: _selectedIndex, children: _pages),
          bottomNavigationBar: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: GlassBottomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ),
        ),
      ],
    );
  }
}
