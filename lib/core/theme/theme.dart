import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
    borderSide: BorderSide(
      color: color,
      width: 1.5, // Ancho reducido para mejor estética
    ),
    borderRadius: BorderRadius.circular(12), // Bordes más redondeados
  );

  static final lightTheme = ThemeData.light().copyWith(
    // Configuración general
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: AppPallete.primaryBlue,
      secondary: AppPallete.accentOrange,
      surface: AppPallete.backgroundColor,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: AppPallete.textPrimary),
      titleTextStyle: TextStyle(
        color: AppPallete.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto',
      ),
    ),

    // Botones
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppPallete.primaryBlue),
        foregroundColor: AppPallete.primaryBlue,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16),
      filled: true,
      fillColor: Colors.white,
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.primaryBlue),
      errorBorder: _border(AppPallete.errorColor),
      labelStyle: const TextStyle(color: AppPallete.textSecondary),
      floatingLabelStyle: const TextStyle(color: AppPallete.primaryBlue),
    ),

    // Tarjetas
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppPallete.borderColor, width: 1),
      ),
    ).data,

    // Chips
    chipTheme: ChipThemeData(
      backgroundColor: AppPallete.backgroundColor,
      selectedColor: AppPallete.primaryBlue,
      labelStyle: const TextStyle(color: AppPallete.textPrimary),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppPallete.borderColor),
      ),
    ),

    // Textos
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppPallete.textPrimary,
        fontFamily: 'Roboto',
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppPallete.textPrimary,
        fontFamily: 'Roboto',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppPallete.textPrimary,
        fontFamily: 'Roboto',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppPallete.textSecondary,
        fontFamily: 'Roboto',
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'Roboto',
      ),
    ),

    // Iconos
    iconTheme: const IconThemeData(color: AppPallete.textSecondary),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppPallete.dividerColor,
      thickness: 1,
      space: 0,
    ),
  );
}
