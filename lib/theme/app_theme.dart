import 'package:flutter/material.dart';
import 'package:shop/theme/button_theme.dart';
import 'package:shop/theme/input_decoration_theme.dart';
import 'package:shop/theme/checkbox_themedata.dart';
import 'package:shop/theme/theme_data.dart';
import '../constants.dart';

class AppTheme {
  static get outlinedButtonThemeData => null;

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      // ---- Couleurs de base ----
      primaryColor: primaryColor, // #1F31F9
      primarySwatch: primaryMaterialColor, // Palette Material générée
      scaffoldBackgroundColor: whiteColor, // #FFFFFF
      brightness: Brightness.light,

      // ---- Typographie ----
      fontFamily: grandisExtendedFont,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: blackColor),
        bodyMedium:
            TextStyle(fontSize: 14, color: blackColor), // Texte principal
        titleMedium:
            TextStyle(fontSize: 16, color: blackColor80), // Sous-titres
        labelSmall: TextStyle(fontSize: 12, color: blackColor60), // Labels
      ),

      // ---- Composants ----
      appBarTheme: appBarLightTheme, // Défini dans constants.dart
      checkboxTheme:
          checkboxThemeData, // Configuré dans checkbox_themedata.dart
      elevatedButtonTheme:
          elevatedButtonThemeData, // Défini dans button_theme.dart
      textButtonTheme: textButtonThemeData,
      outlinedButtonTheme: outlinedButtonThemeData,
      inputDecorationTheme:
          lightInputDecorationTheme, // Défini dans input_decoration_theme.dart
      scrollbarTheme: scrollbarThemeData, // Défini dans constants.dart
      dataTableTheme: dataTableLightThemeData, // Défini dans constants.dart

      // ---- Effets visuels ----
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadious),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: blackColor, // #D0D0D2
        thickness: 1,
        space: 24,
      ),
    );
  }

  // ---- Dark Theme (exemple basique) ----
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkGreyColor, // #1C1C25
      brightness: Brightness.dark,
      appBarTheme: appBarDarkTheme,
      // ... autres configurations sombres
    );
  }
}
