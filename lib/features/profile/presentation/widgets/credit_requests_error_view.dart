import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class CreditRequestsErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const CreditRequestsErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(AppSpacing.containerPadding),
          decoration: BoxDecoration(
            color: AppPallete.surfaceContainerLowest,
            border: Border.all(color: AppPallete.errorContainer),
            borderRadius: AppRadius.borderLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppPallete.error,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.gutter),
              Text(
                'Error al cargar solicitudes',
                style: AppTypography.bodyLg.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppPallete.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.stackSm),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppPallete.secondary,
                ),
              ),
              const SizedBox(height: AppSpacing.stackLg),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.primaryContainer,
                    foregroundColor: AppPallete.onPrimary,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.borderMd,
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Reintentar',
                    style: AppTypography.labelMd.copyWith(
                      color: AppPallete.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
