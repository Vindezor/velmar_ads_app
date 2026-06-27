import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class BookingsListErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const BookingsListErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_outlined,
              size: 64,
              color: AppPallete.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar reservas',
              style: AppTypography.headlineMd.copyWith(
                color: AppPallete.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: AppTypography.bodyMd.copyWith(
                color: AppPallete.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPallete.primary,
                foregroundColor: AppPallete.onPrimary,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.borderMd,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
