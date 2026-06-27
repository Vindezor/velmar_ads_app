import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class AssetUploadProgress extends StatelessWidget {
  final double progress;
  final VoidCallback onCancel;

  const AssetUploadProgress({
    super.key,
    required this.progress,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();

    return Container(
      decoration: BoxDecoration(
        color: AppPallete.surfaceContainerLow,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.defaultValue)),
        border: Border.all(color: AppPallete.borderColor),
      ),
      padding: const EdgeInsets.all(AppSpacing.stackMd),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppPallete.surfaceContainerHighest,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
            child: const Icon(
              Icons.movie_outlined,
              color: AppPallete.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.gutter),
          // Progress Bars and Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'campaign_summer_2024.mp4',
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelMd.copyWith(
                          color: AppPallete.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$percentage%',
                      style: AppTypography.labelSm.copyWith(
                        color: AppPallete.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.stackSm),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: AppPallete.surfaceVariant,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppPallete.primaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.gutter),
          // Cancel Icon Button
          IconButton(
            icon: const Icon(
              Icons.close,
              color: AppPallete.onSurfaceVariant,
            ),
            onPressed: onCancel,
            tooltip: 'Cancelar subida',
          ),
        ],
      ),
    );
  }
}
