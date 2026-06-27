import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class BillboardDetailSpecs extends StatelessWidget {
  final int? resolutionW;
  final int? resolutionH;
  final List<String> acceptedFormats;
  final int? maxFileSizeMb;

  const BillboardDetailSpecs({
    super.key,
    this.resolutionW,
    this.resolutionH,
    required this.acceptedFormats,
    this.maxFileSizeMb,
  });

  @override
  Widget build(BuildContext context) {
    final resolutionText = (resolutionW != null && resolutionH != null)
        ? '$resolutionW x $resolutionH px'
        : 'N/A';

    // Format list mapping (e.g. video/mp4 -> MP4, image/jpeg -> JPG, image/png -> PNG)
    final formats = acceptedFormats.map((mime) {
      final clean = mime.toLowerCase();
      if (clean.contains('mp4')) return 'MP4';
      if (clean.contains('jpeg') || clean.contains('jpg')) return 'JPG';
      if (clean.contains('png')) return 'PNG';
      return clean.split('/').last.toUpperCase();
    }).toSet().join(', ');

    final maxFileSizeText = maxFileSizeMb != null ? '$maxFileSizeMb MB' : 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Especificaciones Técnicas',
            style: AppTypography.headlineMd.copyWith(
              color: AppPallete.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppPallete.surfaceContainerLowest,
              borderRadius: AppRadius.borderMd,
              border: Border.all(color: AppPallete.borderColor),
            ),
            child: Column(
              children: [
                SpecListItem(
                  icon: Icons.aspect_ratio_outlined,
                  label: 'Resolución',
                  value: resolutionText,
                  showDivider: true,
                ),
                SpecListItem(
                  icon: Icons.video_file_outlined,
                  label: 'Formatos Soportados',
                  value: formats.isNotEmpty ? formats : 'N/A',
                  showDivider: true,
                ),
                SpecListItem(
                  icon: Icons.insert_drive_file_outlined,
                  label: 'Tamaño Máximo de Archivo',
                  value: maxFileSizeText,
                  showDivider: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SpecListItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  const SpecListItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppPallete.secondary, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: AppTypography.bodyMd.copyWith(
                      color: AppPallete.secondary,
                    ),
                  ),
                ],
              ),
              Text(
                value,
                style: AppTypography.labelMd.copyWith(
                  color: AppPallete.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: AppPallete.borderColor,
          ),
      ],
    );
  }
}
