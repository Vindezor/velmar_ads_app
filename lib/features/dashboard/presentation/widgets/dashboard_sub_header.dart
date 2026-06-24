import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/currency_formatter.dart';
import 'package:velmar_ads/core/utils/show_snackbar.dart';

class DashboardSubHeader extends StatelessWidget {
  final double userBalance;

  const DashboardSubHeader({
    super.key,
    required this.userBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerPadding,
        vertical: AppSpacing.stackMd,
      ),
      decoration: BoxDecoration(
        color: AppPallete.background,
        border: Border(
          bottom: BorderSide(
            color: AppPallete.borderColor.withValues(alpha: 0.5),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Balance info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Balance',
                style: AppTypography.bodySm.copyWith(
                  color: AppPallete.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(userBalance),
                style: AppTypography.headlineMd.copyWith(
                  color: AppPallete.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // Map/List Segmented Toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppPallete.surfaceContainer,
              borderRadius: AppRadius.borderDefault,
              border: Border.all(
                color: AppPallete.borderColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                // Map Button (disabled style)
                InkWell(
                  onTap: () {
                    showSnackBar(
                      context: context,
                      message: 'Mapa deshabilitado temporalmente',
                    );
                  },
                  borderRadius: AppRadius.borderSm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.map_outlined,
                          size: 18,
                          color: AppPallete.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Map',
                          style: AppTypography.labelMd.copyWith(
                            color: AppPallete.onSurfaceVariant,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // List Button (active style)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppPallete.surfaceContainerLowest,
                    borderRadius: AppRadius.borderSm,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.format_list_bulleted,
                        size: 18,
                        color: AppPallete.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'List',
                        style: AppTypography.labelMd.copyWith(
                          color: AppPallete.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
