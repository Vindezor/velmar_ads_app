import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/currency_formatter.dart';
import 'package:velmar_ads/core/utils/date_formatter.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final status = booking.status.toLowerCase();
    final isRejected = status == 'rejected';
    final isApproved = status == 'approved';

    // Status config mapping
    Color accentColor;
    Color badgeBgColor;
    Color badgeTextColor;
    String badgeText;

    if (isApproved) {
      accentColor = AppPallete.primary;
      badgeBgColor = AppPallete.primaryContainer;
      badgeTextColor = AppPallete.onPrimaryContainer;
      badgeText = 'Approved';
    } else if (isRejected) {
      accentColor = AppPallete.error;
      badgeBgColor = AppPallete.errorContainer;
      badgeTextColor = AppPallete.error;
      badgeText = 'Rejected';
    } else {
      // Pending
      accentColor = AppPallete.tertiary;
      badgeBgColor = AppPallete.tertiaryContainer.withValues(alpha: 0.15);
      badgeTextColor = AppPallete.tertiary;
      badgeText = 'Pending';
    }

    final formattedPrice = CurrencyFormatter.format(booking.totalCredits).replaceAll('.00', '');

    Widget cardContent = Container(
      decoration: BoxDecoration(
        color: AppPallete.surfaceContainerLowest,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppPallete.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Left status accent line
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: Container(
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.md),
                  bottomLeft: Radius.circular(AppRadius.md),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.stackMd),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppPallete.surfaceContainer,
                      borderRadius: AppRadius.borderDefault,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: booking.billboardImageUrl != null
                        ? _buildImage(booking.billboardImageUrl!, isRejected)
                        : const Icon(
                            Icons.image_not_supported_outlined,
                            color: AppPallete.secondary,
                            size: 32,
                          ),
                  ),
                  const SizedBox(width: AppSpacing.stackMd),
                  // Content column
                  Expanded(
                    child: SizedBox(
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      booking.billboardName ?? 'Pantalla Desconocida',
                                      style: AppTypography.labelMd.copyWith(
                                        color: AppPallete.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: badgeBgColor,
                                      borderRadius: AppRadius.borderFull,
                                    ),
                                    child: Text(
                                      badgeText,
                                      style: AppTypography.labelSm.copyWith(
                                        color: badgeTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month_outlined,
                                    size: 16,
                                    color: AppPallete.secondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      DateFormatter.formatRange(
                                        booking.startTime,
                                        booking.endTime,
                                      ),
                                      style: AppTypography.bodySm.copyWith(
                                        color: AppPallete.secondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (isRejected)
                                Text(
                                  formattedPrice,
                                  style: AppTypography.headlineMd.copyWith(
                                    color: AppPallete.secondary,
                                    fontSize: 20,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                )
                              else
                                RichText(
                                  text: TextSpan(
                                    text: '$formattedPrice ',
                                    style: AppTypography.headlineMd.copyWith(
                                      color: AppPallete.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'MXN',
                                        style: AppTypography.bodySm.copyWith(
                                          color: AppPallete.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (isRejected) {
      cardContent = Opacity(
        opacity: 0.8,
        child: cardContent,
      );
    }

    return cardContent;
  }

  Widget _buildImage(String url, bool grayscale) {
    final imageWidget = Image.network(
      url,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.broken_image_outlined,
          color: AppPallete.secondary,
          size: 32,
        );
      },
    );

    if (grayscale) {
      return ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Colors.grey,
          BlendMode.saturation,
        ),
        child: imageWidget,
      );
    }
    return imageWidget;
  }
}
