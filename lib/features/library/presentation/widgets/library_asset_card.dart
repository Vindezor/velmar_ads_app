import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/library/domain/entities/creative_asset.dart';
import 'package:velmar_ads/features/library/presentation/widgets/video_thumbnail_widget.dart';

class LibraryAssetCard extends StatelessWidget {
  final CreativeAsset asset;
  final VoidCallback onTap;

  const LibraryAssetCard({
    super.key,
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isVideo = asset.fileType.toLowerCase() == 'video';
    
    // Status color mapping
    Color dotColor;
    String statusText;
    switch (asset.status.toLowerCase()) {
      case 'approved':
        dotColor = const Color(0xFF10B981); // Green
        statusText = 'Activo';
        break;
      case 'rejected':
        dotColor = AppPallete.error; // Red
        statusText = 'Rechazado';
        break;
      case 'pending':
      default:
        dotColor = const Color(0xFFF59E0B); // Orange
        statusText = 'Pendiente';
        break;
    }

    final day = asset.createdAt.day;
    final months = const ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    final month = months[asset.createdAt.month - 1];
    final formattedDate = '$day $month';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppPallete.surfaceContainerLowest,
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          border: Border.all(color: AppPallete.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Image Area
            Expanded(
              child: Stack(
                children: [
                  // Image/Video Thumbnail
                  Positioned.fill(
                    child: isVideo
                        ? VideoThumbnailWidget(videoUrl: asset.fileUrl)
                        : Image.network(
                            asset.fileUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppPallete.surfaceContainerLow,
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  color: AppPallete.secondary,
                                  size: 32,
                                ),
                              );
                            },
                          ),
                  ),
                  // Status Badge Overlay
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppPallete.background.withValues(alpha: 0.9),
                        borderRadius: AppRadius.borderFull,
                        border: Border.all(color: AppPallete.outlineVariant.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: AppTypography.labelSm.copyWith(
                              color: AppPallete.onSurface,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Video Play Overlay Indicator
                  if (isVideo)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.1),
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.8),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: AppPallete.primary,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info Footer Area
            Padding(
              padding: const EdgeInsets.all(AppSpacing.stackMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.originalFilename,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelMd.copyWith(
                      color: AppPallete.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    asset.status.toLowerCase() == 'approved'
                        ? 'Aprobado: $formattedDate'
                        : 'Subido: $formattedDate',
                    style: AppTypography.bodySm.copyWith(
                      color: AppPallete.secondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.bar_chart,
                        size: 14,
                        color: AppPallete.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${asset.timesUsed} displays',
                          style: AppTypography.labelSm.copyWith(
                            color: AppPallete.primary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
