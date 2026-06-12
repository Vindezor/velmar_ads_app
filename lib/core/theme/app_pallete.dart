import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppPallete {
  // Brand & Canvas Colors
  static const Color surface = Color(0xFFFCF9F8);
  static const Color surfaceDim = Color(0xFFDCD9D9);
  static const Color surfaceBright = Color(0xFFFCF9F8);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF6F3F2);
  static const Color surfaceContainer = Color(0xFFF0EDED);
  static const Color surfaceContainerHigh = Color(0xFFEAE7E7);
  static const Color surfaceContainerHighest = Color(0xFFE5E2E1);
  static const Color onSurface = Color(0xFF1C1B1B);
  static const Color onSurfaceVariant = Color(0xFF434653);
  static const Color inverseSurface = Color(0xFF313030);
  static const Color inverseOnSurface = Color(0xFFF3F0EF);
  static const Color outline = Color(0xFF737784);
  static const Color outlineVariant = Color(0xFFC3C6D5);
  static const Color surfaceTint = Color(0xFF2559BD);

  // Primary (Cobalt Blue is #0047AB, deep primary is #00327D)
  static const Color primary = Color(0xFF00327D);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF0047AB);
  static const Color onPrimaryContainer = Color(0xFFA5BDFF);
  static const Color inversePrimary = Color(0xFFB1C5FF);

  // Secondary (Neutral Gray)
  static const Color secondary = Color(0xFF5E5E5E);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE4E2E2);
  static const Color onSecondaryContainer = Color(0xFF646464);

  // Tertiary (Deep Orange/Brown)
  static const Color tertiary = Color(0xFF651F00);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF8B2E01);
  static const Color onTertiaryContainer = Color(0xFFFFAA8A);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Fixed Colors
  static const Color primaryFixed = Color(0xFFDAE2FF);
  static const Color primaryFixedDim = Color(0xFFB1C5FF);
  static const Color onPrimaryFixed = Color(0xFF001946);
  static const Color onPrimaryFixedVariant = Color(0xFF00419E);

  static const Color secondaryFixed = Color(0xFFE4E2E2);
  static const Color secondaryFixedDim = Color(0xFFC8C6C6);
  static const Color onSecondaryFixed = Color(0xFF1B1C1C);
  static const Color onSecondaryFixedVariant = Color(0xFF464747);

  static const Color tertiaryFixed = Color(0xFFFFDBCF);
  static const Color tertiaryFixedDim = Color(0xFFFFB59A);
  static const Color onTertiaryFixed = Color(0xFF380D00);
  static const Color onTertiaryFixedVariant = Color(0xFF802900);

  // Context Colors
  static const Color background = Color(0xFFFCF9F8);
  static const Color onBackground = Color(0xFF1C1B1B);
  static const Color surfaceVariant = Color(0xFFE5E2E1);

  // Backwards compatibility mappings for older components
  static const Color primaryBlue = primaryContainer; // Cobalt blue #0047AB
  static const Color accentOrange =
      tertiaryContainer; // Custom accent mapping (#8B2E01)
  static const Color backgroundColor = background;
  static const Color cardColor = surfaceContainerLowest; // #FFFFFF
  static const Color textPrimary = Color(0xFF1A1A1A); // Graphite
  static const Color textSecondary = Color(0xFF555555); // Ash Gray
  static const Color textOnPrimary = onPrimary;
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = error;
  static const Color warningColor = Color(0xFFFFC107);
  static const Color borderColor = Color(0xFFE5E5E5); // Ghost Borders #E5E5E5
  static const Color dividerColor = Color(0xFFE5E5E5);
  static const Color disabledColor = secondaryFixedDim; // #C8C6C6
  static const Color transparentColor = Colors.transparent;

  // Design System Gradients
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryContainer],
  );

  static const Gradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [tertiary, tertiaryContainer],
  );

  static const Gradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surfaceContainerLowest, surfaceContainerLow],
  );
}

class AppTypography {
  static TextStyle get displayLg => GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.w600, // SemiBold
    height: 56 / 48,
    letterSpacing: -0.02 * 48,
    color: AppPallete.textPrimary,
  );

  static TextStyle get headlineLg => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w600, // SemiBold
    height: 40 / 32,
    letterSpacing: -0.01 * 32,
    color: AppPallete.textPrimary,
  );

  static TextStyle get headlineLgMobile => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600, // SemiBold
    height: 32 / 24,
    color: AppPallete.textPrimary,
  );

  static TextStyle get headlineMd => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w500, // Medium
    height: 32 / 24,
    color: AppPallete.textPrimary,
  );

  static TextStyle get titleMd => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    height: 24 / 16,
    color: AppPallete.onSurfaceVariant,
  );

  static TextStyle get bodyLg => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400, // Regular
    height: 28 / 18,
    color: AppPallete.textPrimary,
  );

  static TextStyle get bodyMd => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    height: 24 / 16,
    color: AppPallete.textPrimary,
  );

  static TextStyle get bodySm => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w300, // Light (300) for brand voice
    height: 20 / 14,
    color: AppPallete.textSecondary,
  );

  static TextStyle get labelMd => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    height: 16 / 14,
    letterSpacing: 0.05 * 14,
    color: AppPallete.textPrimary,
  );

  static TextStyle get labelSm => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600, // SemiBold
    height: 14 / 12,
    color: AppPallete.textSecondary,
  );
}

class AppRadius {
  static const double sm = 4.0; // 0.25rem
  static const double defaultValue = 8.0; // 0.5rem (DEFAULT)
  static const double md = 12.0; // 0.75rem (Buttons & Input Fields)
  static const double lg = 16.0; // 1rem (Cards & large containers)
  static const double xl = 24.0; // 1.5rem
  static const double full = 9999.0; // full pill

  static const BorderRadius borderSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderDefault = BorderRadius.all(
    Radius.circular(defaultValue),
  );
  static const BorderRadius borderMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius borderFull = BorderRadius.all(
    Radius.circular(full),
  );
}

class AppSpacing {
  static const double base = 8.0;
  static const double containerPadding = 24.0;
  static const double gutter = 16.0;
  static const double stackSm = 4.0;
  static const double stackMd = 12.0;
  static const double stackLg = 24.0;
  static const double maxWidth = 1440.0;
}
