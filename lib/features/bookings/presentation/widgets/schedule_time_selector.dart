import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';

class ScheduleTimeSelector extends StatelessWidget {
  final int? startHour;
  final int? endHour;
  final ValueChanged<int?> onStartHourChanged;
  final ValueChanged<int?> onEndHourChanged;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Booking> bookings;

  const ScheduleTimeSelector({
    super.key,
    required this.startHour,
    required this.endHour,
    required this.onStartHourChanged,
    required this.onEndHourChanged,
    required this.startDate,
    required this.endDate,
    required this.bookings,
  });

  String _formatHourLabel(int hour) {
    if (hour == 24) return '24:00 (Fin del día)';
    final prefix = hour.toString().padLeft(2, '0');
    return '$prefix:00';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // 1. Determinar la hora mínima de inicio permitida si es hoy (hora actual + 2)
    int minStartHour = 0;
    if (startDate != null &&
        startDate!.year == now.year &&
        startDate!.month == now.month &&
        startDate!.day == now.day) {
      minStartHour = now.hour + 2;
    }

    // Si la hora mínima supera las 23, significa que no quedan horas hábiles hoy.
    final bool isTodayNoHoursAvailable = minStartHour > 23;

    // Generar lista de horas de inicio válidas (de minStartHour a 23)
    final List<int> availableStartHours = [];
    if (!isTodayNoHoursAvailable) {
      for (int h = minStartHour; h <= 23; h++) {
        availableStartHours.add(h);
      }
    }

    // Generar lista de horas de fin válidas
    final List<int> availableEndHours = [];
    final bool isMultiday = startDate != null && endDate != null &&
        (startDate!.year != endDate!.year ||
         startDate!.month != endDate!.month ||
         startDate!.day != endDate!.day);

    if (isMultiday) {
      // Si son días distintos, se permiten las 24 horas de fin de forma libre
      for (int h = 1; h <= 24; h++) {
        availableEndHours.add(h);
      }
    } else {
      // Mismo día (o fin aún no seleccionado): la hora de fin debe ser posterior a la de inicio
      if (startHour != null) {
        for (int h = startHour! + 1; h <= 24; h++) {
          availableEndHours.add(h);
        }
      }
    }

    // Estilo de decoración para los dropdowns
    InputDecoration dropdownDecoration({required String labelText}) {
      return InputDecoration(
        labelText: labelText,
        labelStyle: AppTypography.labelMd.copyWith(color: AppPallete.secondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: AppPallete.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppPallete.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppPallete.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: const BorderSide(color: AppPallete.primary, width: 2),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
      child: Container(
        decoration: BoxDecoration(
          color: AppPallete.surfaceContainerLowest,
          borderRadius: AppRadius.borderLg,
          border: Border.all(color: AppPallete.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Selección de Horas',
                    style: AppTypography.headlineMd.copyWith(
                      color: AppPallete.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Zona Centro',
                  style: AppTypography.labelMd.copyWith(
                    color: AppPallete.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (startDate == null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Por favor, selecciona primero una fecha en el calendario.',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppPallete.secondary,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (isTodayNoHoursAvailable)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'No hay horas de inicio disponibles para hoy (debe reservarse con al menos 2 horas de anticipación). Selecciona otra fecha.',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppPallete.error,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown de Hora de Inicio
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: dropdownDecoration(
                        labelText: 'HORA DE INICIO',
                      ),
                      initialValue: startHour != null && availableStartHours.contains(startHour)
                          ? startHour
                          : null,
                      hint: Text(
                        'Selecciona',
                        style: AppTypography.bodyMd.copyWith(color: AppPallete.outline),
                      ),
                      dropdownColor: AppPallete.surfaceContainerLowest,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppPallete.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                      items: availableStartHours.map((hour) {
                        return DropdownMenuItem<int>(
                          value: hour,
                          child: Text(_formatHourLabel(hour)),
                        );
                      }).toList(),
                      onChanged: onStartHourChanged,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Dropdown de Hora de Fin
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: dropdownDecoration(
                        labelText: 'HORA DE FIN',
                      ),
                      initialValue: endHour != null && availableEndHours.contains(endHour)
                          ? endHour
                          : null,
                      disabledHint: Text(
                        'Inicio req.',
                        style: AppTypography.bodyMd.copyWith(color: AppPallete.outline),
                      ),
                      hint: Text(
                        'Selecciona',
                        style: AppTypography.bodyMd.copyWith(color: AppPallete.outline),
                      ),
                      dropdownColor: AppPallete.surfaceContainerLowest,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppPallete.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                      items: !isMultiday && startHour == null
                          ? null
                          : availableEndHours.map((hour) {
                              return DropdownMenuItem<int>(
                                value: hour,
                                child: Text(_formatHourLabel(hour)),
                              );
                            }).toList(),
                      onChanged: !isMultiday && startHour == null ? null : onEndHourChanged,
                    ),
                  ),
                ],
              ),
              if (startDate != null &&
                  startDate!.year == now.year &&
                  startDate!.month == now.month &&
                  startDate!.day == now.day)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    '* Nota de reserva: Como inicia el día de hoy, la hora de inicio permitida debe ser al menos 2 horas después de la hora actual (${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}).',
                    style: AppTypography.bodySm.copyWith(
                      color: AppPallete.secondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
