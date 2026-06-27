import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class CorrectionWarningBanner extends StatelessWidget {
  const CorrectionWarningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.stackMd),
      decoration: BoxDecoration(
        color: AppPallete.errorContainer,
        borderRadius: AppRadius.borderSm,
        border: Border.all(color: AppPallete.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppPallete.error,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.stackMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Atención Requerida',
                  style: AppTypography.labelMd.copyWith(
                    color: AppPallete.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.stackSm),
                Text(
                  'Tienes 48 horas para subir la corrección y no perder tu espacio reservado en la grilla.',
                  style: AppTypography.bodySm.copyWith(
                    color: AppPallete.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
