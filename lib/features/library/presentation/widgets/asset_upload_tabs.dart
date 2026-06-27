import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class AssetUploadTabs extends StatelessWidget {
  const AssetUploadTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppPallete.borderColor,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          // Active Tab: Upload New / Subir Nuevo
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppPallete.surfaceContainerLow,
                border: Border(
                  bottom: BorderSide(
                    color: AppPallete.primaryContainer,
                    width: 2.0,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.stackMd,
                horizontal: AppSpacing.gutter,
              ),
              child: Text(
                'Subir Nuevo',
                textAlign: TextAlign.center,
                style: AppTypography.labelMd.copyWith(
                  color: AppPallete.primaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Disabled Tab: Use Approved / Usar Aprobados
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.stackMd,
                horizontal: AppSpacing.gutter,
              ),
              child: Text(
                'Usar Aprobados',
                textAlign: TextAlign.center,
                style: AppTypography.labelMd.copyWith(
                  color: AppPallete.secondaryFixedDim,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
