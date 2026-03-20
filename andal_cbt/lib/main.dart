import 'package:andal_cbt/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Window Manager
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(double.maxFinite, double.maxFinite),
    center: true,
    fullScreen: true, // <--- Logic for Full Screen
    skipTaskbar: false,
    // titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    // await windowManager.setFullScreen(true);
  });

  runApp(const CbtApp());
}

// ==========================================
// 1. App Configuration & Theme
// ==========================================

class CbtApp extends StatelessWidget {
  const CbtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material 3 CBT System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'GoogleSans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A4C31), // Professional Indigo/Blue
          brightness: Brightness.light,
        ),
        // Customizing Card Theme for M3
        cardTheme: const CardThemeData(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
