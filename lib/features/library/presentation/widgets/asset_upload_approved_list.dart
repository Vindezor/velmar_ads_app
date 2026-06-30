import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/library/domain/entities/creative_asset.dart';
import 'package:velmar_ads/features/library/presentation/bloc/library_bloc.dart';
import 'package:velmar_ads/features/library/presentation/widgets/library_asset_card.dart';

class AssetUploadApprovedList extends StatelessWidget {
  final String? selectedAssetId;
  final ValueChanged<CreativeAsset> onAssetSelected;

  const AssetUploadApprovedList({
    super.key,
    required this.selectedAssetId,
    required this.onAssetSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        return switch (state) {
          LibraryAssetsLoading() || LibraryLoading() => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(color: AppPallete.primary),
              ),
            ),
          LibraryAssetsLoaded(assets: final assets) => _buildList(context, assets),
          LibraryAssetsError(message: final msg) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.gutter),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppPallete.error),
                    const SizedBox(height: 16),
                    Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMd.copyWith(color: AppPallete.error),
                    ),
                  ],
                ),
              ),
            ),
          _ => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(color: AppPallete.primary),
              ),
            ),
        };
      },
    );
  }

  Widget _buildList(BuildContext context, List<CreativeAsset> assets) {
    final approvedAssets = assets;

    if (approvedAssets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off_outlined,
                size: 48,
                color: AppPallete.secondary,
              ),
              const SizedBox(height: 16),
              Text(
                'No tienes anuncios en tu biblioteca.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(
                  color: AppPallete.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sube un nuevo anuncio para comenzar.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppPallete.secondaryFixedDim,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (width >= 1024) {
      crossAxisCount = 4;
    } else if (width >= 600) {
      crossAxisCount = 3;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.gutter,
        mainAxisSpacing: AppSpacing.gutter,
        childAspectRatio: 4 / 6.8,
      ),
      itemCount: approvedAssets.length,
      itemBuilder: (context, index) {
        final asset = approvedAssets[index];
        final isSelected = asset.id == selectedAssetId;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            LibraryAssetCard(
              asset: asset,
              onTap: () => onAssetSelected(asset),
            ),
            if (isSelected) ...[
              // Selection overlay border
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                      border: Border.all(
                        color: AppPallete.primary,
                        width: 3.0,
                      ),
                    ),
                  ),
                ),
              ),
              // Checkmark indicator in top-left
              Positioned(
                top: -6,
                left: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppPallete.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
