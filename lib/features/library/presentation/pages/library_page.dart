import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: AppBar(
        backgroundColor: AppPallete.surfaceContainerLowest,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Library',
          style: AppTypography.headlineMd.copyWith(
            color: AppPallete.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Library Section',
          style: AppTypography.bodyLg.copyWith(
            color: AppPallete.textSecondary,
          ),
        ),
      ),
    );
  }
}
