import 'package:flutter/material.dart';
import 'package:karaage/db/app_database.dart';
import 'package:karaage/layout.dart';
import 'package:karaage/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.database;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Karaage Manga App',
      theme: KaraageThemeData.defaultTheme,
      home: RootScreen(),
    );
  }
}
