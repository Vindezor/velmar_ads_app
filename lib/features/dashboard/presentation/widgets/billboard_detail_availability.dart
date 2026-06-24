import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class BillboardDetailAvailability extends StatelessWidget {
  const BillboardDetailAvailability({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Disponibilidad',
                style: AppTypography.headlineMd.copyWith(
                  color: AppPallete.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Octubre 2023',
                style: AppTypography.labelSm.copyWith(
                  color: AppPallete.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppPallete.surfaceContainerLowest,
              borderRadius: AppRadius.borderMd,
              border: Border.all(color: AppPallete.borderColor),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Days of week header
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DayHeader(label: 'L'),
                    DayHeader(label: 'M'),
                    DayHeader(label: 'M'),
                    DayHeader(label: 'J'),
                    DayHeader(label: 'V'),
                    DayHeader(label: 'S'),
                    DayHeader(label: 'D'),
                  ],
                ),
                const SizedBox(height: 8),
                // Calendar Grid Row-by-Row
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DaySquare(status: DayStatus.inactive),
                    DaySquare(status: DayStatus.inactive),
                    DaySquare(status: DayStatus.available),
                    DaySquare(status: DayStatus.available),
                    DaySquare(status: DayStatus.available),
                    DaySquare(status: DayStatus.busy),
                    DaySquare(status: DayStatus.busy),
                  ],
                ),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DaySquare(status: DayStatus.available),
                    DaySquare(status: DayStatus.available),
                    DaySquare(status: DayStatus.available),
                    DaySquare(status: DayStatus.busy),
                    DaySquare(status: DayStatus.busy),
                    DaySquare(status: DayStatus.busy),
                    DaySquare(status: DayStatus.busy),
                  ],
                ),
                const SizedBox(height: 16),
                // Legend
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LegendItem(color: Color(0xFFE8F5E9), label: 'Disponible'),
                    SizedBox(width: 24),
                    LegendItem(color: Color(0xFFFFEBEE), label: 'Ocupado'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum DayStatus { inactive, available, busy }

class DayHeader extends StatelessWidget {
  final String label;

  const DayHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Center(
        child: Text(
          label,
          style: AppTypography.labelSm.copyWith(
            color: AppPallete.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class DaySquare extends StatelessWidget {
  final DayStatus status;

  const DaySquare({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    double opacity = 1.0;

    switch (status) {
      case DayStatus.inactive:
        bgColor = AppPallete.surfaceVariant;
        opacity = 0.5;
        break;
      case DayStatus.available:
        bgColor = const Color(0xFFE8F5E9);
        break;
      case DayStatus.busy:
        bgColor = const Color(0xFFFFEBEE);
        break;
    }

    return Opacity(
      opacity: opacity,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.labelSm.copyWith(
            color: AppPallete.secondary,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
