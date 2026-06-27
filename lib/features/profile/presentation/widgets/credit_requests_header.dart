import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/currency_formatter.dart';

class CreditRequestsHeader extends StatelessWidget {
  final double totalPending;

  const CreditRequestsHeader({
    super.key,
    required this.totalPending,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPending = CurrencyFormatter.format(totalPending).replaceAll('.00', '');
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 768;
        
        final titleAndDescription = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Mis Solicitudes de Crédito',
              style: isWide 
                  ? AppTypography.headlineLg.copyWith(color: AppPallete.onSurface)
                  : AppTypography.headlineLgMobile.copyWith(color: AppPallete.onSurface),
            ),
            const SizedBox(height: AppSpacing.stackSm),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(
                'Historial y estado de tus aplicaciones para líneas de crédito en campañas DOOH.',
                style: AppTypography.bodyMd.copyWith(
                  color: AppPallete.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );

        final statCard = Container(
          constraints: const BoxConstraints(minWidth: 240),
          padding: const EdgeInsets.all(AppSpacing.stackMd),
          decoration: BoxDecoration(
            color: AppPallete.surface,
            border: Border.all(color: AppPallete.outlineVariant),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000), // rgba(0,0,0,0.05)
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppPallete.tertiaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pending_actions,
                  color: AppPallete.onTertiaryFixedVariant,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.stackMd),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'TOTAL PENDIENTE',
                    style: AppTypography.labelSm.copyWith(
                      color: AppPallete.secondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        formattedPending,
                        style: AppTypography.headlineMd.copyWith(
                          color: AppPallete.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '.00',
                        style: AppTypography.bodySm.copyWith(
                          color: AppPallete.secondary,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );

        return Container(
          padding: const EdgeInsets.only(bottom: AppSpacing.stackLg),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppPallete.outlineVariant),
            ),
          ),
          child: isWide 
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: titleAndDescription),
                    const SizedBox(width: AppSpacing.stackLg),
                    statCard,
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    titleAndDescription,
                    const SizedBox(height: AppSpacing.stackLg),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: statCard,
                    ),
                  ],
                ),
        );
      },
    );
  }
}
