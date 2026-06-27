import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class DashboardErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const DashboardErrorView({
    super.key,
    required this.message,
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
              Icons.error_outline,
              color: AppPallete.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar el dashboard',
              style: AppTypography.labelMd.copyWith(
                color: AppPallete.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTypography.bodySm.copyWith(
                color: AppPallete.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
