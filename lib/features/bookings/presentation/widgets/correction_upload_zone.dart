import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

enum CorrectionUploadState { idle, uploading, completed }

class CorrectionUploadZone extends StatelessWidget {
  final CorrectionUploadState state;
  final double progress;
  final String? fileName;
  final VoidCallback onTap;

  const CorrectionUploadZone({
    super.key,
    required this.state,
    required this.progress,
    required this.fileName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: state == CorrectionUploadState.uploading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        decoration: BoxDecoration(
          color: state == CorrectionUploadState.idle
              ? AppPallete.background
              : AppPallete.surfaceContainerLowest,
          borderRadius: AppRadius.borderMd,
          border: Border.all(
            color: state == CorrectionUploadState.completed
                ? AppPallete.primary.withValues(alpha: 0.3)
                : AppPallete.outlineVariant,
            style: state == CorrectionUploadState.completed 
                ? BorderStyle.solid 
                : BorderStyle.solid, // Wait! We can use a custom dashed border in Flutter, or just solid style with color matching outline. Let's make it look clean.
          ),
        ),
        child: switch (state) {
          CorrectionUploadState.idle => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppPallete.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cloud_upload,
                    color: AppPallete.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: AppSpacing.gutter),
                Text(
                  'Arrastra tu archivo aquí',
                  style: AppTypography.labelMd.copyWith(
                    color: AppPallete.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'o haz clic para explorar',
                  style: AppTypography.bodySm.copyWith(
                    color: AppPallete.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'MP4 o JPG. Max 50MB. (1920x1080)',
                  style: AppTypography.labelSm.copyWith(
                    color: AppPallete.secondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          CorrectionUploadState.uploading => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.sync,
                  color: AppPallete.primary,
                  size: 32,
                ),
                const SizedBox(height: AppSpacing.gutter),
                Text(
                  'Subiendo archivo...',
                  style: AppTypography.labelMd.copyWith(
                    color: AppPallete.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppPallete.surfaceContainer,
                    color: AppPallete.primary,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: AppTypography.bodySm.copyWith(
                    color: AppPallete.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          CorrectionUploadState.completed => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9), // Green tint
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
                const SizedBox(height: AppSpacing.gutter),
                Text(
                  'Archivo Cargado Correctamente',
                  style: AppTypography.labelMd.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fileName ?? 'nuevo_material.png',
                  style: AppTypography.bodySm.copyWith(
                    color: AppPallete.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Haz clic para cambiar el archivo',
                  style: AppTypography.labelSm.copyWith(
                    color: AppPallete.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
        },
      ),
    );
  }
}
