import 'package:flutter/material.dart';

ThemeData darkTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff81287b), // Same brand color
      brightness: Brightness.dark, // Crucial: Sets dark mode palette
    ),
    fontFamily: 'GoogleSans',
    // Match shapes from light theme, but colors auto-adjust
    cardTheme: CardThemeData(
      elevation: 4,
      shadowColor: Colors.white30,
      color: Color(0xff1a1a1a),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    scaffoldBackgroundColor: Colors.black12,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[900], // Darker background for inputs
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
        ),
      ),
    ),
    dataTableTheme: DataTableThemeData(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      headingRowColor: WidgetStatePropertyAll(Color(0xff81287b).withAlpha(130)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xff201a1e),
      contentTextStyle: TextStyle(
        fontFamily: 'GoogleSans',
        color: Colors.white,
      ),
      dismissDirection: DismissDirection.horizontal,
      showCloseIcon: true,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Color(0xff201a1e),
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontFamily: 'GoogleSans',
      ),
    ),
  );
}
