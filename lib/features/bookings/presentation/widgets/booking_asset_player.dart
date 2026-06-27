import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';

class BookingAssetPlayer extends StatelessWidget {
  final Booking booking;

  const BookingAssetPlayer({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final hasAsset = booking.assetFileUrl != null;
    final isVideo = booking.assetFileType?.toLowerCase() == 'video';

    // Mock file metadata
    final filename = booking.assetOriginalFilename ?? 'Creatividad Principal';
    final format = booking.assetFileType?.toUpperCase() ?? 'MP4';
    final size = booking.assetFileSizeMb != null 
        ? '${booking.assetFileSizeMb!.toStringAsFixed(1)}MB'
        : '12MB';
    final resolution = booking.billboardResolution ?? '1920x1080 px';
    final specsText = '$format • $resolution • 15s • $size';

    return Container(
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Player Canvas
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                // Asset Image or Placeholder
                Positioned.fill(
                  child: hasAsset
                      ? Image.network(
                          booking.assetFileUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
                // Gradients & Controls for Video
                if (isVideo) ...[
                  // Play Button overlay
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppPallete.primary.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: AppPallete.onPrimary,
                        size: 48,
                      ),
                    ),
                  ),
                  // Progress Bar overlay
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black87],
                        ),
                      ),
                      padding: const EdgeInsets.all(AppSpacing.stackMd),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.pause,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Container(
                                height: 4,
                                color: Colors.white24,
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: 0.33,
                                  child: Container(
                                    color: AppPallete.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '0:05 / 0:15',
                            style: AppTypography.labelSm.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.volume_up,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Specifications footer
          Padding(
            padding: const EdgeInsets.all(AppSpacing.containerPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  filename,
                  style: AppTypography.headlineMd.copyWith(
                    color: AppPallete.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  specsText,
                  style: AppTypography.bodySm.copyWith(
                    color: AppPallete.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppPallete.onSurface,
      child: const Center(
        child: Icon(
          Icons.video_library_outlined,
          color: Colors.white54,
          size: 64,
        ),
      ),
    );
  }
}
