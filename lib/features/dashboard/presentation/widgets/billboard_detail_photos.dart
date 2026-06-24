import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class BillboardDetailPhotos extends StatelessWidget {
  const BillboardDetailPhotos({super.key});

  static const String _streetViewUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBziUAW1pc8r3WB9NyBmBNh_f2VAwl5ctgiP6BKSbKjbi2w4-tzjnNcpHLEvF3bx_-nQqFDAFSApu9BA2o1ti3vZvrm41YctgWMMH77dx83UkKp_X_15v4vqgttrMNay69nvjrwDakLiDEf7mumrRmMgRdkp59bxIG0Fzh92cEvkV9Tgz6r1p9udbfWZgkJ7yydranYAxS-PklkRzPn36pfLwB_jjDKYJv38Z7BaDt6nSW6_VZMfq8wapO3cmDUELICs1g3xrrBEMY';

  static const String _trafficViewUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuANgakdb73F4hj9mPa2TrN-ak0Dz75QfgXWA5mIf7kAXLnWsntw2Uithp4VMDnZMcUH9svoYHkCK7VrN40EjHSAYlhhdLIWKK-fu429aSLp4tsp1pEX8odFkceAq12KftqegLrujVTMiVsyw-TQQo87VSxQb_HVXk82NDaOhuF1MG84mJR7ucwYX1C3Wi60TkC9zZqFsRv-TiMlOz34exn7yuY_tdT8FTraISxfuUCBHJQ-WXOkebfdNIYMyqh2xGUSgwe9QAP5e60';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
        children: const [
          StreetPhotoCard(
            imageUrl: _streetViewUrl,
            fallbackLabel: 'Street View',
          ),
          SizedBox(width: 12),
          StreetPhotoCard(
            imageUrl: _trafficViewUrl,
            fallbackLabel: 'Traffic View',
          ),
          SizedBox(width: 12),
          MapLocationCard(),
        ],
      ),
    );
  }
}

class StreetPhotoCard extends StatelessWidget {
  final String imageUrl;
  final String fallbackLabel;

  const StreetPhotoCard({
    super.key,
    required this.imageUrl,
    required this.fallbackLabel,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.borderMd,
          border: Border.all(color: AppPallete.borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                fallbackLabel,
                style: AppTypography.bodySm.copyWith(color: AppPallete.secondary),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MapLocationCard extends StatelessWidget {
  const MapLocationCard({super.key});

  static const String _mapLocationUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBgWREd_dw9DWus9iPKaCvrSgKyyw3cFT3qfe4JXZH3t6KCDY0GeEv-P1OO5t1CgDcEofOsqSFOH8outdz2yZK8N6f0DeXymbu9QIDK8kWrf3LI9zvi0jCT9F8bBkav2PGzCt5TzDSmpT2yoBf0uJHgs3GGzkzMHl9Zpgc-V1r9vYRv-26unfBsEkD05lkLkrJD4GVsrwvf7_a9-p9Uk4BeJrQG0UNEJIcIFyHBRTPsLpULg-pje1yCtj75hu4MR8welmsyPr63IGY';

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: AppRadius.borderMd,
                border: Border.all(color: AppPallete.borderColor),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                _mapLocationUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.map_outlined));
                },
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                borderRadius: AppRadius.borderMd,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppPallete.primaryFixed,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.pin_drop,
                color: AppPallete.onPrimaryFixed,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
