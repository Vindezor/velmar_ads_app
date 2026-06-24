import 'package:flutter/material.dart';
import 'package:velmar_ads/core/common/widgets/custom_nav_bar_item.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CustomBottomNavBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppPallete.background,
        border: Border(
          top: BorderSide(
            color: AppPallete.borderColor.withValues(alpha: 0.5),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomNavBarItem(
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.map,
                label: 'Map',
                onTap: () => onTap?.call(0),
              ),
              CustomNavBarItem(
                index: 1,
                currentIndex: currentIndex,
                icon: Icons.calendar_today_outlined,
                label: 'My Bookings',
                onTap: () => onTap?.call(1),
              ),
              CustomNavBarItem(
                index: 2,
                currentIndex: currentIndex,
                icon: Icons.folder_open_outlined,
                label: 'Library',
                onTap: () => onTap?.call(2),
              ),
              CustomNavBarItem(
                index: 3,
                currentIndex: currentIndex,
                icon: Icons.person_outline,
                label: 'Profile',
                onTap: () => onTap?.call(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
