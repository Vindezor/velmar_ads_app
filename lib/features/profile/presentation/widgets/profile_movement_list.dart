import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/router/app_routes.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/profile/domain/entities/movement.dart';
import 'package:velmar_ads/features/profile/presentation/widgets/profile_movement_item.dart';

class ProfileMovementList extends StatelessWidget {
  final double credits;
  final List<Movement> movements;

  const ProfileMovementList({
    super.key,
    required this.credits,
    required this.movements,
  });

  @override
  Widget build(BuildContext context) {
    if (movements.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        decoration: BoxDecoration(
          color: AppPallete.surfaceContainerLowest,
          borderRadius: AppRadius.borderMd,
          border: Border.all(color: AppPallete.outlineVariant),
        ),
        child: Center(
          child: Text(
            'No tienes movimientos registrados.',
            style: AppTypography.bodyMd.copyWith(
              color: AppPallete.secondary,
            ),
          ),
        ),
      );
    }

    final hasMore = movements.length > 5;
    final displayedMovements = movements.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Historial de movimientos',
          style: AppTypography.headlineMd.copyWith(
            color: AppPallete.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: AppSpacing.stackMd),
        Container(
          decoration: BoxDecoration(
            color: AppPallete.surfaceContainerLowest,
            borderRadius: AppRadius.borderMd,
            border: Border.all(color: AppPallete.outlineVariant),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000), // rgba(0,0,0,0.05)
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayedMovements.length,
                itemBuilder: (context, index) {
                  return ProfileMovementItem(
                    movement: displayedMovements[index],
                    showDivider: hasMore || (index < displayedMovements.length - 1),
                  );
                },
              ),
              if (hasMore)
                InkWell(
                  onTap: () {
                    context.push(
                      AppRoutes.creditHistoryPath(),
                      extra: {
                        'credits': credits,
                        'movements': movements,
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    alignment: Alignment.center,
                    child: Text(
                      'Ver todos los movimientos',
                      style: AppTypography.labelMd.copyWith(
                        color: AppPallete.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
