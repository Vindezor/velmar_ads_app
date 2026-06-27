import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/currency_formatter.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';

class BookingPriceDetails extends StatelessWidget {
  final Booking booking;

  const BookingPriceDetails({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final total = booking.totalCredits;
    final subtotal = total / 1.21;
    final tax = total - subtotal;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      decoration: BoxDecoration(
        color: AppPallete.surfaceContainerLowest,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppPallete.surfaceVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                color: AppPallete.primary,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.stackMd),
              Text(
                'Inversión',
                style: AppTypography.bodyLg.copyWith(
                  color: AppPallete.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMd),
          const Divider(color: AppPallete.surfaceVariant),
          const SizedBox(height: AppSpacing.stackMd),
          // Price rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: AppTypography.bodySm.copyWith(
                  color: AppPallete.onSurfaceVariant,
                ),
              ),
              Text(
                CurrencyFormatter.format(subtotal).replaceAll('.00', ''),
                style: AppTypography.bodyMd.copyWith(
                  color: AppPallete.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.stackSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Impuestos (21%)',
                style: AppTypography.bodySm.copyWith(
                  color: AppPallete.onSurfaceVariant,
                ),
              ),
              Text(
                CurrencyFormatter.format(tax).replaceAll('.00', ''),
                style: AppTypography.bodyMd.copyWith(
                  color: AppPallete.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMd),
          const Divider(color: AppPallete.surfaceVariant),
          const SizedBox(height: AppSpacing.stackMd),
          // Total Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTypography.bodyLg.copyWith(
                  color: AppPallete.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                CurrencyFormatter.format(total).replaceAll('.00', ''),
                style: AppTypography.headlineMd.copyWith(
                  color: AppPallete.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
