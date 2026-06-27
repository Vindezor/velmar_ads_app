import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class ConfirmationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ConfirmationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppPallete.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppPallete.primary,
        ),
        onPressed: () => context.pop(),
      ),
      centerTitle: true,
      title: Text(
        'Velmar Ads',
        style: AppTypography.headlineMd.copyWith(
          color: AppPallete.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none,
            color: AppPallete.primary,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: AppSpacing.base),
      ],
      shape: const Border(
        bottom: BorderSide(
          color: AppPallete.outlineVariant,
          width: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
