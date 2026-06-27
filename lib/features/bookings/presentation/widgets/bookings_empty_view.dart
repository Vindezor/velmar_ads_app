import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class BookingsEmptyView extends StatelessWidget {
  const BookingsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: AppPallete.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes reservas',
              style: AppTypography.headlineMd.copyWith(
                color: AppPallete.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aquí aparecerán tus campañas contratadas.',
              style: AppTypography.bodyMd.copyWith(
                color: AppPallete.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
