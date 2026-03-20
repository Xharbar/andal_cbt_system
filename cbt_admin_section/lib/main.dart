import 'package:flutter/material.dart';

import 'package:cbt_admin_section/screens/admin_login.dart';
import 'package:cbt_admin_section/themes/light_theme.dart';
import 'package:cbt_admin_section/themes/dark_theme.dart';

void main() {
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CBT Admin Portal',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      home: const AdminLoginScreen(),
    );
  }
}
