import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cbt_admin_section/screens/admin_login.dart';
import 'package:cbt_admin_section/themes/light_theme.dart';
import 'package:cbt_admin_section/themes/dark_theme.dart';

// import 'package:cbt_admin_section/screens/admin_home.dart';

Future<void> main() async {
  // void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://ggglwxifkkvoqmtddbxh.supabase.co',
    publishableKey: 'sb_publishable_xXPq8pZhPffycb1Uem0A9A_z7bSasV7',
  );

  // Initialize the window manager
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    center: true,
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
