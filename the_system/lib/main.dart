import 'package:flutter/material.dart';

import 'screens/today_screen.dart';
import 'theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The System',
      debugShowCheckedModeBanner: false, // the red banner breaks the HUD look
      theme: AppTheme.dark,
      home: const TodayScreen(),
    );
  }
}
