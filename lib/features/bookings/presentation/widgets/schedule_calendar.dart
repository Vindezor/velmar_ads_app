import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class ScheduleCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const ScheduleCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  bool _isDaySelected(int day) {
    return selectedDate.day == day && selectedDate.month == 10 && selectedDate.year == 2023;
  }

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
          children: [
            // Calendar Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Octubre 2023',
                  style: AppTypography.headlineMd.copyWith(
                    color: AppPallete.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: AppPallete.secondary),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: AppPallete.secondary),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Days of week header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CalendarHeaderDay(label: 'L'),
                CalendarHeaderDay(label: 'M'),
                CalendarHeaderDay(label: 'X'),
                CalendarHeaderDay(label: 'J'),
                CalendarHeaderDay(label: 'V'),
                CalendarHeaderDay(label: 'S'),
                CalendarHeaderDay(label: 'D'),
              ],
            ),
            const SizedBox(height: 8),
            // Calendar grid rows
            Column(
              children: [
                // Week 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const CalendarDaySquare(day: null, isInactive: true),
                    const CalendarDaySquare(day: null, isInactive: true),
                    const CalendarDaySquare(day: 1, isInactive: true),
                    const CalendarDaySquare(day: 2, isInactive: true),
                    const CalendarDaySquare(day: 3, isInactive: true),
                    const CalendarDaySquare(day: 4, isInactive: true),
                    const CalendarDaySquare(day: 5, isInactive: true),
                  ],
                ),
                const SizedBox(height: 6),
                // Week 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const CalendarDaySquare(day: 6, isInactive: true),
                    const CalendarDaySquare(day: 7, isInactive: true),
                    const CalendarDaySquare(day: 8, isInactive: true),
                    const CalendarDaySquare(day: 9, isInactive: true),
                    const CalendarDaySquare(day: 10, isInactive: true),
                    const CalendarDaySquare(day: 11, isInactive: true),
                    const CalendarDaySquare(day: 12, isInactive: true),
                  ],
                ),
                const SizedBox(height: 6),
                // Week 3
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CalendarDaySquare(
                      day: 13,
                      isSelected: _isDaySelected(13),
                      onTap: () => onDateChanged(DateTime(2023, 10, 13)),
                    ),
                    CalendarDaySquare(
                      day: 14,
                      isSelected: _isDaySelected(14),
                      onTap: () => onDateChanged(DateTime(2023, 10, 14)),
                    ),
                    CalendarDaySquare(
                      day: 15,
                      isPromo: true,
                      isSelected: _isDaySelected(15),
                      onTap: () => onDateChanged(DateTime(2023, 10, 15)),
                    ),
                    CalendarDaySquare(
                      day: 16,
                      isPromo: true,
                      isSelected: _isDaySelected(16),
                      onTap: () => onDateChanged(DateTime(2023, 10, 16)),
                    ),
                    CalendarDaySquare(
                      day: 17,
                      isPromo: true,
                      isSelected: _isDaySelected(17),
                      onTap: () => onDateChanged(DateTime(2023, 10, 17)),
                    ),
                    CalendarDaySquare(
                      day: 18,
                      isPromo: true,
                      isSelected: _isDaySelected(18),
                      onTap: () => onDateChanged(DateTime(2023, 10, 18)),
                    ),
                    CalendarDaySquare(
                      day: 19,
                      isPromo: true,
                      isSelected: _isDaySelected(19),
                      onTap: () => onDateChanged(DateTime(2023, 10, 19)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Week 4
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CalendarDaySquare(
                      day: 20,
                      isPromo: true,
                      isSelected: _isDaySelected(20),
                      onTap: () => onDateChanged(DateTime(2023, 10, 20)),
                    ),
                    CalendarDaySquare(
                      day: 21,
                      isPromo: true,
                      isSelected: _isDaySelected(21),
                      onTap: () => onDateChanged(DateTime(2023, 10, 21)),
                    ),
                    CalendarDaySquare(
                      day: 22,
                      isPromo: true,
                      isSelected: _isDaySelected(22),
                      onTap: () => onDateChanged(DateTime(2023, 10, 22)),
                    ),
                    CalendarDaySquare(
                      day: 23,
                      isPromo: true,
                      isSelected: _isDaySelected(23),
                      onTap: () => onDateChanged(DateTime(2023, 10, 23)),
                    ),
                    CalendarDaySquare(
                      day: 24,
                      isSelected: _isDaySelected(24),
                      onTap: () => onDateChanged(DateTime(2023, 10, 24)),
                    ),
                    CalendarDaySquare(
                      day: 25,
                      isSelected: _isDaySelected(25),
                      onTap: () => onDateChanged(DateTime(2023, 10, 25)),
                    ),
                    CalendarDaySquare(
                      day: 26,
                      isSelected: _isDaySelected(26),
                      onTap: () => onDateChanged(DateTime(2023, 10, 26)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Legend
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CalendarLegendCircle(color: Color(0xFFE8F5E9), label: 'Disponible'),
                SizedBox(width: 16),
                CalendarLegendCircle(color: AppPallete.primaryFixed, label: 'Seleccionado'),
                SizedBox(width: 16),
                CalendarLegendCircle(color: Colors.transparent, label: 'No Disponible', border: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarHeaderDay extends StatelessWidget {
  final String label;

  const CalendarHeaderDay({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
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

class CalendarDaySquare extends StatelessWidget {
  final int? day;
  final bool isInactive;
  final bool isPromo;
  final bool isSelected;
  final VoidCallback? onTap;

  const CalendarDaySquare({
    super.key,
    this.day,
    this.isInactive = false,
    this.isPromo = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (day == null) {
      return const SizedBox(width: 36, height: 36);
    }

    Color bgColor = Colors.transparent;
    Color textColor = AppPallete.onSurface;
    BoxBorder? border;
    FontWeight fontWeight = FontWeight.normal;

    if (isInactive) {
      textColor = AppPallete.outlineVariant;
    } else if (isSelected) {
      bgColor = AppPallete.primaryFixed;
      textColor = AppPallete.onPrimaryFixed;
      fontWeight = FontWeight.bold;
      border = Border.all(color: AppPallete.primary, width: 2.0);
    } else if (isPromo) {
      bgColor = const Color(0xFFE8F5E9);
      textColor = const Color(0xFF2E7D32);
    }

    return InkWell(
      onTap: isInactive ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: border,
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: AppTypography.bodyMd.copyWith(
              color: textColor,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarLegendCircle extends StatelessWidget {
  final Color color;
  final String label;
  final bool border;

  const CalendarLegendCircle({
    super.key,
    required this.color,
    required this.label,
    this.border = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: border ? Border.all(color: AppPallete.outlineVariant) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.labelSm.copyWith(
            color: AppPallete.secondary,
            fontWeight: FontWeight.normal,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
