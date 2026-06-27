import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';

class BookingDetailActions extends StatelessWidget {
  final Booking booking;

  const BookingDetailActions({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final status = booking.status.toLowerCase();
    final isRejected = status == 'rejected';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isRejected) ...[
          ElevatedButton(
            onPressed: () {
              // Navigates to upload asset or similar to edit creativity
              // For now, we can show a SnackBar or navigate
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Editar Creatividad presionado.')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.primary,
              foregroundColor: AppPallete.onPrimary,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.borderMd,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              'Editar Creatividad',
              style: AppTypography.labelMd.copyWith(
                color: AppPallete.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.gutter),
        ],
        OutlinedButton(
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.pop();
            }
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppPallete.primary),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.borderMd,
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text(
            'Volver al historial',
            style: AppTypography.labelMd.copyWith(
              color: AppPallete.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
