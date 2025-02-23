import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mango/components/bottombar.dart';
import 'package:mango/details.dart';
import 'package:mango/panels.dart';
import 'package:mango/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Pages List
  final List<Widget> _pages = [
    HomePage(),
    MangasSearchResult(),
    MangaDetailsPage(mangaId: "bjKg6rj5rh539Wfey"),
    MangaPanelsPage(title: "Some Chapter", mangaId: "bjKg6rj5rh539Wfey", chapterString: "1"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Background image covering the whole screen including bottom bar area
        Positioned.fill(
          child: Image.asset(
            'assets/images/mangoBg.jpg',
            fit: BoxFit.cover, // Ensures full coverage
          ),
        ),

        /// Main content with blur effect
        Scaffold(
          backgroundColor: Colors.transparent, // Make Scaffold background transparent
          extendBody: true,
          body: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
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


// Home Page Widget
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/mangoBg.jpg',
          fit: BoxFit.fitHeight,
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
            child: Container(
              color: Colors.black.withValues(alpha: 0.5), // Adjust opacity as needed
            ),
          ),
        ), 

        Center(
          child: Text(
            'Welcome to Mango!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        )
      ]
    );
  }
}
