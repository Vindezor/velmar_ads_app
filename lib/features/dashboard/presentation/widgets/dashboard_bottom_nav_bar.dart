import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class DashboardBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const DashboardBottomNavBar({
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
              _buildNavBarItem(
                context: context,
                index: 0,
                icon: Icons.map,
                label: 'Map',
              ),
              _buildNavBarItem(
                context: context,
                index: 1,
                icon: Icons.calendar_today_outlined,
                label: 'My Bookings',
              ),
              _buildNavBarItem(
                context: context,
                index: 2,
                icon: Icons.folder_open_outlined,
                label: 'Library',
              ),
              _buildNavBarItem(
                context: context,
                index: 3,
                icon: Icons.person_outline,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isActive = index == currentIndex;
    final color = isActive ? AppPallete.primary : AppPallete.secondary;

    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(index);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSm.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
