import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/show_snackbar.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/billboard.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/schedule_app_bar.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/schedule_context_title.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/schedule_calendar.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/schedule_timeline.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/schedule_summary.dart';

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
  DateTime _selectedDate = DateTime(2023, 10, 14);
  final List<int> _selectedSlots = [11, 12]; // Matches design pre-selections

  void _onDaySelected(DateTime date) {
    setState(() {
      _selectedDate = date;
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
    final dateLabel = '${_selectedDate.day} Oct';

    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: const ScheduleAppBar(),
      body: SingleChildScrollView(
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
              ),
              const SizedBox(height: 24),
              ScheduleTimeline(
                selectedSlots: _selectedSlots,
                onSlotToggled: _onSlotToggled,
                hourlyPrice: basePrice,
                dateLabel: dateLabel,
              ),
              const SizedBox(height: 24),
              ScheduleSummary(
                basePrice: basePrice,
                selectedHours: selectedHours,
                subtotal: subtotal,
                onContinue: () {
                  showSnackBar(
                    context: context,
                    message: 'Reserva solicitada para ${b.name} ($selectedHours hrs)',
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
