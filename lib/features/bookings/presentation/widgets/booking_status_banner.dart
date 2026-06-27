import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';

class BookingStatusBanner extends StatelessWidget {
  final Booking booking;

  const BookingStatusBanner({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final status = booking.status.toLowerCase();
    final isRejected = status == 'rejected';
    final isApproved = status == 'approved';

    Color bgColor;
    Color textColor;
    IconData icon;
    String titleText;
    String descriptionText;

    if (isApproved) {
      bgColor = AppPallete.primaryContainer.withValues(alpha: 0.15);
      textColor = AppPallete.primary;
      icon = Icons.check_circle;
      titleText = 'Reserva Aprobada';
      descriptionText = 'Tu campaña está lista y programada para publicarse.';
    } else if (isRejected) {
      bgColor = AppPallete.errorContainer;
      textColor = AppPallete.error;
      icon = Icons.cancel;
      titleText = 'Reserva Rechazada';
      descriptionText = booking.moderationNotes ?? 
          'El contenido del anuncio no cumple con las políticas de la pantalla.';
    } else {
      // Pending / Resubmitted / Other
      bgColor = AppPallete.tertiaryContainer.withValues(alpha: 0.15);
      textColor = AppPallete.tertiary;
      icon = Icons.pending_actions;
      titleText = 'Reserva Pendiente';
      descriptionText = 'Tu campaña está siendo moderada por el equipo de administración.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: textColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: textColor,
            size: 28,
          ),
          const SizedBox(width: AppSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titleText,
                  style: AppTypography.headlineMd.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  descriptionText,
                  style: AppTypography.bodySm.copyWith(
                    color: textColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
