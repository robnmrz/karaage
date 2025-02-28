import 'package:flutter/material.dart';
import 'package:mango/collection.dart';
import 'package:mango/components/bottombar.dart';
// import 'package:mango/details.dart';
// import 'package:mango/panels.dart';
import 'package:mango/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Define a GlobalKey for HomePage's State
  final GlobalKey<HomePageState> _homePageKey = GlobalKey<HomePageState>();

  // Pages List
  List<Widget> _pages = [HomePage(), MangasSearchResult()];

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(key: _homePageKey), // Assign the key here
      MangasSearchResult(),
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
        /// Background image covering the whole screen including bottom bar area
        Positioned.fill(
          child: Image.asset(
            'assets/images/mangoBg.jpg',
            fit: BoxFit.cover, // Ensures full coverage
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
