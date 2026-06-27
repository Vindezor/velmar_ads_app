import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class AssetUploadHeader extends StatelessWidget {
  const AssetUploadHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subida de Asset',
          style: AppTypography.headlineLg.copyWith(
            color: AppPallete.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.stackSm),
        Text(
          'Selecciona el contenido que se mostrará en las pantallas contratadas.',
          style: AppTypography.bodyMd.copyWith(
            color: AppPallete.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
