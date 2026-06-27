import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/show_snackbar.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;

  const DashboardAppBar({
    super.key,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppPallete.surfaceContainerLowest,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
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
          onPressed: () {
            if (onNotificationTap != null) {
              onNotificationTap!();
            } else {
              showSnackBar(context: context, message: 'No hay notificaciones nuevas');
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
