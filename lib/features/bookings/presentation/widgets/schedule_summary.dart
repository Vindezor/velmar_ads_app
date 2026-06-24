import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/currency_formatter.dart';

class ScheduleSummary extends StatelessWidget {
  final double basePrice;
  final int selectedHours;
  final double subtotal;
  final VoidCallback onContinue;

  const ScheduleSummary({
    super.key,
    required this.basePrice,
    required this.selectedHours,
    required this.subtotal,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
      child: Container(
        decoration: BoxDecoration(
          color: AppPallete.surfaceContainerLowest,
          borderRadius: AppRadius.borderLg,
          border: Border.all(color: AppPallete.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen',
              style: AppTypography.headlineMd.copyWith(
                color: AppPallete.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: AppPallete.borderColor),
            const SizedBox(height: 12),
            // Breakdown details
            BreakdownRow(
              label: 'Tarifa Base (Hora)',
              value: CurrencyFormatter.format(basePrice),
            ),
            const SizedBox(height: 8),
            BreakdownRow(
              label: 'Horas Seleccionadas',
              value: '$selectedHours hrs',
            ),
            const SizedBox(height: 12),
            const Divider(color: AppPallete.borderColor),
            const SizedBox(height: 12),
            // Subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: AppTypography.labelMd.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppPallete.onSurface,
                  ),
                ),
                Text(
                  CurrencyFormatter.format(subtotal),
                  style: AppTypography.headlineMd.copyWith(
                    color: AppPallete.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Continue Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPallete.primaryContainer,
                foregroundColor: AppPallete.onPrimary,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.borderMd,
                ),
                elevation: 0,
              ),
              onPressed: selectedHours > 0 ? onContinue : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continuar',
                    style: AppTypography.labelMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppPallete.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BreakdownRow extends StatelessWidget {
  final String label;
  final String value;

  const BreakdownRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: AppPallete.secondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMd.copyWith(
            color: AppPallete.onSurface,
          ),
        ),
      ],
    );
  }
}
