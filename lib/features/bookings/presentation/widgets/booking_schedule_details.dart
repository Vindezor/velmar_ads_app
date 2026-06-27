import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';

class BookingScheduleDetails extends StatelessWidget {
  final Booking booking;

  const BookingScheduleDetails({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    // Format dates
    final startDay = booking.startTime.day.toString().padLeft(2, '0');
    final startMonth = _getMonthName(booking.startTime.month);
    final startYear = booking.startTime.year.toString();
    final startDateStr = '$startDay $startMonth $startYear';

    final endDay = booking.endTime.day.toString().padLeft(2, '0');
    final endMonth = _getMonthName(booking.endTime.month);
    final endYear = booking.endTime.year.toString();
    final endDateStr = '$endDay $endMonth $endYear';

    final startHour = booking.startTime.hour.toString().padLeft(2, '0');
    final endHour = booking.endTime.hour.toString().padLeft(2, '0');
    final timeStr = '$startHour:00 - $endHour:00';

    final duration = booking.bookingTypeSlotDuration != null
        ? '${booking.bookingTypeSlotDuration} Minutos'
        : '60 Minutos';
        
    final maxAdsStr = booking.bookingTypeMaxAdsPerSlot != null
        ? 'Máx ${booking.bookingTypeMaxAdsPerSlot} anuncios'
        : 'Cada 5 min';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      decoration: BoxDecoration(
        color: AppPallete.surfaceContainerLowest,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppPallete.surfaceVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: AppPallete.primary,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.stackMd),
              Text(
                'Cronograma',
                style: AppTypography.bodyLg.copyWith(
                  color: AppPallete.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.stackMd),
          const Divider(color: AppPallete.surfaceVariant),
          const SizedBox(height: AppSpacing.stackMd),
          // List content
          Column(
            children: [
              _buildRow('Fecha de Inicio', startDateStr),
              const SizedBox(height: AppSpacing.stackMd),
              _buildRow('Fecha de Fin', endDateStr),
              const SizedBox(height: AppSpacing.stackMd),
              _buildRow('Horario', timeStr),
              const SizedBox(height: AppSpacing.stackMd),
              _buildRow('Duración del Slot', duration),
              const SizedBox(height: AppSpacing.stackMd),
              _buildRow('Frecuencia', maxAdsStr),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: AppPallete.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMd.copyWith(
            color: AppPallete.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';
  }
}
