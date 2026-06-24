import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class AppTheme {
  static OutlineInputBorder _border([
    Color color = AppPallete.borderColor,
    double width = 1.0,
  ]) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: width),
    borderRadius: AppRadius.borderMd, // 12px radius for inputs and fields
  );

  static final lightTheme = ThemeData.light().copyWith(
    // General configurations
    scaffoldBackgroundColor: AppPallete.background,
    colorScheme: const ColorScheme.light(
      primary: AppPallete.primary,
      onPrimary: AppPallete.onPrimary,
      primaryContainer: AppPallete.primaryContainer,
      onPrimaryContainer: AppPallete.onPrimaryContainer,
      secondary: AppPallete.secondary,
      onSecondary: AppPallete.onSecondary,
      secondaryContainer: AppPallete.secondaryContainer,
      onSecondaryContainer: AppPallete.onSecondaryContainer,
      tertiary: AppPallete.tertiary,
      onTertiary: AppPallete.onTertiary,
      tertiaryContainer: AppPallete.tertiaryContainer,
      onTertiaryContainer: AppPallete.onTertiaryContainer,
      error: AppPallete.error,
      onError: AppPallete.onError,
      errorContainer: AppPallete.errorContainer,
      onErrorContainer: AppPallete.onErrorContainer,
      surface: AppPallete.surface,
      onSurface: AppPallete.onSurface,
      surfaceContainerHighest: AppPallete.surfaceContainerHighest,
      onSurfaceVariant: AppPallete.onSurfaceVariant,
      outline: AppPallete.outline,
      outlineVariant: AppPallete.outlineVariant,
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppPallete.surfaceContainerLowest, // Pure White #FFFFFF
      elevation: 0, // Swiss minimal look: no border shadows unless necessary
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: AppPallete.textPrimary),
      titleTextStyle: AppTypography.headlineMd.copyWith(
        color: AppPallete.textPrimary,
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.primaryContainer, // Cobalt Blue #0047AB
        foregroundColor: AppPallete.onPrimary,
        minimumSize: const Size.fromHeight(
          48,
        ), // Desktop / Mobile standard height
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderMd, // 12px radius
        ),
        textStyle: AppTypography.labelMd.copyWith(
          color: AppPallete.onPrimary,
          fontWeight: FontWeight.w600, // SemiBold
        ),
        elevation: 0, // Clean flat look
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: AppPallete.primaryContainer,
        side: const BorderSide(color: AppPallete.primaryContainer, width: 1),
        minimumSize: const Size.fromHeight(48),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.borderMd, // 12px radius
        ),
        textStyle: AppTypography.labelMd.copyWith(
          color: AppPallete.primaryContainer,
          fontWeight: FontWeight.w600, // SemiBold
        ),
      ),
    ),

    // Inputs & Form Fields
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: AppPallete.surfaceContainerLowest, // Pure White #FFFFFF
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(
        AppPallete.primaryContainer,
        2.0,
      ), // 2px Cobalt Blue focus
      errorBorder: _border(AppPallete.errorColor, 1.0),
      focusedErrorBorder: _border(AppPallete.errorColor, 2.0),
      labelStyle: AppTypography.labelSm.copyWith(
        color: AppPallete.textSecondary,
      ),
      floatingLabelStyle: AppTypography.labelSm.copyWith(
        color: AppPallete.primaryContainer,
      ),
    ),

    // Cards
    cardTheme: CardTheme(
      color: AppPallete.surfaceContainerLowest, // Pure White #FFFFFF
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.borderLg, // 16px radius
        side: BorderSide(
          color: AppPallete.borderColor,
          width: 1.0,
        ), // 1px #E5E5E5 border
      ),
      shadowColor: const Color(
        0x0D000000,
      ), // Soft ambient shadow 5% opacity (rgba(0, 0, 0, 0.05))
    ).data,

    // Chips
    chipTheme: ChipThemeData(
      backgroundColor: AppPallete.surfaceContainerLow,
      selectedColor: AppPallete.primaryContainer,
      labelStyle: AppTypography.bodySm.copyWith(color: AppPallete.textPrimary),
      secondaryLabelStyle: AppTypography.bodySm.copyWith(
        color: AppPallete.onPrimary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.borderDefault, // 8px radius
        side: BorderSide(color: AppPallete.borderColor),
      ),
    ),

    // Text / Typography
    textTheme: TextTheme(
      displayLarge: AppTypography.displayLg,
      displayMedium: AppTypography.headlineLg,
      displaySmall: AppTypography.headlineLgMobile,
      headlineLarge: AppTypography.headlineLg,
      headlineMedium: AppTypography.headlineMd,
      headlineSmall:
          AppTypography.headlineMd, // Map to headlineMd for general header UI
      bodyLarge: AppTypography.bodyLg,
      bodyMedium: AppTypography.bodyMd,
      bodySmall: AppTypography.bodySm,
      labelLarge: AppTypography.labelMd,
      labelMedium: AppTypography.labelSm,
      labelSmall: AppTypography.labelSm,
      titleMedium: AppTypography.titleMd,
    ),

    // Icons
    iconTheme: const IconThemeData(color: AppPallete.textSecondary),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppPallete.dividerColor,
      thickness: 1,
      space: 0,
    ),
  );
}
