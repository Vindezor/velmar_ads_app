import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/currency_formatter.dart';
import 'package:velmar_ads/features/profile/domain/entities/movement.dart';

class ProfileMovementItem extends StatelessWidget {
  final Movement movement;
  final bool showDivider;

  const ProfileMovementItem({
    super.key,
    required this.movement,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = movement.amount >= 0;
    
    // Format date
    final day = movement.createdAt.day.toString().padLeft(2, '0');
    final month = _getMonthName(movement.createdAt.month);
    final year = movement.createdAt.year.toString();
    final dateStr = '$day $month $year';

    // Format amount
    final formattedAmount = CurrencyFormatter.format(movement.amount.abs()).replaceAll('.00', '');
    final amountText = isPositive ? '+ \$$formattedAmount' : '- \$$formattedAmount';
    final amountColor = isPositive ? const Color(0xFF2E7D32) : AppPallete.onSurface;

    // Pick icon based on type / amount
    IconData iconData;
    Color iconColor;

    if (movement.type == 'credit_purchase') {
      iconData = Icons.account_balance_wallet;
      iconColor = AppPallete.primary;
    } else if (movement.type == 'booking_payment') {
      iconData = Icons.campaign;
      iconColor = AppPallete.secondary;
    } else if (movement.type == 'refund_rejection' || movement.type == 'refund_cancellation') {
      iconData = Icons.receipt_long;
      iconColor = AppPallete.primary;
    } else if (isPositive) {
      // Welcome gift or bonus
      iconData = Icons.card_giftcard;
      iconColor = AppPallete.primary;
    } else {
      iconData = Icons.campaign;
      iconColor = AppPallete.secondary;
    }

    return Container(
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(
                bottom: BorderSide(color: AppPallete.outlineVariant),
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            child: Row(
              children: [
                // Icon Wrapper
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppPallete.surfaceContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    iconData,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.stackMd),
                // Description and date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        movement.description,
                        style: AppTypography.bodyMd.copyWith(
                          color: AppPallete.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateStr,
                        style: AppTypography.bodySm.copyWith(
                          color: AppPallete.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.gutter),
                // Amount
                Text(
                  amountText,
                  style: AppTypography.bodyMd.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
