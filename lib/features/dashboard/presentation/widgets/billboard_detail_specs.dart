import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class BillboardDetailSpecs extends StatelessWidget {
  final int? resolutionW;
  final int? resolutionH;
  final List<String> acceptedFormats;

  const BillboardDetailSpecs({
    super.key,
    this.resolutionW,
    this.resolutionH,
    required this.acceptedFormats,
  });

  @override
  Widget build(BuildContext context) {
    final resolutionText = (resolutionW != null && resolutionH != null)
        ? '$resolutionW x $resolutionH px'
        : '1920 x 1080 px';

    // Format list mapping (e.g. video/mp4 -> MP4, image/jpeg -> JPG, image/png -> PNG)
    final formats = acceptedFormats.map((mime) {
      final clean = mime.toLowerCase();
      if (clean.contains('mp4')) return 'MP4';
      if (clean.contains('jpeg') || clean.contains('jpg')) return 'JPG';
      if (clean.contains('png')) return 'PNG';
      return clean.split('/').last.toUpperCase();
    }).toSet().join(', ');

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
                  value: formats.isNotEmpty ? formats : 'MP4, JPG, PNG',
                  showDivider: true,
                ),
                const SpecListItem(
                  icon: Icons.timer_outlined,
                  label: 'Duración de Loop',
                  value: '10 Segundos',
                  showDivider: true,
                ),
                const SpecListItem(
                  icon: Icons.wb_sunny_outlined,
                  label: 'Brillo',
                  value: '8,000 Nits (Auto)',
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
