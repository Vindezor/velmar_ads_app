import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class AssetUploadFooter extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback? onConfirm;

  const AssetUploadFooter({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppPallete.surfaceBright,
        border: Border(
          top: BorderSide(
            color: AppPallete.outlineVariant,
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Cancel Button
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(120, 48),
              side: const BorderSide(color: AppPallete.primaryContainer, width: 1),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
              ),
            ),
            onPressed: onCancel,
            child: Text(
              'Cancelar',
              style: AppTypography.labelMd.copyWith(
                color: AppPallete.primaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.gutter),
          // Confirm Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(160, 48),
              backgroundColor: onConfirm != null
                  ? AppPallete.primaryContainer
                  : AppPallete.disabledColor,
              foregroundColor: AppPallete.onPrimary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
              ),
              elevation: 0,
            ),
            onPressed: onConfirm,
            child: Text(
              'Confirmar asset',
              style: AppTypography.labelMd.copyWith(
                color: onConfirm != null
                    ? AppPallete.onPrimary
                    : AppPallete.secondaryFixedDim,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
