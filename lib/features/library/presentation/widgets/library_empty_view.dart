import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/router/app_routes.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class LibraryEmptyView extends StatelessWidget {
  const LibraryEmptyView({super.key});

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
            // Empty State Illustration
            Container(
              constraints: const BoxConstraints(maxWidth: 240),
              margin: const EdgeInsets.only(bottom: AppSpacing.stackLg),
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAl_HuUAaRvwLUTdjZRiBspKR6FCm4EoKPMfrlmw8_tKscqHUG7maSI17vFTvR7C6O1jAknzxXTImwzeHzfaFVjuZmCBfvhjFEhGvwhyzNVR0Lhi7MuaiW9IK5cl6aXDP-XELO9hHaeT9XomUoYnn2x1WfKGynkTfIn54sQzGcDluVaK-An0nHpvLZYuU4ppvnIOtg5LT6K57AcF65FflAnU6rfdMN-DOxciQj7delknJAmvpQoMLFPAO9ePGF31FJJUWC4NG1VAlA',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.folder_open_outlined,
                    size: 96,
                    color: AppPallete.secondary,
                  );
                },
              ),
            ),
            // Title
            Text(
              'No tienes anuncios aprobados',
              textAlign: TextAlign.center,
              style: AppTypography.headlineMd.copyWith(
                color: AppPallete.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            // Subtitle
            Container(
              constraints: const BoxConstraints(maxWidth: 320),
              margin: const EdgeInsets.only(bottom: 32),
              child: Text(
                'Sube tu primer anuncio al hacer una reserva',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(
                  color: AppPallete.secondary,
                ),
              ),
            ),
            // Action Button
            ElevatedButton(
              onPressed: () {
                try {
                  StatefulNavigationShell.of(context).goBranch(0);
                } catch (_) {
                  context.go(AppRoutes.dashboard);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Ir al mapa',
                style: AppTypography.labelMd.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppPallete.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
