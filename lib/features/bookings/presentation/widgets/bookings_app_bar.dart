import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/router/app_routes.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class BookingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;

  const BookingsAppBar({
    super.key,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppPallete.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppPallete.primary),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  context.go(AppRoutes.dashboard);
                }
              },
            )
          : null,
      title: Text(
        'Velmar Ads',
        style: AppTypography.headlineMd.copyWith(
          color: AppPallete.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: AppPallete.primary),
          onPressed: () {},
        ),
        const SizedBox(width: AppSpacing.gutter),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: AppPallete.outlineVariant,
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}
