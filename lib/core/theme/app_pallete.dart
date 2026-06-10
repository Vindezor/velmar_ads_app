import 'package:flutter/material.dart';

class AppPallete {
  // Colores principales
  static const Color primaryBlue = Color.fromRGBO(42, 94, 229, 1); // #2A5EE5
  static const Color accentOrange = Color.fromRGBO(255, 167, 38, 1); // #FFA726

  // Colores de fondo
  static const Color backgroundColor = Color.fromRGBO(
    245,
    247,
    251,
    1,
  ); // #F5F7FB
  static const Color cardColor = Colors.white;

  // Colores de texto
  static const Color textPrimary = Color.fromRGBO(51, 51, 51, 1); // #333333
  static const Color textSecondary = Color.fromRGBO(
    102,
    102,
    102,
    1,
  ); // #666666
  static const Color textOnPrimary = Colors.white;

  // Colores de estado
  static const Color successColor = Color.fromRGBO(76, 175, 80, 1); // #4CAF50
  static const Color errorColor = Color.fromRGBO(229, 57, 53, 1); // #E53935
  static const Color warningColor = Color.fromRGBO(255, 193, 7, 1); // #FFC107

  // Colores adicionales
  static const Color borderColor = Color.fromRGBO(224, 224, 224, 1); // #E0E0E0
  static const Color dividerColor = Color.fromRGBO(238, 238, 238, 1);
  static const Color disabledColor = Color.fromRGBO(189, 189, 189, 1);
  static const Color transparentColor = Colors.transparent;

  // Gradientes
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, Color.fromRGBO(66, 133, 244, 1)],
  );

  static const Gradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentOrange, Color.fromRGBO(255, 152, 0, 1)],
  );

  static const Gradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white, Color.fromRGBO(245, 247, 251, 1)],
  );
}
