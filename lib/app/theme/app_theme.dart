import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
  listTileTheme: const ListTileThemeData(dense: true),
  fontFamily: 'Inter-Regular',
  scaffoldBackgroundColor: const Color(0xFF2C2C2C),
  cardTheme: CardTheme(
    color: Colors.orange.shade50,
    surfaceTintColor: Colors.white,
    margin: EdgeInsets.zero,
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10)))),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6B00),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(50)))),
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.white,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: 'Inter-Bold',
      color: Colors.white,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    isDense: true,
    filled: true,
    fillColor: const Color(0xFFE8E3E3),
    labelStyle:
        const TextStyle(fontFamily: 'Inter-Bold', color: Colors.black54),
    border: OutlineInputBorder(
        borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15)),
  ),
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF6B00)),
);
