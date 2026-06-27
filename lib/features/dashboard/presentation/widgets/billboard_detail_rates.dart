import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/currency_formatter.dart';

class BillboardDetailRates extends StatelessWidget {
  final double basePricePerHour;

  const BillboardDetailRates({
    super.key,
    required this.basePricePerHour,
  });

  @override
  Widget build(BuildContext context) {
    final dayPrice = basePricePerHour;
    final nightPrice = basePricePerHour * 0.55;
    final peakPrice = basePricePerHour * 1.88;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tarifas por Hora',
            style: AppTypography.headlineMd.copyWith(
              color: AppPallete.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              RateCard(
                title: 'Día',
                timeSlot: '06:00 - 18:00',
                price: dayPrice,
                icon: Icons.light_mode_outlined,
              ),
              const SizedBox(height: 12),
              RateCard(
                title: 'Noche',
                timeSlot: '22:00 - 06:00',
                price: nightPrice,
                icon: Icons.dark_mode_outlined,
              ),
              const SizedBox(height: 12),
              RateCard(
                title: 'Pico',
                timeSlot: '18:00 - 22:00',
                price: peakPrice,
                icon: Icons.local_fire_department_outlined,
                isPeak: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RateCard extends StatelessWidget {
  final String title;
  final String timeSlot;
  final double price;
  final IconData icon;
  final bool isPeak;

  const RateCard({
    super.key,
    required this.title,
    required this.timeSlot,
    required this.price,
    required this.icon,
    this.isPeak = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardBgColor = isPeak ? AppPallete.surfaceContainerLow : AppPallete.surfaceContainerLowest;
    final borderColor = isPeak ? AppPallete.primary.withValues(alpha: 0.3) : AppPallete.borderColor;
    final iconColor = isPeak ? AppPallete.primary : AppPallete.secondary;

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: isPeak
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: iconColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: AppTypography.labelMd.copyWith(
                            color: isPeak ? AppPallete.primary : AppPallete.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      timeSlot,
                      style: AppTypography.bodySm.copyWith(
                        color: AppPallete.textSecondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${CurrencyFormatter.format(price)} / hr',
                  style: AppTypography.headlineMd.copyWith(
                    color: AppPallete.onSurface,
                    fontWeight: isPeak ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isPeak)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppPallete.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Text(
                  'Alta Demanda',
                  style: AppTypography.labelSm.copyWith(
                    color: AppPallete.onPrimary,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
