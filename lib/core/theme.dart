import 'package:flutter/material.dart';

// Bright Theme
final ThemeData brightTheme = ThemeData(
  primarySwatch: Colors.indigo,
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,

  // AppBar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black87,
    elevation: 1,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  // Scaffold Background
  scaffoldBackgroundColor: Colors.grey[50],

  // Card Theme
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  ),

  // Button Themes
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.indigo,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.indigo, // background color
      foregroundColor: Colors.white, // text color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      elevation: 3,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.indigo, // text color
      textStyle: const TextStyle(fontSize: 16),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.indigo,
      side: const BorderSide(color: Colors.indigo, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),

  // Input Field Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.indigo[50],
    contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.indigo, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    labelStyle: TextStyle(color: Colors.indigo[700]),
    hintStyle: TextStyle(color: Colors.grey[600]),
  ),

  // Text Themes
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 96, fontWeight: FontWeight.w300, color: Colors.indigo[900]),
    displayMedium: TextStyle(fontSize: 60, fontWeight: FontWeight.w300, color: Colors.indigo[900]),
    displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.w400, color: Colors.indigo[900]),
    headlineMedium: TextStyle(fontSize: 34, fontWeight: FontWeight.w400, color: Colors.indigo[900]),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo[900]),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo[900]),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    bodySmall: TextStyle(fontSize: 12, color: Colors.grey[700]),
    labelSmall: TextStyle(fontSize: 10, color: Colors.grey[600]),
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.indigo,
    unselectedItemColor: Colors.grey[600],
    type: BottomNavigationBarType.fixed, // ensures all items are visible
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
  ),

  // Divider Theme
  dividerTheme: DividerThemeData(
    color: Colors.indigo[100],
    thickness: 1,
    indent: 16,
    endIndent: 16,
  ),

  // Card Color
  cardColor: Colors.white,

  // Icon Theme
  iconTheme: const IconThemeData(
    color: Colors.indigo,
  ),

  // Dialog Theme
  dialogTheme: DialogThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    titleTextStyle: TextStyle(
      color: Colors.indigo[900],
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
  ),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.indigo,
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,

  // AppBar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A237E), // Darker indigo
    foregroundColor: Colors.white,
    elevation: 1,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  // Scaffold Background
  scaffoldBackgroundColor: const Color(0xFF121212), // Very dark grey

  // Card Theme
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    color: const Color(0xFF1E1E1E), // Slightly lighter dark grey for cards
  ),

  // Button Themes
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.indigoAccent,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.indigoAccent, // background color
      foregroundColor: Colors.white, // text color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      elevation: 3,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.indigoAccent, // text color
      textStyle: const TextStyle(fontSize: 16),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.indigoAccent,
      side: const BorderSide(color: Colors.indigoAccent, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),

  // Input Field Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2C2C2C), // Darker grey for input fields
    contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.indigoAccent, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    labelStyle: const TextStyle(color: Colors.white70),
    hintStyle: TextStyle(color: Colors.grey[500]),
  ),

  // Text Themes
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 96, fontWeight: FontWeight.w300, color: Colors.white70),
    displayMedium: TextStyle(fontSize: 60, fontWeight: FontWeight.w300, color: Colors.white70),
    displaySmall: TextStyle(fontSize: 48, fontWeight: FontWeight.w400, color: Colors.white70),
    headlineMedium: TextStyle(fontSize: 34, fontWeight: FontWeight.w400, color: Colors.white70),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
    bodySmall: TextStyle(fontSize: 12, color: Colors.grey[400]),
    labelSmall: TextStyle(fontSize: 10, color: Colors.grey[500]),
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF1E1E1E), // Darker background
    selectedItemColor: Colors.indigoAccent,
    unselectedItemColor: Colors.grey[400],
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
  ),

  // Divider Theme
  dividerTheme: DividerThemeData(
    color: Colors.grey[700],
    thickness: 1,
    indent: 16,
    endIndent: 16,
  ),

  // Card Color (used explicitly by Card widget)
  cardColor: const Color(0xFF1E1E1E),

  // Icon Theme
  iconTheme: const IconThemeData(
    color: Colors.indigoAccent,
  ),

  // Dialog Theme
  dialogTheme: DialogThemeData(
    backgroundColor: const Color(0xFF1E1E1E),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: const TextStyle(
      color: Colors.white70,
      fontSize: 16,
    ),
  ),
);