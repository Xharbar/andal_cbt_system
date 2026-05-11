import 'package:flutter/material.dart';

import 'package:cbt_admin_section/screens/admin_login.dart';
import 'package:cbt_admin_section/themes/light_theme.dart';
import 'package:cbt_admin_section/themes/dark_theme.dart';
import 'package:window_manager/window_manager.dart';
// import 'package:cbt_admin_section/screens/admin_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the window manager
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: "Andal CBT Admin Portal",
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.maximize(); // This makes it start maximized
    await windowManager.show();
    await windowManager.focus();
  });

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
