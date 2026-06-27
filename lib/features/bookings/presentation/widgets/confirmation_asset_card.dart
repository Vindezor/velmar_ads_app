import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class ConfirmationAssetCard extends StatelessWidget {
  final String originalFilename;
  final String fileType;
  final double fileSizeMb;
  final String fileUrl;

  const ConfirmationAssetCard({
    super.key,
    required this.originalFilename,
    required this.fileType,
    required this.fileSizeMb,
    required this.fileUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bool isVideo = fileType.toLowerCase() == 'video';

    return Container(
      decoration: BoxDecoration(
        color: AppPallete.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
        border: Border.all(color: AppPallete.borderColor),
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
          // Card Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppPallete.surfaceContainerLowest,
              border: Border(
                bottom: BorderSide(color: AppPallete.outlineVariant, width: 1.0),
              ),
            ),
            width: double.infinity,
            child: Text(
              'Creatividad Seleccionada',
              style: AppTypography.labelMd.copyWith(
                color: AppPallete.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ),
          // Card Content
          Container(
            color: AppPallete.surfaceContainerLow,
            padding: const EdgeInsets.all(24.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 450;
                final content = [
                  // Image/Video Preview
                  Container(
                    width: isWide ? 192 : double.infinity,
                    height: 128,
                    decoration: BoxDecoration(
                      color: AppPallete.surfaceVariant,
                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      border: Border.all(color: AppPallete.outlineVariant),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        if (isVideo)
                          Container(
                            color: AppPallete.surfaceVariant,
                            child: const Center(
                              child: Icon(
                                Icons.play_circle_outline,
                                size: 48,
                                color: AppPallete.primary,
                              ),
                            ),
                          )
                        else if (fileUrl.isNotEmpty)
                          Image.network(
                            fileUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppPallete.surfaceVariant,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 48,
                                  color: AppPallete.secondary,
                                ),
                              ),
                            ),
                          )
                        else
                          Container(
                            color: AppPallete.surfaceVariant,
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                size: 48,
                                color: AppPallete.secondary,
                              ),
                            ),
                          ),
                        // Transparent Badge overlay
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                              child: Container(
                                color: AppPallete.primaryContainer.withValues(alpha: 0.8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                child: Text(
                                  fileType.toUpperCase(),
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppPallete.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isWide) const SizedBox(width: AppSpacing.gutter) else const SizedBox(height: 16),
                  // Metadata
                  Expanded(
                    flex: isWide ? 1 : 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          originalFilename.isNotEmpty ? originalFilename : 'N/A',
                          style: AppTypography.bodyLg.copyWith(
                            color: AppPallete.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.file_present,
                              size: 16,
                              color: AppPallete.secondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${fileSizeMb.toStringAsFixed(2)} MB',
                              style: AppTypography.bodySm.copyWith(
                                color: AppPallete.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ];

                return isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: content,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: content,
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
