import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class AssetUploadDropzone extends StatelessWidget {
  final VoidCallback onUploadTriggered;

  const AssetUploadDropzone({
    super.key,
    required this.onUploadTriggered,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onUploadTriggered,
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
      child: CustomPaint(
        painter: DashedRectPainter(
          color: AppPallete.outlineVariant,
          strokeWidth: 2.0,
          dashLength: 8.0,
          gap: 6.0,
          borderRadius: AppRadius.lg,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 40.0,
            horizontal: AppSpacing.containerPadding,
          ),
          decoration: const BoxDecoration(
            color: AppPallete.surfaceBright,
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cloud Upload Icon
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppPallete.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
                  color: AppPallete.onSurfaceVariant,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppSpacing.stackLg),
              // Heading
              Text(
                'Arrastra tu archivo aquí',
                style: AppTypography.headlineMd.copyWith(
                  color: AppPallete.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.stackSm),
              // Supported formats
              Text(
                'Formatos soportados: JPG, PNG, MP4. Max 50MB.',
                style: AppTypography.bodySm.copyWith(
                  color: AppPallete.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.stackLg),
              // Explore files button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.primaryContainer,
                  foregroundColor: AppPallete.onPrimary,
                  minimumSize: const Size(180, 48),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                  ),
                  elevation: 0,
                ),
                onPressed: onUploadTriggered,
                child: Text(
                  'Explorar archivos',
                  style: AppTypography.labelMd.copyWith(
                    color: AppPallete.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.dashLength,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(
          strokeWidth / 2,
          strokeWidth / 2,
          size.width - strokeWidth,
          size.height - strokeWidth,
        ),
        Radius.circular(borderRadius),
      ));

    final dashPath = Path();
    double distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashLength),
          Offset.zero,
        );
        distance += dashLength + gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.borderRadius != borderRadius;
  }
}
