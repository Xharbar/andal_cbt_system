import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:quiz_creator/screens/login_screen.dart';
import 'package:quiz_creator/themes/light_theme.dart';
import 'package:quiz_creator/themes/dark_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowTitle("Andal CBT Teacher Portal");
  setWindowMinSize(const Size(800, 600));

  await Supabase.initialize(
    url: "https://ggglwxifkkvoqmtddbxh.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdnZ2x3eGlma2t2b3FtdGRkYnhoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM0NTQ4OTQsImV4cCI6MjA4OTAzMDg5NH0.tOX_3ih8-tozu2gqVUOdKMfaYCTo8LQXIIo6c_sG5kI",
  );

  runApp(const TeacherApp());
}

class TeacherApp extends StatefulWidget {
  const TeacherApp({super.key});

  @override
  State<TeacherApp> createState() => _TeacherAppState();
}

class _TeacherAppState extends State<TeacherApp> {
  // Global state logic can go here (e.g., ThemeMode, Authentication status)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Andal Teacher Portal',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),

      themeMode: ThemeMode.system,
      home: const TeacherLoginScreen(),
    );
  }
}
