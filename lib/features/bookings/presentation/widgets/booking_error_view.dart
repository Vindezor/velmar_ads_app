import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';

class BookingErrorView extends StatelessWidget {
  final String errorMessage;
  final double currentBalance;
  final double totalCredits;
  final VoidCallback onRetry;

  const BookingErrorView({
    super.key,
    required this.errorMessage,
    required this.currentBalance,
    required this.totalCredits,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isBalanceError = errorMessage.toLowerCase().contains('crédito') ||
        errorMessage.toLowerCase().contains('saldo') ||
        errorMessage.toLowerCase().contains('insuficiente') ||
        errorMessage.toLowerCase().contains('credits') ||
        errorMessage.toLowerCase().contains('balance');

    final title = isBalanceError ? 'Saldo insuficiente' : 'Reserva fallida';
    final subtitle = isBalanceError
        ? 'No dispones de los créditos necesarios para completar esta reserva. Por favor, recarga tu cuenta para continuar.'
        : errorMessage;

    // Helper to format credits nicely
    String formatCredits(double value) {
      final parts = value.toStringAsFixed(0);
      final buffer = StringBuffer();
      int count = 0;
      for (int i = parts.length - 1; i >= 0; i--) {
        buffer.write(parts[i]);
        count++;
        if (count == 3 && i > 0) {
          buffer.write(',');
          count = 0;
        }
      }
      final reversed = buffer.toString().split('').reversed.join('');
      return '\$$reversed';
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          decoration: BoxDecoration(
            color: AppPallete.surfaceContainerLowest,
            borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
            border: Border.all(color: AppPallete.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              const Icon(
                Icons.error,
                size: 80,
                color: AppPallete.error,
              ),
              const SizedBox(height: AppSpacing.stackLg),

              // Title
              Text(
                title,
                style: AppTypography.headlineLg.copyWith(
                  color: AppPallete.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.stackSm),

              // Subtitle
              Text(
                subtitle,
                style: AppTypography.bodySm.copyWith(
                  color: AppPallete.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Info card
              Container(
                decoration: BoxDecoration(
                  color: AppPallete.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(AppRadius.defaultValue)),
                  border: Border.all(color: AppPallete.borderColor),
                ),
                padding: const EdgeInsets.all(AppSpacing.containerPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Costo de reserva'.toUpperCase(),
                          style: AppTypography.labelSm.copyWith(
                            color: AppPallete.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.stackSm),
                        Text(
                          formatCredits(totalCredits),
                          style: AppTypography.headlineMd.copyWith(
                            color: AppPallete.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Saldo actual'.toUpperCase(),
                          style: AppTypography.labelSm.copyWith(
                            color: AppPallete.error,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.stackSm),
                        Text(
                          formatCredits(currentBalance),
                          style: AppTypography.headlineMd.copyWith(
                            color: AppPallete.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Actions
              Column(
                children: [
                  if (isBalanceError)
                    ElevatedButton(
                      onPressed: () => context.go('/profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.primaryContainer,
                        foregroundColor: AppPallete.onPrimary,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                        ),
                        minimumSize: const Size.fromHeight(48),
                        elevation: 0,
                      ),
                      child: Text(
                        'Solicitar créditos',
                        style: AppTypography.labelMd.copyWith(
                          color: AppPallete.onPrimary,
                        ),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: onRetry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.primaryContainer,
                        foregroundColor: AppPallete.onPrimary,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                        ),
                        minimumSize: const Size.fromHeight(48),
                        elevation: 0,
                      ),
                      child: Text(
                        'Intentar de nuevo',
                        style: AppTypography.labelMd.copyWith(
                          color: AppPallete.onPrimary,
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.stackMd),
                  TextButton(
                    onPressed: () => context.go('/dashboard'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppPallete.secondary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                      ),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: Text(
                      'Volver al mapa',
                      style: AppTypography.labelMd.copyWith(
                        color: AppPallete.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
