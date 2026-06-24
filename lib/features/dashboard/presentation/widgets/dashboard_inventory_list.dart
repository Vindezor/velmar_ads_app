import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/billboard.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/billboard_card.dart';

class DashboardInventoryList extends StatelessWidget {
  final List<Billboard> billboards;
  final ValueChanged<Billboard>? onBillboardTap;

  const DashboardInventoryList({
    super.key,
    required this.billboards,
    this.onBillboardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Nearby Inventory',
                style: AppTypography.labelMd.copyWith(
                  color: AppPallete.onSurface,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                '${billboards.length} Screens found',
                style: AppTypography.bodySm.copyWith(
                  color: AppPallete.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Inventory List
          if (billboards.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Text(
                  'No hay pantallas disponibles en esta zona.',
                  style: AppTypography.bodyMd.copyWith(
                    color: AppPallete.textSecondary,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: billboards.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final billboard = billboards[index];
                return BillboardCard(
                  billboard: billboard,
                  onTap: () {
                    if (onBillboardTap != null) {
                      onBillboardTap!(billboard);
                    }
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
