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
  late DateTime _selectedDate;
  final List<int> _selectedSlots = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _onDaySelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedSlots.clear();
    });
  }

  void _onSlotToggled(int hour) {
    setState(() {
      if (_selectedSlots.contains(hour)) {
        _selectedSlots.remove(hour);
      } else {
        _selectedSlots.add(hour);
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
    final selectedHours = _selectedSlots.length;
    final subtotal = selectedHours * basePrice;
    final dateLabel = '${_selectedDate.day} ${_getMonthAbbreviation(_selectedDate.month)}';

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
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.stackLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScheduleContextTitle(
                        billboardName: b.name,
                        widthM: b.widthM,
                        heightM: b.heightM,
                      ),
                      const SizedBox(height: 24),
                      ScheduleCalendar(
                        selectedDate: _selectedDate,
                        onDateChanged: _onDaySelected,
                        bookings: bookings,
                      ),
                      const SizedBox(height: 24),
                      ScheduleTimeline(
                        selectedSlots: _selectedSlots,
                        onSlotToggled: _onSlotToggled,
                        hourlyPrice: basePrice,
                        dateLabel: dateLabel,
                        bookings: bookings,
                        selectedDate: _selectedDate,
                      ),
                      const SizedBox(height: 24),
                      ScheduleSummary(
                        basePrice: basePrice,
                        selectedHours: selectedHours,
                        subtotal: subtotal,
                        onContinue: () {
                          context.pushNamed(
                            'upload-asset',
                            pathParameters: {'id': b.id},
                            extra: {
                              'billboard': b,
                              'selectedDate': _selectedDate,
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
