import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class BookingsHeader extends StatelessWidget {
  final VoidCallback? onFilterPressed;
  final String activeFilter;

  const BookingsHeader({
    super.key,
    this.onFilterPressed,
    this.activeFilter = 'todos',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.stackLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Mis Reservas',
                  style: AppTypography.headlineLg.copyWith(
                    color: AppPallete.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gestiona el estado de tus campañas DOOH.',
                  style: AppTypography.bodyMd.copyWith(
                    color: AppPallete.secondary,
                  ),
                ),
              ],
            ),
          ),
          if (onFilterPressed != null) ...[
            const SizedBox(width: AppSpacing.gutter),
            OutlinedButton.icon(
              onPressed: onFilterPressed,
              icon: const Icon(
                Icons.filter_list,
                size: 20,
                color: AppPallete.onSurface,
              ),
              label: Text(
                activeFilter == 'todos'
                    ? 'Filtrar'
                    : 'Filtro: ${activeFilter[0].toUpperCase()}${activeFilter.substring(1)}',
                style: AppTypography.labelMd.copyWith(
                  color: AppPallete.onSurface,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppPallete.outlineVariant),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.borderDefault,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
