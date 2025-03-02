import 'package:flutter/material.dart';
import 'package:karaage/components/switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _showTotalChaptersRead = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showTotalChaptersRead = prefs.getBool('showTotalChaptersRead') ?? false;
    });
  }

  Future<void> _toggleShowTotalChaptersRead(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showTotalChaptersRead = value;
    });
    await prefs.setBool('showTotalChaptersRead', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/karaage_app_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Blur Effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Settings".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Show total chapters read",
                      style: TextStyle(color: Colors.white),
                    ),
                    GlassSwitch(
                      value: _showTotalChaptersRead,
                      onChanged: _toggleShowTotalChaptersRead,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> getShowTotalChaptersReadPreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('showTotalChaptersRead') ?? false;
}
