import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/currency_formatter.dart';

class ConfirmationPricingBreakdown extends StatelessWidget {
  final int selectedHours;
  final double basePrice;
  final Map<String, dynamic> priceData;

  const ConfirmationPricingBreakdown({
    super.key,
    required this.selectedHours,
    required this.basePrice,
    required this.priceData,
  });

  @override
  Widget build(BuildContext context) {
    // Safe extraction from pricing RPC response or fallbacks
    final total = (priceData['total'] as num?)?.toDouble() ?? (selectedHours * basePrice);
    final base = (priceData['base'] as num?)?.toDouble() ?? (selectedHours * basePrice);
    final multiplierAdjustment = (priceData['multiplier_adjust'] as num?)?.toDouble() ?? 
        ((priceData['prime_time_adjust'] as num?)?.toDouble() ?? (total - base));
    final tax = (priceData['tax'] as num?)?.toDouble() ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        color: AppPallete.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
        border: Border.all(color: AppPallete.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Desglose de Precio',
              style: AppTypography.headlineMd.copyWith(
                color: AppPallete.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: AppPallete.outlineVariant),
            const SizedBox(height: 16),
            // Base Rate Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Tarifa Base ($selectedHours horas)',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppPallete.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  CurrencyFormatter.format(base),
                  style: AppTypography.bodyMd.copyWith(
                    color: AppPallete.onSurface,
                  ),
                ),
              ],
            ),
            // Multiplier Adjustment if any
            if (multiplierAdjustment > 0.01) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Horario Prime Time / Multiplicador',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppPallete.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    CurrencyFormatter.format(multiplierAdjustment),
                    style: AppTypography.bodyMd.copyWith(
                      color: AppPallete.onSurface,
                    ),
                  ),
                ],
              ),
            ],
            // Tax if any
            if (tax > 0.01) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Impuestos',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppPallete.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    CurrencyFormatter.format(tax),
                    style: AppTypography.bodyMd.copyWith(
                      color: AppPallete.onSurface,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            const Divider(color: AppPallete.outlineVariant),
            const SizedBox(height: 16),
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Total',
                    style: AppTypography.headlineMd.copyWith(
                      color: AppPallete.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  CurrencyFormatter.format(total),
                  style: AppTypography.headlineLg.copyWith(
                    color: AppPallete.primaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
