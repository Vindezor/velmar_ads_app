import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class AssetUploadPreview extends StatelessWidget {
  const AssetUploadPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppPallete.borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Simulated Digital Out of Home Ad Asset Preview
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDY0w3KW2MBy0AEYCjjQn92MQVdy-tETVgM-QMKfdGbpJLYz2QSCfnO4jx71zptYuQlyj-hWmg2Y92DP4LDVH_capKE6qMu0iodkV4WogjUeb02ryVaVIHjQjQ_VCgrvM972XpgbjHYOcmXTxPQfG6IMAM2ma36oZJuOSp3b0MgnKZxgfy0faZpfKKMy0kRuthlfFnNsZ45dQwzlXX-FPaW0mlLEIFLV6DBBXT8AwlOckA78ltbhH4fY7vazPr-GBcAtbY64FrDNJk',
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: double.infinity,
                height: 250,
                color: AppPallete.surfaceContainerHigh,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 250,
                color: AppPallete.surfaceContainerHigh,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      size: 48,
                      color: AppPallete.onSurfaceVariant,
                    ),
                    SizedBox(height: AppSpacing.stackSm),
                    Text(
                      'No se pudo cargar la vista previa',
                      style: TextStyle(color: AppPallete.textSecondary),
                    ),
                  ],
                ),
              );
            },
          ),
          // Format Badge/Insignia in Top-Right
          Positioned(
            top: 12,
            right: 12,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: Container(
                  color: AppPallete.surface.withValues(alpha: 0.8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.movie_outlined,
                        size: 14,
                        color: AppPallete.onSurface,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'MP4',
                        style: AppTypography.labelSm.copyWith(
                          color: AppPallete.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
