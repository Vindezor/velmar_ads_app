import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';

class CalendarDayData {
  final DateTime date;
  final bool isCurrentMonth;

  CalendarDayData({
    required this.date,
    required this.isCurrentMonth,
  });
}

class ScheduleCalendar extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime startDate, DateTime? endDate) onRangeChanged;
  final List<Booking> bookings;

  const ScheduleCalendar({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onRangeChanged,
    required this.bookings,
  });

  @override
  State<ScheduleCalendar> createState() => _ScheduleCalendarState();
}

class _ScheduleCalendarState extends State<ScheduleCalendar> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    final initialDate = widget.startDate ?? DateTime.now();
    _focusedMonth = DateTime(initialDate.year, initialDate.month, 1);
  }

  @override
  void didUpdateWidget(covariant ScheduleCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startDate != widget.startDate && widget.startDate != null) {
      _focusedMonth = DateTime(widget.startDate!.year, widget.startDate!.month, 1);
    }
  }

  void _handleDayTap(DateTime clickedDate) {
    final start = widget.startDate;
    final end = widget.endDate;

    if (start == null || end != null) {
      widget.onRangeChanged(clickedDate, null);
    } else {
      if (clickedDate.isBefore(start)) {
        widget.onRangeChanged(clickedDate, null);
      } else {
        widget.onRangeChanged(start, clickedDate);
      }
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final year = _focusedMonth.year;
    final month = _focusedMonth.month;

    // Number of days in current month
    final totalDays = DateTime(year, month + 1, 0).day;

    // Weekday of the 1st of the month (1 = Mon, 7 = Sun)
    final firstWeekday = DateTime(year, month, 1).weekday;

    // Monday as the first day of the week
    final prefixEmptySlots = firstWeekday - 1;

    final List<CalendarDayData> gridDays = [];

    // 1. Previous month padding days
    final prevMonth = month == 1 ? 12 : month - 1;
    final prevYear = month == 1 ? year - 1 : year;
    final prevMonthDaysCount = DateTime(prevYear, prevMonth + 1, 0).day;
    for (int i = prefixEmptySlots - 1; i >= 0; i--) {
      final dayNum = prevMonthDaysCount - i;
      gridDays.add(CalendarDayData(
        date: DateTime(prevYear, prevMonth, dayNum),
        isCurrentMonth: false,
      ));
    }

    // 2. Current month days
    for (int i = 1; i <= totalDays; i++) {
      gridDays.add(CalendarDayData(
        date: DateTime(year, month, i),
        isCurrentMonth: true,
      ));
    }

    // 3. Next month padding days
    final nextMonth = month == 12 ? 1 : month + 1;
    final nextYear = month == 12 ? year + 1 : year;
    final remainingSlots = (7 - (gridDays.length % 7)) % 7;
    for (int i = 1; i <= remainingSlots; i++) {
      gridDays.add(CalendarDayData(
        date: DateTime(nextYear, nextMonth, i),
        isCurrentMonth: false,
      ));
    }

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    final List<List<CalendarDayData>> weeks = [];
    for (int i = 0; i < gridDays.length; i += 7) {
      weeks.add(gridDays.sublist(i, i + 7));
    }

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
                  '${_getMonthName(month)} $year',
                  style: AppTypography.headlineMd.copyWith(
                    color: AppPallete.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: AppPallete.secondary),
                      onPressed: _previousMonth,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: AppPallete.secondary),
                      onPressed: _nextMonth,
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
              children: weeks.map((week) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: week.map((dayData) {
                      final isInactive = !dayData.isCurrentMonth || dayData.date.isBefore(todayStart);

                      final dateToCompare = DateTime(dayData.date.year, dayData.date.month, dayData.date.day);
                      final startToCompare = widget.startDate != null 
                          ? DateTime(widget.startDate!.year, widget.startDate!.month, widget.startDate!.day)
                          : null;
                      final endToCompare = widget.endDate != null 
                          ? DateTime(widget.endDate!.year, widget.endDate!.month, widget.endDate!.day)
                          : null;

                      final isStart = startToCompare != null && dateToCompare.isAtSameMomentAs(startToCompare);
                      final isEnd = endToCompare != null && dateToCompare.isAtSameMomentAs(endToCompare);
                      final isInRange = startToCompare != null && endToCompare != null &&
                          dateToCompare.isAfter(startToCompare) && dateToCompare.isBefore(endToCompare);

                      final hasBookings = widget.bookings.any((booking) {
                        final dayStart = DateTime(dayData.date.year, dayData.date.month, dayData.date.day, 0, 0, 0);
                        final dayEnd = DateTime(dayData.date.year, dayData.date.month, dayData.date.day, 23, 59, 59, 999);
                        return booking.startTime.isBefore(dayEnd) && booking.endTime.isAfter(dayStart);
                      });

                      return CalendarDaySquare(
                        day: dayData.date.day,
                        isInactive: isInactive,
                        isSelected: isStart || isEnd || isInRange,
                        isStart: isStart,
                        isEnd: isEnd,
                        isInRange: isInRange,
                        isOccupied: !isInactive && hasBookings,
                        onTap: () => _handleDayTap(dayData.date),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
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
  final bool isSelected;
  final bool isStart;
  final bool isEnd;
  final bool isInRange;
  final bool isOccupied;
  final VoidCallback? onTap;

  const CalendarDaySquare({
    super.key,
    this.day,
    this.isInactive = false,
    this.isSelected = false,
    this.isStart = false,
    this.isEnd = false,
    this.isInRange = false,
    this.isOccupied = false,
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
    BorderRadius? borderRadius = BorderRadius.circular(8);

    if (isInactive) {
      textColor = AppPallete.outlineVariant;
    } else if (isStart || isEnd) {
      bgColor = AppPallete.primary;
      textColor = AppPallete.onPrimary;
      fontWeight = FontWeight.bold;
      if (isStart && isEnd) {
        borderRadius = BorderRadius.circular(8);
      } else if (isStart) {
        borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        );
      } else {
        borderRadius = const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        );
      }
    } else if (isInRange) {
      bgColor = AppPallete.primary.withValues(alpha: 0.15);
      textColor = AppPallete.primary;
      fontWeight = FontWeight.w500;
      borderRadius = BorderRadius.zero;
    } else if (isOccupied) {
      bgColor = Colors.transparent;
      textColor = AppPallete.secondary;
      border = Border.all(color: AppPallete.outlineVariant);
    } else {
      bgColor = const Color(0xFFE8F5E9);
      textColor = const Color(0xFF2E7D32);
    }

    return InkWell(
      onTap: isInactive ? null : onTap,
      borderRadius: borderRadius,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
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
