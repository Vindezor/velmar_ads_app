import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';
import 'bookings_header.dart';
import 'booking_status_section.dart';

class BookingsLoadedView extends StatefulWidget {
  final List<Booking> bookings;
  final RefreshCallback onRefresh;

  const BookingsLoadedView({
    super.key,
    required this.bookings,
    required this.onRefresh,
  });

  @override
  State<BookingsLoadedView> createState() => _BookingsLoadedViewState();
}

class _BookingsLoadedViewState extends State<BookingsLoadedView> {
  String _activeFilter = 'todos'; // todos, pendientes, aprobadas, rechazadas

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
                  'Filtrar Reservas',
                  style: AppTypography.headlineMd.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(),
              _buildFilterOption('Todos los estados', 'todos'),
              _buildFilterOption('Pendientes', 'pendientes'),
              _buildFilterOption('Aprobadas', 'aprobadas'),
              _buildFilterOption('Rechazadas', 'rechazadas'),
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
        setState(() {
          _activeFilter = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBookings = widget.bookings.where((b) {
      if (_activeFilter == 'todos') return true;
      final status = b.status.toLowerCase();
      if (_activeFilter == 'pendientes') {
        return status == 'pending' || status == 'resubmitted';
      }
      if (_activeFilter == 'aprobadas') {
        return status == 'approved';
      }
      if (_activeFilter == 'rechazadas') {
        return status == 'rejected' || status == 'expired' || status == 'cancelled';
      }
      return true;
    }).toList();

    final pending = filteredBookings
        .where((b) =>
            b.status.toLowerCase() == 'pending' ||
            b.status.toLowerCase() == 'resubmitted')
        .toList();
    final approved =
        filteredBookings.where((b) => b.status.toLowerCase() == 'approved').toList();
    final rejected = filteredBookings
        .where((b) =>
            b.status.toLowerCase() == 'rejected' ||
            b.status.toLowerCase() == 'expired' ||
            b.status.toLowerCase() == 'cancelled')
        .toList();

    final isListEmpty = pending.isEmpty && approved.isEmpty && rejected.isEmpty;

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      backgroundColor: AppPallete.surfaceContainerLowest,
      color: AppPallete.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.containerPadding,
            vertical: AppSpacing.stackLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingsHeader(
                activeFilter: _activeFilter,
                onFilterPressed: _showFilterDialog,
              ),
              if (isListEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Text(
                      'No hay reservas que coincidan con este filtro.',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppPallete.secondary,
                      ),
                    ),
                  ),
                )
              else ...[
                if (pending.isNotEmpty)
                  BookingStatusSection(
                    title: 'Pendientes',
                    bookings: pending,
                    bulletColor: AppPallete.tertiary,
                  ),
                if (approved.isNotEmpty)
                  BookingStatusSection(
                    title: 'Aprobadas',
                    bookings: approved,
                    bulletColor: AppPallete.primary,
                  ),
                if (rejected.isNotEmpty)
                  BookingStatusSection(
                    title: 'Rechazadas',
                    bookings: rejected,
                    bulletColor: AppPallete.error,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
