import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/date_formatter.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/billboard.dart';

class BookingSuccessView extends StatelessWidget {
  final Billboard billboard;
  final DateTime startTime;
  final DateTime endTime;

  const BookingSuccessView({
    super.key,
    required this.billboard,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
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
                Icons.check_circle,
                size: 80,
                color: AppPallete.primaryContainer,
              ),
              const SizedBox(height: AppSpacing.stackLg),

              // Title
              Text(
                '¡Reserva confirmada!',
                style: AppTypography.headlineLg.copyWith(
                  color: AppPallete.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.stackSm),

              // Subtitle
              Text(
                'Tu solicitud ha sido procesada con éxito. La pantalla seleccionada ya está programada para tu campaña.',
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
                child: Column(
                  children: [
                    _buildRow('Pantalla', billboard.name, showBorder: true),
                    _buildRow(
                      'Inicio',
                      DateFormatter.formatSpanishShort(startTime),
                      showBorder: true,
                    ),
                    _buildRow(
                      'Fin',
                      DateFormatter.formatSpanishShort(endTime),
                      showBorder: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Actions
              Column(
                children: [
                  OutlinedButton(
                    onPressed: () => context.go('/bookings'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppPallete.primaryContainer,
                      side: const BorderSide(color: AppPallete.primaryContainer),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                      ),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: Text(
                      'Ver mis reservas',
                      style: AppTypography.labelMd.copyWith(
                        color: AppPallete.primaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  ElevatedButton(
                    onPressed: () => context.go('/dashboard'),
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
                      'Volver al mapa',
                      style: AppTypography.labelMd.copyWith(
                        color: AppPallete.onPrimary,
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

  Widget _buildRow(String label, String value, {required bool showBorder}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(
                bottom: BorderSide(color: AppPallete.borderColor),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSm.copyWith(
              color: AppPallete.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.gutter),
          Expanded(
            child: Text(
              value,
              style: AppTypography.labelMd.copyWith(
                color: AppPallete.textPrimary,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
