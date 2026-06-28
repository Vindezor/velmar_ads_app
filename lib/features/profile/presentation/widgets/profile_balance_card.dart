import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/router/app_routes.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/currency_formatter.dart';
import 'package:velmar_ads/features/profile/presentation/bloc/profile_bloc.dart';

class ProfileBalanceCard extends StatelessWidget {
  final double credits;

  const ProfileBalanceCard({
    super.key,
    required this.credits,
  });

  @override
  Widget build(BuildContext context) {
    final formattedBalance = CurrencyFormatter.format(credits).replaceAll('.00', '');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      decoration: BoxDecoration(
        color: AppPallete.surfaceContainerLowest,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppPallete.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative background element
          Positioned(
            right: -32,
            top: -32,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: AppPallete.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SALDO ACTUAL',
                style: AppTypography.labelMd.copyWith(
                  color: AppPallete.secondary,
                  letterSpacing: 1.5,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: AppSpacing.stackSm),
              Text(
                formattedBalance,
                style: AppTypography.displayLg.copyWith(
                  color: AppPallete.onSurface,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: AppSpacing.stackLg),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    context.push(AppRoutes.requestCreditsPath()).then((_) {
                      if (context.mounted) {
                        context.read<ProfileBloc>().add(ProfileLoadDetails());
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppPallete.primaryContainer),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.borderMd,
                    ),
                  ),
                  child: Text(
                    'SOLICITAR CRÉDITOS',
                    style: AppTypography.labelMd.copyWith(
                      color: AppPallete.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
