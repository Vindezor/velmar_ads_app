import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class ConfirmationActionArea extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmationActionArea({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPallete.primaryContainer,
            foregroundColor: AppPallete.onPrimary,
            minimumSize: const Size.fromHeight(48),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
            ),
            elevation: 0,
            shadowColor: Colors.black.withValues(alpha: 0.1),
          ),
          onPressed: onConfirm,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 20,
                color: AppPallete.onPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                'Confirmar reserva',
                style: AppTypography.labelMd.copyWith(
                  color: AppPallete.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.stackMd),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTypography.bodySm.copyWith(
              color: AppPallete.secondary,
              height: 1.4,
            ),
            children: [
              const TextSpan(text: 'Al confirmar, aceptas nuestros '),
              TextSpan(
                text: 'Términos de Servicio',
                style: AppTypography.bodySm.copyWith(
                  color: AppPallete.primaryContainer,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const TextSpan(text: ' y '),
              TextSpan(
                text: 'Política de Cancelación',
                style: AppTypography.bodySm.copyWith(
                  color: AppPallete.primaryContainer,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const TextSpan(
                text: '. Las reservas en Prime Time no son reembolsables.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
