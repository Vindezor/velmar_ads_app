import 'package:flutter/material.dart';
import 'package:velmar_ads/core/common/user.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class ProfileHeader extends StatelessWidget {
  final User user;

  const ProfileHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    const imageUrl =
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA-fY4wLmtmpCK8w6G65-LrBdhArcNppjvipsHgQHF-GCXA1d8iIE-4qs3ONMXG21idkMbpFLK82qVJMAwBXwoDmpMPNyM_VThWjcS5fdNNkSbAXMsJonRz51Zsob48Fp1XaRH2DGz-0SCPS4rZu5IJvTnty0knZ5iXc7WqAu-FnxkiPppMUEhwET-CF--r7YKOCzLT1baOVXfI2LbNGVfspP8z8jhi8qPaihTkez9S838JTc9fVBXkwktLkbfJWEsSDz2cAdBBf0w';

    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
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
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.person,
              color: AppPallete.secondary,
              size: 32,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.gutter),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.name,
                style: AppTypography.headlineMd.copyWith(
                  color: AppPallete.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                user.email,
                style: AppTypography.bodyMd.copyWith(
                  color: AppPallete.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
