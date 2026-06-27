import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
          'Profile',
          style: AppTypography.headlineMd.copyWith(
            color: AppPallete.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Profile Section',
          style: AppTypography.bodyLg.copyWith(
            color: AppPallete.textSecondary,
          ),
        ),
      ),
    );
  }
}
