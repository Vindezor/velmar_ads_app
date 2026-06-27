import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class ScheduleContextTitle extends StatelessWidget {
  final String billboardName;
  final double? widthM;
  final double? heightM;

  const ScheduleContextTitle({
    super.key,
    required this.billboardName,
    this.widthM,
    this.heightM,
  });

  @override
  Widget build(BuildContext context) {
    final sizeText = (widthM != null && heightM != null)
        ? ' • ${widthM!.toStringAsFixed(0)}x${heightM!.toStringAsFixed(0)}m'
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selección de Horario',
            style: AppTypography.headlineLgMobile.copyWith(
              color: AppPallete.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$billboardName$sizeText',
            style: AppTypography.bodyMd.copyWith(
              color: AppPallete.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
