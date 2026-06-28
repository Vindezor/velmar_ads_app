import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/currency_formatter.dart';
import 'package:velmar_ads/features/profile/domain/entities/credit_request.dart';
import 'package:velmar_ads/features/profile/presentation/widgets/rejection_reason_dialog.dart';

class CreditRequestCard extends StatelessWidget {
  final CreditRequest request;

  const CreditRequestCard({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final status = request.status.toLowerCase();
    
    // Status specific configuration
    final Color topStripeColor;
    final Color badgeBg;
    final Color badgeText;
    final Color badgeBorder;
    final IconData badgeIcon;
    final String badgeLabel;

    switch (status) {
      case 'approved':
        topStripeColor = AppPallete.primaryContainer;
        badgeBg = AppPallete.primaryFixed;
        badgeText = AppPallete.onPrimaryFixedVariant;
        badgeBorder = AppPallete.primaryFixedDim;
        badgeIcon = Icons.check_circle_outline;
        badgeLabel = 'Aprobado';
        break;
      case 'rejected':
        topStripeColor = AppPallete.error;
        badgeBg = AppPallete.errorContainer.withValues(alpha: 0.2);
        badgeText = AppPallete.error;
        badgeBorder = AppPallete.errorContainer;
        badgeIcon = Icons.cancel_outlined;
        badgeLabel = 'Rechazado';
        break;
      case 'pending':
      default:
        topStripeColor = AppPallete.tertiaryFixedDim;
        badgeBg = AppPallete.tertiaryFixed.withValues(alpha: 0.2);
        badgeText = AppPallete.onTertiaryFixedVariant;
        badgeBorder = AppPallete.tertiaryFixed.withValues(alpha: 0.3);
        badgeIcon = Icons.schedule_outlined;
        badgeLabel = 'Pendiente';
        break;
    }

    final formattedAmount = CurrencyFormatter.format(request.creditsRequested);
    final dateStr = _formatDate(request.createdAt);

    return Container(
      decoration: BoxDecoration(
        color: AppPallete.surfaceContainerLowest,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppPallete.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0, 0, 0, 0.05)
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Top stripe indicator
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              color: topStripeColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.containerPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 4), // Spacing for top stripe
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.orderNumber,
                            style: AppTypography.labelSm.copyWith(
                              color: AppPallete.secondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedAmount,
                            style: AppTypography.headlineMd.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppPallete.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.gutter),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.stackMd,
                        vertical: AppSpacing.stackSm,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        border: Border.all(color: badgeBorder),
                        borderRadius: AppRadius.borderFull,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            badgeIcon,
                            size: 14,
                            color: badgeText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            badgeLabel,
                            style: AppTypography.labelSm.copyWith(
                              color: badgeText,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.gutter),
                // Date Row
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: AppPallete.secondary,
                    ),
                    const SizedBox(width: AppSpacing.base),
                    Text(
                      dateStr,
                      style: AppTypography.bodySm.copyWith(
                        color: AppPallete.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.gutter),
                const Divider(color: AppPallete.outlineVariant, height: 1),
                const SizedBox(height: AppSpacing.stackMd),
                // Footer (Campaign details or Action button)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        request.paymentNotes ?? 'Campaña sin notas específicas',
                        style: AppTypography.labelMd.copyWith(
                          color: AppPallete.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (status == 'rejected') ...[
                      const SizedBox(width: AppSpacing.gutter),
                      InkWell(
                        onTap: () => _showRejectionReason(context),
                        borderRadius: AppRadius.borderSm,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Ver motivo',
                                style: AppTypography.labelMd.copyWith(
                                  color: AppPallete.primaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.visibility_outlined,
                                size: 16,
                                color: AppPallete.primaryContainer,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectionReason(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => RejectionReasonDialog(
        orderNumber: request.orderNumber,
        adminNotes: request.adminNotes,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = _getMonthName(date.month);
    final year = date.year.toString();
    return '$day $month $year';
  }

  String _getMonthName(int month) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';
  }
}
