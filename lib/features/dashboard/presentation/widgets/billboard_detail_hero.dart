import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class BillboardDetailHero extends StatelessWidget {
  final String imageUrl;

  const BillboardDetailHero({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: AppPallete.surfaceVariant,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.image_outlined,
                color: AppPallete.outline,
                size: 48,
              ),
            );
          },
        ),
      ),
    );
  }
}
