import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/currency_formatter.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/bookings_app_bar.dart';
import 'package:velmar_ads/features/profile/domain/entities/movement.dart';

class CreditHistoryPage extends StatefulWidget {
  final double credits;
  final List<Movement> movements;

  const CreditHistoryPage({
    super.key,
    required this.credits,
    required this.movements,
  });

  @override
  State<CreditHistoryPage> createState() => _CreditHistoryPageState();
}

class _CreditHistoryPageState extends State<CreditHistoryPage> {
  String _activeFilter = 'todos'; // todos, recargas, campañas, reembolsos
  late List<Movement> _filteredMovements;

  @override
  void initState() {
    super.initState();
    _filteredMovements = widget.movements;
  }

  void _applyFilter(String filter) {
    setState(() {
      _activeFilter = filter;
      if (filter == 'todos') {
        _filteredMovements = widget.movements;
      } else if (filter == 'recargas') {
        _filteredMovements = widget.movements
            .where((m) => m.type == 'credit_purchase' || m.type == 'admin_adjustment')
            .toList();
      } else if (filter == 'campañas') {
        _filteredMovements = widget.movements
            .where((m) => m.type == 'booking_payment')
            .toList();
      } else if (filter == 'reembolsos') {
        _filteredMovements = widget.movements
            .where((m) => m.type == 'refund_rejection' || m.type == 'refund_cancellation')
            .toList();
      }
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.gutter),
                child: Text(
                  'Filtrar Movimientos',
                  style: AppTypography.headlineMd.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(),
              _buildFilterOption('Todos', 'todos'),
              _buildFilterOption('Recargas de saldo', 'recargas'),
              _buildFilterOption('Campañas contratadas', 'campañas'),
              _buildFilterOption('Reembolsos recibidos', 'reembolsos'),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String label, String value) {
    final isSelected = _activeFilter == value;
    return ListTile(
      title: Text(
        label,
        style: AppTypography.bodyLg.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppPallete.primary : AppPallete.onSurface,
        ),
      ),
      trailing: isSelected 
          ? const Icon(Icons.check, color: AppPallete.primary) 
          : null,
      onTap: () {
        Navigator.pop(context);
        _applyFilter(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total positive credits loaded this month
    final now = DateTime.now();
    final thisMonthPositive = widget.movements.where((m) =>
        m.createdAt.month == now.month &&
        m.createdAt.year == now.year &&
        m.amount > 0);
    final totalThisMonth = thisMonthPositive.fold<double>(
        0.0, (sum, m) => sum + m.amount);

    final formattedCredits = CurrencyFormatter.format(widget.credits).replaceAll('.00', '');
    final formattedThisMonth = CurrencyFormatter.format(totalThisMonth).replaceAll('.00', '');

    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: const BookingsAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.containerPadding,
            vertical: AppSpacing.stackLg,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 600, // Styled card-centered layout
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Summary Card (Bento Style)
                  Container(
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
                        Positioned(
                          right: -24,
                          top: -24,
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
                          children: [
                            Text(
                              'SALDO ACTUAL',
                              style: AppTypography.labelMd.copyWith(
                                color: AppPallete.onSurfaceVariant,
                                letterSpacing: 1.2,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  formattedCredits,
                                  style: AppTypography.displayLg.copyWith(
                                    color: AppPallete.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Créditos',
                                  style: AppTypography.bodyMd.copyWith(
                                    color: AppPallete.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            if (totalThisMonth > 0) ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.trending_up,
                                    color: AppPallete.primary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+$formattedThisMonth este mes',
                                    style: AppTypography.bodySm.copyWith(
                                      color: AppPallete.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Transactions List Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Movimientos',
                        style: AppTypography.headlineMd.copyWith(
                          color: AppPallete.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _showFilterDialog,
                        icon: const Icon(Icons.filter_list, size: 20),
                        label: Text(
                          _activeFilter == 'todos'
                              ? 'Filtrar'
                              : 'Filtro: ${_activeFilter.toUpperCase()}',
                          style: AppTypography.labelMd.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppPallete.outlineVariant),
                  const SizedBox(height: 8),
                  // Transactions List
                  if (_filteredMovements.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppPallete.surfaceContainerLowest,
                        borderRadius: AppRadius.borderMd,
                        border: Border.all(color: AppPallete.outlineVariant),
                      ),
                      child: Center(
                        child: Text(
                          'No hay movimientos que coincidan con el filtro.',
                          style: AppTypography.bodyMd.copyWith(
                            color: AppPallete.secondary,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: AppPallete.surfaceContainerLowest,
                        borderRadius: AppRadius.borderMd,
                        border: Border.all(color: AppPallete.outlineVariant),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredMovements.length,
                        separatorBuilder: (context, index) => const Divider(
                          color: AppPallete.outlineVariant,
                          height: 1,
                        ),
                        itemBuilder: (context, index) {
                          final movement = _filteredMovements[index];
                          final isPositive = movement.amount >= 0;

                          // Date format
                          final day = movement.createdAt.day.toString().padLeft(2, '0');
                          final month = _getMonthName(movement.createdAt.month);
                          final year = movement.createdAt.year.toString();
                          final hour = movement.createdAt.hour.toString().padLeft(2, '0');
                          final min = movement.createdAt.minute.toString().padLeft(2, '0');
                          final dateStr = '$day $month $year, $hour:$min';

                          final formattedAmount = CurrencyFormatter.format(movement.amount.abs()).replaceAll('.00', '');
                          final amountText = isPositive ? '+$formattedAmount' : '-$formattedAmount';
                          final amountColor = isPositive ? const Color(0xFF2E7D32) : AppPallete.onSurface;

                          final formattedBalanceAfter = CurrencyFormatter.format(movement.balanceAfter).replaceAll('.00', '');

                          // Match icons and colors to the mockup bento specs
                          IconData iconData;
                          Color iconColor;
                          Color iconBg;

                          if (movement.type == 'credit_purchase') {
                            iconData = Icons.add_card;
                            iconBg = AppPallete.primary.withValues(alpha: 0.1);
                            iconColor = AppPallete.primary;
                          } else if (movement.type == 'booking_payment') {
                            iconData = Icons.campaign;
                            iconBg = AppPallete.surfaceContainer;
                            iconColor = AppPallete.secondary;
                          } else if (movement.type == 'refund_rejection' || movement.type == 'refund_cancellation') {
                            iconData = Icons.currency_exchange;
                            iconBg = AppPallete.secondaryContainer;
                            iconColor = AppPallete.onSecondaryContainer;
                          } else {
                            iconData = Icons.receipt_long;
                            iconBg = AppPallete.surfaceContainer;
                            iconColor = AppPallete.secondary;
                          }

                          return InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.gutter,
                                vertical: AppSpacing.stackMd,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: iconBg,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      iconData,
                                      color: iconColor,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.stackMd),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                            color: AppPallete.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.gutter),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        amountText,
                                        style: AppTypography.bodyLg.copyWith(
                                          color: amountColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Saldo: $formattedBalanceAfter',
                                        style: AppTypography.labelSm.copyWith(
                                          color: AppPallete.onSurfaceVariant,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
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
