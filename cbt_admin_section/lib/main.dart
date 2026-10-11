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
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdnZ2x3eGlma2t2b3FtdGRkYnhoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM0NTQ4OTQsImV4cCI6MjA4OTAzMDg5NH0.tOX_3ih8-tozu2gqVUOdKMfaYCTo8LQXIIo6c_sG5kI',
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
