import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';

class BookingScreenDetails extends StatelessWidget {
  final Booking booking;

  const BookingScreenDetails({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
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
                Icons.location_on,
                color: AppPallete.primary,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.stackMd),
              Text(
                'Detalles de la Pantalla',
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
          // Grid content
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.gutter,
              mainAxisSpacing: AppSpacing.gutter,
              mainAxisExtent: 65, // Fixed height for fields
            ),
            children: [
              _buildField(
                'Nombre',
                booking.billboardName ?? 'N/A',
              ),
              _buildField(
                'Ubicación',
                booking.billboardAddress ?? 'N/A',
              ),
              _buildField(
                'Tipo',
                booking.billboardScreenType ?? 'N/A',
              ),
              _buildField(
                'Resolución',
                booking.billboardResolution ?? 'N/A',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSm.copyWith(
            color: AppPallete.onSurfaceVariant,
            letterSpacing: 1.2,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodyMd.copyWith(
              color: AppPallete.onSurface,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
