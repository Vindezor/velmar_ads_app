import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/router/app_routes.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class BookingsEmptyView extends StatelessWidget {
  const BookingsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.containerPadding,
          vertical: AppSpacing.stackLg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Minimalist Calendar Illustration Container
            SizedBox(
              width: 192,
              height: 192,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Background structural grid hints
                  Opacity(
                    opacity: 0.05,
                    child: GridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        16,
                        (index) => Container(
                          decoration: BoxDecoration(
                            color: AppPallete.primaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Central Icon Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppPallete.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppPallete.outlineVariant),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000), // rgba(0,0,0,0.05)
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.calendar_month,
                      size: 64,
                      color: AppPallete.outline,
                    ),
                  ),
                  // Decorative floating dot
                  Positioned(
                    top: 32,
                    right: 32,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppPallete.outlineVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Typography
            Text(
              'Aún no tienes reservas',
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppPallete.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.stackMd),
            Text(
              'Explora el mapa y encuentra la pantalla perfecta para tu marca',
              style: AppTypography.bodyMd.copyWith(
                color: AppPallete.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.stackLg),
            // Call to Action Button
            ElevatedButton.icon(
              onPressed: () {
                context.go(AppRoutes.dashboard);
              },
              icon: const Icon(
                Icons.explore,
                size: 20,
                color: AppPallete.onPrimary,
              ),
              label: Text(
                'Explorar mapa',
                style: AppTypography.labelMd.copyWith(
                  color: AppPallete.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPallete.primary,
                foregroundColor: AppPallete.onPrimary,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.borderMd,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
