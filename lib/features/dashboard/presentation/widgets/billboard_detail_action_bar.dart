import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class BillboardDetailActionBar extends StatelessWidget {
  final VoidCallback? onPressed;

  const BillboardDetailActionBar({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerPadding,
        vertical: AppSpacing.stackMd,
      ),
      decoration: BoxDecoration(
        color: AppPallete.surfaceContainerLowest,
        border: const Border(
          top: BorderSide(
            color: AppPallete.borderColor,
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPallete.primaryContainer,
            foregroundColor: AppPallete.onPrimary,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderMd,
            ),
            elevation: 0,
          ),
          onPressed: onPressed,
          child: Text(
            'Seleccionar horario',
            style: AppTypography.labelMd.copyWith(
              fontWeight: FontWeight.bold,
              color: AppPallete.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
