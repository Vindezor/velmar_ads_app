import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class ConfirmationHeader extends StatelessWidget {
  const ConfirmationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen de Reserva',
          style: AppTypography.headlineLg.copyWith(
            color: AppPallete.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.stackSm),
        Text(
          'Revisa los detalles de tu campaña antes de confirmar.',
          style: AppTypography.bodyMd.copyWith(
            color: AppPallete.secondary,
          ),
        ),
      ],
    );
  }
}
