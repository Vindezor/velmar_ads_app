import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/currency_formatter.dart';

class ScheduleTimeline extends StatelessWidget {
  final List<int> selectedSlots;
  final ValueChanged<int> onSlotToggled;
  final double hourlyPrice;
  final String dateLabel;

  const ScheduleTimeline({
    super.key,
    required this.selectedSlots,
    required this.onSlotToggled,
    required this.hourlyPrice,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    final hours = List.generate(10, (index) => index + 8);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Horarios - $dateLabel',
                  style: AppTypography.headlineMd.copyWith(
                    color: AppPallete.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Zona Centro',
                  style: AppTypography.labelMd.copyWith(
                    color: AppPallete.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: hours.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final hour = hours[index];
                  final isOccupied = hour == 8 || hour == 9;
                  final isSelected = selectedSlots.contains(hour);

                  return HourSlotCard(
                    hour: hour,
                    isOccupied: isOccupied,
                    isSelected: isSelected,
                    price: hourlyPrice,
                    onTap: () {
                      if (!isOccupied) {
                        onSlotToggled(hour);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HourSlotCard extends StatelessWidget {
  final int hour;
  final bool isOccupied;
  final bool isSelected;
  final double price;
  final VoidCallback onTap;

  const HourSlotCard({
    super.key,
    required this.hour,
    required this.isOccupied,
    required this.isSelected,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hourText = '${hour.toString().padLeft(2, '0')}:00';
    
    Color bgColor = AppPallete.surfaceContainerLowest;
    BoxBorder border = Border.all(color: AppPallete.borderColor);
    Widget content;

    if (isOccupied) {
      bgColor = AppPallete.surfaceVariant;
      content = const Icon(
        Icons.block,
        color: AppPallete.outlineVariant,
        size: 24,
      );
    } else if (isSelected) {
      bgColor = AppPallete.primaryFixed;
      border = Border.all(color: AppPallete.primary, width: 2.0);
      content = const Icon(
        Icons.check_circle,
        color: AppPallete.primary,
        size: 24,
      );
    } else {
      content = Text(
        CurrencyFormatter.format(price),
        style: AppTypography.labelSm.copyWith(
          color: AppPallete.secondary,
        ),
      );
    }

    return Column(
      children: [
        Text(
          hourText,
          style: AppTypography.labelSm.copyWith(
            color: isSelected ? AppPallete.primary : AppPallete.secondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: isOccupied ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 64,
            height: 80,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: border,
            ),
            child: Center(child: content),
          ),
        ),
      ],
    );
  }
}
