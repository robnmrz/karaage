// import 'package:flutter/material.dart';
// import 'dart:ui';

// /// Custom Glass-Style Switch
// class GlassSwitch extends StatelessWidget {
//   final bool value;
//   final ValueChanged<bool> onChanged;

//   const GlassSwitch({super.key, required this.value, required this.onChanged});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         // Glass background (Reduced height)
//         ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//             child: Container(
//               width: 44, // Reduced width
//               height: 24, // Reduced height
//               decoration: BoxDecoration(
//                 color: Colors.white.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
//               ),
//             ),
//           ),
//         ),
//         // Scaled-down Switch
//         Transform.scale(
//           scale: 0.8, // Shrinks the Switch
//           child: Switch(
//             value: value,
//             onChanged: onChanged,
//             activeColor: Colors.orange, // Thumb color when active
//             inactiveThumbColor: Colors.white70, // Thumb color when inactive
//             activeTrackColor: Colors.orange.withValues(
//               alpha: 0.3,
//             ), // Glassy track color
//             inactiveTrackColor: Colors.white.withValues(
//               alpha: 0.1,
//             ), // Glassy inactive track
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
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
            child: Image.asset('assets/images/mangoBg.jpg', fit: BoxFit.cover),
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
                // Settings Title
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

                // Settings List
                Expanded(
                  child: ListView(
                    children: [
                      _buildSettingsItem(
                        title: "Show total chapters read",
                        trailing: GlassSwitch(
                          value: _showTotalChaptersRead,
                          onChanged: _toggleShowTotalChaptersRead,
                        ),
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        title: "Enable Notifications",
                        trailing: GlassSwitch(
                          value: true, // Example toggle
                          onChanged: (bool value) {},
                        ),
                      ),
                      _buildDivider(),
                      _buildSettingsItem(
                        title: "Dark Mode",
                        trailing: GlassSwitch(
                          value: false, // Example toggle
                          onChanged: (bool value) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a settings row with a title and a trailing widget (e.g., Switch)
  Widget _buildSettingsItem({required String title, required Widget trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          trailing,
        ],
      ),
    );
  }

  /// Divider with transparency for a subtle effect
  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withValues(alpha: 0.2),
      thickness: 1,
      height: 1,
    );
  }
}

/// Custom Glass-Style Switch
class GlassSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const GlassSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glass background (Reduced height)
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              width: 44, // Reduced width
              height: 24, // Reduced height
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
            ),
          ),
        ),
        // Scaled-down Switch
        Transform.scale(
          scale: 0.8, // Shrinks the Switch
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.orange, // Thumb color when active
            inactiveThumbColor: Colors.white70, // Thumb color when inactive
            activeTrackColor: Colors.orange.withValues(
              alpha: 0.3,
            ), // Glassy track color
            inactiveTrackColor: Colors.white.withValues(
              alpha: 0.1,
            ), // Glassy inactive track
          ),
        ),
      ],
    );
  }
}
