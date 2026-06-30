import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/common/widgets/loader.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/billboard.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/schedule_app_bar.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/schedule_context_title.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/schedule_calendar.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/schedule_timeline.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/schedule_summary.dart';
import 'package:velmar_ads/features/bookings/presentation/bloc/bookings_bloc.dart';

class ScheduleSelectionPage extends StatefulWidget {
  final Billboard? billboard;

  const ScheduleSelectionPage({
    super.key,
    required this.billboard,
  });

  @override
  State<ScheduleSelectionPage> createState() => _ScheduleSelectionPageState();
}

class _ScheduleSelectionPageState extends State<ScheduleSelectionPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  final List<int> _selectedSlots = [];

  @override
  void initState() {
    super.initState();
    _startDate = null;
    _endDate = null;
  }

  void _onRangeChanged(DateTime start, DateTime? end) {
    setState(() {
      _startDate = start;
      _endDate = end;
      _selectedSlots.clear();
    });
  }

  void _onSlotToggled(int hour) {
    setState(() {
      if (_selectedSlots.contains(hour)) {
        if (_selectedSlots.isEmpty) {
          _selectedSlots.add(hour);
        } else if (_selectedSlots.length == 1) {
          final first = _selectedSlots.first;
          if (hour == first) {
            _selectedSlots.clear();
          } else {
            final start = first < hour ? first : hour;
            final end = first < hour ? hour : first;
            _selectedSlots.clear();
            for (int i = start; i <= end; i++) {
              _selectedSlots.add(i);
            }
          }
        } else {
          _selectedSlots.clear();
          _selectedSlots.add(hour);
        }
      } else {
        if (_selectedSlots.isEmpty) {
          _selectedSlots.add(hour);
        } else {
          _selectedSlots.sort();
          final min = _selectedSlots.first;
          final max = _selectedSlots.last;
          if (hour < min) {
            _selectedSlots.clear();
            for (int i = hour; i <= max; i++) {
              _selectedSlots.add(i);
            }
          } else if (hour > max) {
            _selectedSlots.clear();
            for (int i = min; i <= hour; i++) {
              _selectedSlots.add(i);
            }
          } else {
            _selectedSlots.clear();
            _selectedSlots.add(hour);
          }
        }
      }
    });
  }

  String _getMonthAbbreviation(int month) {
    const abbrev = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return abbrev[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.billboard == null) {
      return const Scaffold(
        appBar: ScheduleAppBar(),
        body: Center(
          child: Text('Pantalla no encontrada'),
        ),
      );
    }

    final b = widget.billboard!;
    final basePrice = b.pricePerHour;

    final sortedSlots = List<int>.from(_selectedSlots)..sort();
    final int selectedHours;
    final String dateLabel;

    if (sortedSlots.isEmpty || _startDate == null) {
      selectedHours = 0;
      dateLabel = 'Selecciona fecha y hora';
    } else {
      final actualEndDate = _endDate ?? _startDate!;
      final minHour = sortedSlots.first;
      final maxHour = sortedSlots.last;

      final startDateTime = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        minHour,
      );
      final endDateTime = DateTime(
        actualEndDate.year,
        actualEndDate.month,
        actualEndDate.day,
        maxHour + 1,
      );

      final diff = endDateTime.difference(startDateTime);
      selectedHours = diff.inHours;

      final startLabel = '${_startDate!.day} ${_getMonthAbbreviation(_startDate!.month)}';
      if (_startDate!.day == actualEndDate.day &&
          _startDate!.month == actualEndDate.month &&
          _startDate!.year == actualEndDate.year) {
        dateLabel = startLabel;
      } else {
        final endLabel = '${actualEndDate.day} ${_getMonthAbbreviation(actualEndDate.month)}';
        dateLabel = '$startLabel - $endLabel';
      }
    }

    final subtotal = selectedHours * basePrice;

    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: const ScheduleAppBar(),
      body: BlocBuilder<BookingsBloc, BookingsState>(
        builder: (context, state) {
          return switch (state) {
            BookingsInitial() || BookingsAvailabilityLoading() => const Loader(),
            BookingsAvailabilityError(message: final msg) => Center(child: Text(msg)),
            BookingsAvailabilityLoaded(bookings: final bookings) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScheduleContextTitle(
                        billboardName: b.name,
                        widthM: b.widthM,
                        heightM: b.heightM,
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1. Selecciona el rango de fechas',
                              style: AppTypography.titleMd.copyWith(
                                color: AppPallete.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Haz clic en el día de inicio y luego en el día de fin de tu campaña. Si es de un solo día, haz clic dos veces en el mismo día.',
                              style: AppTypography.bodySm.copyWith(
                                color: AppPallete.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ScheduleCalendar(
                        startDate: _startDate,
                        endDate: _endDate,
                        onRangeChanged: _onRangeChanged,
                        bookings: bookings,
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '2. Selecciona el rango de horas',
                              style: AppTypography.titleMd.copyWith(
                                color: AppPallete.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Selecciona la hora de inicio y la hora de fin en el timeline. El intervalo intermedio se autocompletará.',
                              style: AppTypography.bodySm.copyWith(
                                color: AppPallete.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ScheduleTimeline(
                        selectedSlots: _selectedSlots,
                        onSlotToggled: _onSlotToggled,
                        hourlyPrice: basePrice,
                        dateLabel: dateLabel,
                        bookings: bookings,
                        startDate: _startDate ?? DateTime.now(),
                        endDate: _endDate ?? _startDate ?? DateTime.now(),
                      ),
                      const SizedBox(height: 24),
                      ScheduleSummary(
                        basePrice: basePrice,
                        selectedHours: selectedHours,
                        subtotal: subtotal,
                        onContinue: () {
                          if (_startDate == null || _selectedSlots.isEmpty) return;
                          context.pushNamed(
                            'upload-asset',
                            pathParameters: {'id': b.id},
                            extra: {
                              'billboard': b,
                              'startDate': _startDate,
                              'endDate': _endDate ?? _startDate,
                              'selectedSlots': _selectedSlots,
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            _ => const Loader(),
          };
        },
      ),
    );
  }
}
