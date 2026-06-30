import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/common/widgets/loader.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/billboard.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/schedule_app_bar.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/schedule_context_title.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/schedule_calendar.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/schedule_time_selector.dart';
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
  int? _startHour;
  int? _endHour;
  final List<int> _selectedSlots = [];

  @override
  void initState() {
    super.initState();
    _startDate = null;
    _endDate = null;
    _startHour = null;
    _endHour = null;
  }

  void _onRangeChanged(DateTime start, DateTime? end) {
    setState(() {
      _startDate = start;
      _endDate = end;
      _startHour = null;
      _endHour = null;
      _selectedSlots.clear();
    });
  }

  void _onStartHourChanged(int? hour) {
    setState(() {
      _startHour = hour;
      if (_endHour != null && hour != null && _endHour! <= hour) {
        _endHour = null;
      }
      _updateSelectedSlots();
    });
  }

  void _onEndHourChanged(int? hour) {
    setState(() {
      _endHour = hour;
      _updateSelectedSlots();
    });
  }

  void _updateSelectedSlots() {
    _selectedSlots.clear();
    if (_startHour != null && _endHour != null) {
      for (int i = _startHour!; i < _endHour!; i++) {
        _selectedSlots.add(i);
      }
    }
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

    if (sortedSlots.isEmpty || _startDate == null) {
      selectedHours = 0;
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
                              'Haz clic en el día de inicio y luego en el día de fin de tu campaña. Si es de un solo día, haz un único clic en ese día.',
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
                              'Selecciona la hora en la que iniciará tu campaña y la hora en la que terminará.',
                              style: AppTypography.bodySm.copyWith(
                                color: AppPallete.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ScheduleTimeSelector(
                        startHour: _startHour,
                        endHour: _endHour,
                        onStartHourChanged: _onStartHourChanged,
                        onEndHourChanged: _onEndHourChanged,
                        startDate: _startDate,
                        endDate: _endDate,
                        bookings: bookings,
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
