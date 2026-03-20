import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      // seedColor: const Color(0xFF00695C), // Professional Teal/Green
      seedColor: const Color(0xff81287B),
      // brightness: Brightness.light,
    ),
    fontFamily: 'GoogleSans',
    cardTheme: CardThemeData(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(fontSize: 14),
      filled: true,
      fillColor: Colors.grey[100],
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
        ),
      ),
    ),
    disabledColor: Colors.grey[600],
    dataTableTheme: DataTableThemeData(
      headingRowColor: WidgetStatePropertyAll(Colors.grey[400]),
    ),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: TextStyle(fontFamily: 'GoogleSans'),
      dismissDirection: DismissDirection.horizontal,
      showCloseIcon: true,
    ),
  );
}