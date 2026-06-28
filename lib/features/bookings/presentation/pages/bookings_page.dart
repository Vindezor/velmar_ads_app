import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/presentation/bloc/bookings_bloc.dart';
import 'package:velmar_ads/core/common/widgets/velmar_app_bar.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/bookings_empty_view.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/bookings_list_error_view.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/bookings_loaded_view.dart';
import 'package:velmar_ads/init_dependencies.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<BookingsBloc>()..add(BookingsLoadUserBookings()),
      child: const BookingsView(),
    );
  }
}

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: const VelmarAppBar(showBackButton: false),
      body: BlocBuilder<BookingsBloc, BookingsState>(
        builder: (context, state) {
          return switch (state) {
            BookingsInitial() || BookingsUserBookingsLoading() => const Center(
                child: CircularProgressIndicator(color: AppPallete.primary),
              ),
            BookingsUserBookingsLoaded(bookings: final bookings) => bookings.isEmpty
                ? const BookingsEmptyView()
                : BookingsLoadedView(
                    bookings: bookings,
                    onRefresh: () async {
                      context.read<BookingsBloc>().add(BookingsLoadUserBookings());
                    },
                  ),
            BookingsUserBookingsError(message: final msg) => BookingsListErrorView(
                errorMessage: msg,
                onRetry: () {
                  context.read<BookingsBloc>().add(BookingsLoadUserBookings());
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
}
