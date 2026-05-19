import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CORES FIXAS (iguais nos dois temas)
// ─────────────────────────────────────────────────────────────────────────────
const kPurple      = Color(0xFF6A1FBF); // roxo principal
const kPurpleLight = Color(0xFF9C4DCC); // roxo mais claro
const kGreen       = Colors.green;

// ─────────────────────────────────────────────────────────────────────────────
// TEMA ESCURO
// ─────────────────────────────────────────────────────────────────────────────
final temaEscuro = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  primaryColor: kPurple,

  colorScheme: const ColorScheme.dark(
    primary:   kPurple,
    secondary: kPurpleLight,
    surface:   Color(0xFF1C1C1C), // cards / containers
    onSurface: Colors.white,
    onPrimary: Colors.white,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),

  cardColor: Color(0xFF1C1C1C),

  textTheme: const TextTheme(
    bodyLarge:  TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    bodySmall:  TextStyle(color: Colors.white54),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF2A2A2A),
    hintStyle: TextStyle(color: Colors.white38),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide.none,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: kPurple,
  ),
);


final temaClaro = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  primaryColor: kPurple,

  colorScheme: const ColorScheme.light(
    primary:   kPurple,
    secondary: kPurpleLight,
    surface:   Colors.white,       // cards / containers
    onSurface: Color(0xFF1A1A1A),  // texto sobre cards
    onPrimary: Colors.white,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF5F5F5),
    foregroundColor: Color(0xFF1A1A1A),
    elevation: 0,
    centerTitle: true,
  ),

  cardColor: Colors.white,

  textTheme: const TextTheme(
    bodyLarge:  TextStyle(color: Color(0xFF1A1A1A)),
    bodyMedium: TextStyle(color: Color(0xFF555555)),
    bodySmall:  TextStyle(color: Color(0xFF888888)),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    hintStyle: TextStyle(color: Colors.black38),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(color: Color(0xFFDDDDDD)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(color: Color(0xFFDDDDDD)),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPurple,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: kPurple,
  ),
);