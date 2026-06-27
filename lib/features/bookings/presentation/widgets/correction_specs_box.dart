import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class CorrectionSpecsBox extends StatelessWidget {
  const CorrectionSpecsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.stackMd),
      decoration: BoxDecoration(
        color: AppPallete.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppPallete.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ESPECIFICACIONES TÉCNICAS',
            style: AppTypography.labelSm.copyWith(
              color: AppPallete.onSurfaceVariant,
              letterSpacing: 1.2,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.stackMd),
          Column(
            children: [
              _buildBullet('Resolución: 1920x1080px (Landscape)'),
              const SizedBox(height: 8),
              _buildBullet('Duración: Máx 10 segundos (si es video)'),
              const SizedBox(height: 8),
              _buildBullet('Sin audio'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle,
          color: AppPallete.primary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySm.copyWith(
              color: AppPallete.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
