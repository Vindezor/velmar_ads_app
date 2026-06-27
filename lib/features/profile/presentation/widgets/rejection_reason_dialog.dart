import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class RejectionReasonDialog extends StatelessWidget {
  final String orderNumber;
  final String? adminNotes;

  const RejectionReasonDialog({
    super.key,
    required this.orderNumber,
    this.adminNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.borderLg,
      ),
      clipBehavior: Clip.antiAlias,
      backgroundColor: AppPallete.surfaceContainerLowest,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          border: Border.all(color: AppPallete.outlineVariant),
          borderRadius: AppRadius.borderLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              color: AppPallete.surface,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerPadding,
                vertical: AppSpacing.gutter,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppPallete.outlineVariant),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.error,
                        color: AppPallete.error,
                        size: 24,
                      ),
                      const SizedBox(width: AppSpacing.base),
                      Text(
                        'Motivo de Rechazo',
                        style: AppTypography.headlineMd.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppPallete.onSurface,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppPallete.onSurfaceVariant),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(AppSpacing.containerPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SOLICITUD ASOCIADA',
                    style: AppTypography.labelSm.copyWith(
                      color: AppPallete.secondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackSm),
                  Text(
                    orderNumber,
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppPallete.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.gutter),
                    decoration: BoxDecoration(
                      color: AppPallete.errorContainer.withValues(alpha: 0.2),
                      border: Border.all(
                        color: AppPallete.errorContainer.withValues(alpha: 0.5),
                      ),
                      borderRadius: AppRadius.borderDefault,
                    ),
                    child: Text(
                      adminNotes ?? 'No se especificó un motivo para el rechazo de esta solicitud.',
                      style: AppTypography.bodySm.copyWith(
                        color: AppPallete.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Footer
            Container(
              color: AppPallete.surface,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerPadding,
                vertical: AppSpacing.gutter,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppPallete.outlineVariant),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppPallete.primary,
                      side: const BorderSide(color: AppPallete.primaryContainer),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.containerPadding,
                        vertical: AppSpacing.gutter,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.borderMd,
                      ),
                    ),
                    child: Text(
                      'Cerrar',
                      style: AppTypography.labelMd.copyWith(
                        color: AppPallete.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.gutter),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contactando a tu ejecutivo de cuenta...'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.primaryContainer,
                      foregroundColor: AppPallete.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.containerPadding,
                        vertical: AppSpacing.gutter,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadius.borderMd,
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Contactar Ejecutivo',
                      style: AppTypography.labelMd.copyWith(
                        color: AppPallete.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
