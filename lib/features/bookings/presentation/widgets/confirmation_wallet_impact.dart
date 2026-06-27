import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/currency_formatter.dart';

class ConfirmationWalletImpact extends StatelessWidget {
  final double currentBalance;
  final double amountToDeduct;

  const ConfirmationWalletImpact({
    super.key,
    required this.currentBalance,
    required this.amountToDeduct,
  });

  @override
  Widget build(BuildContext context) {
    final remainingBalance = currentBalance - amountToDeduct;

    return IntrinsicHeight(
      child: Container(
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left primary container accent border
            Container(
              width: 4,
              color: AppPallete.primaryContainer,
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IMPACTO EN BILLETERA',
                      style: AppTypography.labelMd.copyWith(
                        color: AppPallete.secondary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Current balance
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Saldo Actual',
                          style: AppTypography.bodySm.copyWith(
                            color: AppPallete.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(currentBalance),
                          style: AppTypography.bodySm.copyWith(
                            color: AppPallete.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Deduct amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Monto a descontar',
                          style: AppTypography.bodySm.copyWith(
                            color: AppPallete.error,
                          ),
                        ),
                        Text(
                          '-${CurrencyFormatter.format(amountToDeduct)}',
                          style: AppTypography.bodySm.copyWith(
                            color: AppPallete.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: AppPallete.outlineVariant),
                    const SizedBox(height: 8),
                    // Estimated remaining balance
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Saldo Restante Estimado',
                          style: AppTypography.bodyMd.copyWith(
                            color: AppPallete.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(remainingBalance),
                          style: AppTypography.bodyMd.copyWith(
                            color: AppPallete.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
