import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';
import 'booking_card.dart';

class BookingStatusSection extends StatelessWidget {
  final String title;
  final List<Booking> bookings;
  final Color bulletColor;

  const BookingStatusSection({
    super.key,
    required this.title,
    required this.bookings,
    required this.bulletColor,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) return const SizedBox.shrink();

    // Responsive grid columns based on screen width
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    if (width >= 1024) {
      crossAxisCount = 3;
    } else if (width >= 640) {
      crossAxisCount = 2;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.gutter),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: bulletColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Text(
                title,
                style: AppTypography.headlineMd.copyWith(
                  color: AppPallete.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppPallete.surfaceContainer,
                  borderRadius: AppRadius.borderFull,
                ),
                child: Text(
                  bookings.length.toString(),
                  style: AppTypography.labelSm.copyWith(
                    color: AppPallete.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Grid layout for cards
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.stackLg,
            mainAxisSpacing: AppSpacing.stackLg,
            mainAxisExtent: 126,
          ),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            return BookingCard(booking: bookings[index]);
          },
        ),
        const SizedBox(height: AppSpacing.stackLg),
      ],
    );
  }
}
