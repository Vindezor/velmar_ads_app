import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/billboard.dart';

class BillboardCard extends StatelessWidget {
  final Billboard billboard;
  final VoidCallback? onTap;

  const BillboardCard({
    super.key,
    required this.billboard,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a mock distance based on ID or lat/lng for visual simulation
    final distance = (billboard.lat.abs() % 3 + 0.1).toStringAsFixed(1);
    final isWalk = billboard.pricePerHour > 100; // Simulate walk vs car distance icon

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderLg,
        side: const BorderSide(
          color: AppPallete.borderColor,
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 120,
          child: Row(
            children: [
              // Left Image Column
              SizedBox(
                width: 100,
                child: Stack(
                  children: [
                    // Billboard image
                    Positioned.fill(
                      child: Image.network(
                        billboard.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback container if network image fails
                          return Container(
                            color: AppPallete.surfaceContainerHigh,
                            child: const Icon(
                              Icons.image_outlined,
                              color: AppPallete.outline,
                            ),
                          );
                        },
                      ),
                    ),
                    // Status indicator dot (green = active/available, yellow = in use/maintenance)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: billboard.isActive
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFFFC107),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppPallete.surfaceContainerLowest,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Right Details Column
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.stackMd),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Location
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            billboard.name,
                            style: AppTypography.labelMd.copyWith(
                              color: AppPallete.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: AppPallete.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  billboard.address,
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppPallete.onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Bottom Info Row: [Badge + Distance] & [Price]
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Badge & Distance
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: billboard.screenClassLabel.contains('A')
                                      ? AppPallete.primaryFixed
                                      : AppPallete.secondaryContainer,
                                  borderRadius: AppRadius.borderSm,
                                  border: Border.all(
                                    color: billboard.screenClassLabel.contains('A')
                                        ? AppPallete.primaryFixedDim
                                        : AppPallete.borderColor,
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  billboard.screenClassLabel,
                                  style: AppTypography.labelSm.copyWith(
                                    color: billboard.screenClassLabel.contains('A')
                                        ? AppPallete.onPrimaryFixedVariant
                                        : AppPallete.onSecondaryContainer,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  Icon(
                                    isWalk ? Icons.directions_walk : Icons.directions_car,
                                    size: 14,
                                    color: AppPallete.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '$distance mi',
                                    style: AppTypography.bodySm.copyWith(
                                      color: AppPallete.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Price Column
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: billboard.isActive
                                ? [
                                    Text(
                                      '\$${billboard.pricePerHour.toStringAsFixed(2)}',
                                      style: AppTypography.labelMd.copyWith(
                                        color: AppPallete.primaryContainer,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '/ hour',
                                      style: AppTypography.bodySm.copyWith(
                                        color: AppPallete.onSurfaceVariant,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ]
                                : [
                                    Text(
                                      '\$${billboard.pricePerHour.toStringAsFixed(2)}',
                                      style: AppTypography.labelMd.copyWith(
                                        color: AppPallete.onSurfaceVariant,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Text(
                                      'In Use',
                                      style: TextStyle(
                                        color: AppPallete.error,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
