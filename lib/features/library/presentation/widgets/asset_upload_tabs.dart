import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class AssetUploadTabs extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTabChanged;

  const AssetUploadTabs({
    super.key,
    required this.activeIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppPallete.borderColor,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          // Tab 0: Upload New / Subir Nuevo
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(0),
              child: Container(
                decoration: BoxDecoration(
                  color: activeIndex == 0
                      ? AppPallete.surfaceContainerLow
                      : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: activeIndex == 0
                          ? AppPallete.primaryContainer
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.stackMd,
                  horizontal: AppSpacing.gutter,
                ),
                child: Text(
                  'Subir Nuevo',
                  textAlign: TextAlign.center,
                  style: AppTypography.labelMd.copyWith(
                    color: activeIndex == 0
                        ? AppPallete.primaryContainer
                        : AppPallete.secondaryFixedDim,
                    fontWeight: activeIndex == 0
                        ? FontWeight.bold
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          // Tab 1: Use Approved / Usar Aprobados
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(1),
              child: Container(
                decoration: BoxDecoration(
                  color: activeIndex == 1
                      ? AppPallete.surfaceContainerLow
                      : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: activeIndex == 1
                          ? AppPallete.primaryContainer
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.stackMd,
                  horizontal: AppSpacing.gutter,
                ),
                child: Text(
                  'Usar Aprobados',
                  textAlign: TextAlign.center,
                  style: AppTypography.labelMd.copyWith(
                    color: activeIndex == 1
                        ? AppPallete.primaryContainer
                        : AppPallete.secondaryFixedDim,
                    fontWeight: activeIndex == 1
                        ? FontWeight.bold
                        : FontWeight.w500,
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
