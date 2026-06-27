import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';

class CorrectionRejectedAssetCard extends StatelessWidget {
  final Booking booking;

  const CorrectionRejectedAssetCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final hasAsset = booking.assetFileUrl != null;
    final filename = booking.assetOriginalFilename ?? 'verano_ad_v1.mp4';
    
    // Format moderation date (Simulated since entity does not hold moderatedAt)
    final modDate = DateTime.now().subtract(const Duration(hours: 2));
    final timeStr = '${modDate.hour.toString().padLeft(2, '0')}:${modDate.minute.toString().padLeft(2, '0')}';
    final dateStr = 'Ayer, $timeStr';

    return Container(
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header banner
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.gutter,
              vertical: AppSpacing.stackMd,
            ),
            decoration: const BoxDecoration(
              color: AppPallete.surfaceContainerLow,
              border: Border(
                bottom: BorderSide(color: AppPallete.outlineVariant),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Material Rechazado',
                  style: AppTypography.labelMd.copyWith(
                    color: AppPallete.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppPallete.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cancel,
                        color: AppPallete.error,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Rechazado',
                        style: AppTypography.labelSm.copyWith(
                          color: AppPallete.error,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Content Layout
          Padding(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 500;
                final thumbnail = AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppPallete.surfaceContainer,
                      borderRadius: AppRadius.borderSm,
                      border: Border.all(color: AppPallete.outlineVariant),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.5,
                            child: ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.saturation,
                              ),
                              child: hasAsset
                                  ? Image.network(
                                      booking.assetFileUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) =>
                                          _buildPlaceholder(),
                                    )
                                  : _buildPlaceholder(),
                            ),
                          ),
                        ),
                        const Center(
                          child: Icon(
                            Icons.block,
                            color: AppPallete.error,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                final details = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Motivo del rechazo (Administración):',
                      style: AppTypography.labelSm.copyWith(
                        color: AppPallete.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.stackMd),
                      decoration: const BoxDecoration(
                        color: AppPallete.surfaceContainer,
                        border: Border(
                          left: BorderSide(
                            color: AppPallete.error,
                            width: 4,
                          ),
                        ),
                      ),
                      child: Text(
                        booking.moderationNotes ??
                            'El contenido del anuncio no cumple con las políticas de la pantalla.',
                        style: AppTypography.bodySm.copyWith(
                          color: AppPallete.onSurface,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.image,
                          size: 16,
                          color: AppPallete.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            filename,
                            style: AppTypography.bodySm.copyWith(
                              color: AppPallete.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.schedule,
                          size: 16,
                          color: AppPallete.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateStr,
                          style: AppTypography.bodySm.copyWith(
                            color: AppPallete.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                );

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 180,
                        child: thumbnail,
                      ),
                      const SizedBox(width: AppSpacing.gutter),
                      Expanded(
                        child: details,
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      thumbnail,
                      const SizedBox(height: AppSpacing.gutter),
                      details,
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppPallete.secondary,
      child: const Center(
        child: Icon(Icons.video_library_outlined, color: Colors.white24, size: 32),
      ),
    );
  }
}
