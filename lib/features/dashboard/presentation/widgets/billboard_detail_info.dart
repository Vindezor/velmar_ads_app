import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class BillboardDetailInfo extends StatelessWidget {
  final String name;
  final String address;
  final String screenClassLabel;
  final double? widthM;
  final double? heightM;

  const BillboardDetailInfo({
    super.key,
    required this.name,
    required this.address,
    required this.screenClassLabel,
    this.widthM,
    this.heightM,
  });

  @override
  Widget build(BuildContext context) {
    final hasSize = widthM != null && heightM != null;
    final sizeText = hasSize ? '${widthM!.toStringAsFixed(1)}m x ${heightM!.toStringAsFixed(1)}m' : '';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerPadding,
        vertical: AppSpacing.stackMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppTypography.headlineLgMobile.copyWith(
              color: AppPallete.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: AppPallete.secondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  address,
                  style: AppTypography.bodySm.copyWith(
                    color: AppPallete.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Class Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppPallete.primaryFixed.withValues(alpha: 0.2),
                  borderRadius: AppRadius.borderFull,
                ),
                child: Text(
                  screenClassLabel,
                  style: AppTypography.labelSm.copyWith(
                    color: AppPallete.onPrimaryFixedVariant,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Size Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppPallete.surfaceVariant,
                  borderRadius: AppRadius.borderFull,
                ),
                child: Text(
                  'Gran Formato',
                  style: AppTypography.labelSm.copyWith(
                    color: AppPallete.onSurface,
                  ),
                ),
              ),
              if (hasSize) ...[
                const Spacer(),
                Row(
                  children: [
                    const Icon(
                      Icons.straighten,
                      size: 16,
                      color: AppPallete.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      sizeText,
                      style: AppTypography.bodySm.copyWith(
                        color: AppPallete.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
