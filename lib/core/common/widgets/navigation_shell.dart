import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/common/widgets/custom_bottom_nav_bar.dart';
import 'package:velmar_ads/core/router/app_router.dart';

class NavigationShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavigationShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          final bool reset = index == navigationShell.currentIndex || (index == 0 && shouldResetDashboard);
          if (index == 0 && shouldResetDashboard) {
            shouldResetDashboard = false;
          }
          navigationShell.goBranch(
            index,
            initialLocation: reset,
          );
        },
      ),
    );
  }
}
