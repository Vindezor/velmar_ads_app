import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/library/presentation/bloc/library_bloc.dart';

class AssetUploadPreview extends StatelessWidget {
  const AssetUploadPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final libraryState = context.read<LibraryBloc>().state;
    String fileUrl = '';
    String fileType = 'image';
    String originalFilename = 'Vista previa';

    if (libraryState is LibraryUploadSuccess) {
      fileUrl = libraryState.asset.fileUrl;
      fileType = libraryState.asset.fileType;
      originalFilename = libraryState.asset.originalFilename;
    }

    final isVideo = fileType == 'video';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppPallete.borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (isVideo)
            Container(
              width: double.infinity,
              height: 250,
              color: const Color(0xFF121212),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.play_circle_fill,
                    size: 64,
                    color: Colors.white70,
                  ),
                  Positioned(
                    bottom: 24,
                    child: Text(
                      originalFilename,
                      style: AppTypography.bodySm.copyWith(
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          else
            Image.network(
              fileUrl,
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
                      Icon(
                        isVideo ? Icons.movie_outlined : Icons.image_outlined,
                        size: 14,
                        color: AppPallete.onSurface,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        fileType.toUpperCase(),
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
