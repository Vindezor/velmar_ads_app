import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';
import 'package:velmar_ads/features/bookings/presentation/bloc/bookings_bloc.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/bookings_app_bar.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/bookings_list_error_view.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/booking_status_banner.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/booking_asset_player.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/booking_screen_details.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/booking_schedule_details.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/booking_price_details.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/booking_detail_actions.dart';
import 'package:velmar_ads/init_dependencies.dart';

class BookingDetailPage extends StatelessWidget {
  final String bookingId;

  const BookingDetailPage({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<BookingsBloc>()
        ..add(BookingsLoadBookingDetail(bookingId: bookingId)),
      child: BookingDetailView(bookingId: bookingId),
    );
  }
}

class BookingDetailView extends StatelessWidget {
  final String bookingId;

  const BookingDetailView({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: const BookingsAppBar(),
      body: BlocBuilder<BookingsBloc, BookingsState>(
        builder: (context, state) {
          return switch (state) {
            BookingsInitial() || BookingsBookingDetailLoading() => const Center(
                child: CircularProgressIndicator(color: AppPallete.primary),
              ),
            BookingsBookingDetailLoaded(booking: final booking) => LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.containerPadding),
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: AppSpacing.maxWidth,
                          ),
                          child: _buildLayout(context, booking, constraints.maxWidth),
                        ),
                      ),
                    ),
                  );
                },
              ),
            BookingsBookingDetailError(message: final msg) => BookingsListErrorView(
                errorMessage: msg,
                onRetry: () {
                  context.read<BookingsBloc>().add(
                        BookingsLoadBookingDetail(bookingId: bookingId),
                      );
                },
              ),
            _ => const Center(
                child: CircularProgressIndicator(color: AppPallete.primary),
              ),
          };
        },
      ),
    );
  }

  Widget _buildLayout(BuildContext context, Booking booking, double width) {
    final leftColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        BookingStatusBanner(booking: booking),
        const SizedBox(height: AppSpacing.stackLg),
        BookingAssetPlayer(booking: booking),
        const SizedBox(height: AppSpacing.stackLg),
        BookingScreenDetails(booking: booking),
      ],
    );

    final rightColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        BookingScheduleDetails(booking: booking),
        const SizedBox(height: AppSpacing.stackLg),
        BookingPriceDetails(booking: booking),
        const SizedBox(height: AppSpacing.stackLg),
        BookingDetailActions(booking: booking),
      ],
    );

    if (width >= 768) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 8,
            child: leftColumn,
          ),
          const SizedBox(width: AppSpacing.stackLg),
          Expanded(
            flex: 4,
            child: rightColumn,
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          BookingStatusBanner(booking: booking),
          const SizedBox(height: AppSpacing.stackLg),
          BookingAssetPlayer(booking: booking),
          const SizedBox(height: AppSpacing.stackLg),
          BookingScreenDetails(booking: booking),
          const SizedBox(height: AppSpacing.stackLg),
          BookingScheduleDetails(booking: booking),
          const SizedBox(height: AppSpacing.stackLg),
          BookingPriceDetails(booking: booking),
          const SizedBox(height: AppSpacing.stackLg),
          BookingDetailActions(booking: booking),
        ],
      );
    }
  }
}
