import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/billboard.dart';

class ConfirmationDetailsBento extends StatelessWidget {
  final Billboard billboard;
  final DateTime startDate;
  final DateTime endDate;
  final List<int> selectedSlots;

  const ConfirmationDetailsBento({
    super.key,
    required this.billboard,
    required this.startDate,
    required this.endDate,
    required this.selectedSlots,
  });

  String _formatDate(DateTime date) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatHours(List<int> slots) {
    if (slots.isEmpty) return 'N/A';
    final sorted = List<int>.from(slots)..sort();
    final start = sorted.first;
    final end = sorted.last + 1;
    final startStr = start.toString().padLeft(2, '0');
    final endStr = end.toString().padLeft(2, '0');
    return '$startStr:00 - $endStr:00';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bento Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppPallete.surfaceContainerLowest,
              border: Border(
                bottom: BorderSide(color: AppPallete.outlineVariant, width: 1.0),
              ),
            ),
            width: double.infinity,
            child: Text(
              'Detalles de Emisión',
              style: AppTypography.labelMd.copyWith(
                color: AppPallete.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ),
          // Bento Grid using nested rows/columns for custom borders
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 500;

              final locationWidget = _buildBentoCell(
                icon: Icons.location_on_outlined,
                label: 'PANTALLA',
                value: billboard.name,
              );

              final String dateValue;
              if (startDate.year == endDate.year &&
                  startDate.month == endDate.month &&
                  startDate.day == endDate.day) {
                dateValue = _formatDate(startDate);
              } else {
                dateValue = '${_formatDate(startDate)} - ${_formatDate(endDate)}';
              }

              final dateWidget = _buildBentoCell(
                icon: Icons.calendar_month_outlined,
                label: 'FECHA',
                value: dateValue,
              );

              final timeWidget = _buildBentoCell(
                icon: Icons.schedule_outlined,
                label: 'HORARIO',
                value: _formatHours(selectedSlots),
              );

              final durationWidget = _buildBentoCell(
                icon: Icons.timelapse_outlined,
                label: 'DURACIÓN DE SLOT',
                value: '60 mins',
              );

              if (isWide) {
                return Table(
                  border: const TableBorder(
                    horizontalInside: BorderSide(color: AppPallete.outlineVariant, width: 1.0),
                    verticalInside: BorderSide(color: AppPallete.outlineVariant, width: 1.0),
                  ),
                  children: [
                    TableRow(
                      children: [
                        locationWidget,
                        dateWidget,
                      ],
                    ),
                    TableRow(
                      children: [
                        timeWidget,
                        durationWidget,
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    locationWidget,
                    const Divider(color: AppPallete.outlineVariant),
                    dateWidget,
                    const Divider(color: AppPallete.outlineVariant),
                    timeWidget,
                    const Divider(color: AppPallete.outlineVariant),
                    durationWidget,
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBentoCell({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: AppPallete.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTypography.labelSm.copyWith(
                  color: AppPallete.secondary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.bodyLg.copyWith(
              color: AppPallete.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
