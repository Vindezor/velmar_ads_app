import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';
import 'bookings_header.dart';
import 'booking_status_section.dart';

class BookingsLoadedView extends StatelessWidget {
  final List<Booking> bookings;
  final RefreshCallback onRefresh;

  const BookingsLoadedView({
    super.key,
    required this.bookings,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final pending = bookings
        .where((b) =>
            b.status.toLowerCase() == 'pending' ||
            b.status.toLowerCase() == 'resubmitted')
        .toList();
    final approved =
        bookings.where((b) => b.status.toLowerCase() == 'approved').toList();
    final rejected = bookings
        .where((b) =>
            b.status.toLowerCase() == 'rejected' ||
            b.status.toLowerCase() == 'expired' ||
            b.status.toLowerCase() == 'cancelled')
        .toList();

    return RefreshIndicator(
      onRefresh: onRefresh,
      backgroundColor: AppPallete.surfaceContainerLowest,
      color: AppPallete.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.containerPadding,
            vertical: AppSpacing.stackLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingsHeader(
                onFilterPressed: () {
                  // Optional filter button action placeholder
                },
              ),
              if (pending.isNotEmpty)
                BookingStatusSection(
                  title: 'Pendientes',
                  bookings: pending,
                  bulletColor: AppPallete.tertiary,
                ),
              if (approved.isNotEmpty)
                BookingStatusSection(
                  title: 'Aprobadas',
                  bookings: approved,
                  bulletColor: AppPallete.primary,
                ),
              if (rejected.isNotEmpty)
                BookingStatusSection(
                  title: 'Rechazadas',
                  bookings: rejected,
                  bulletColor: AppPallete.error,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
