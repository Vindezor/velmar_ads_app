import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/presentation/bloc/bookings_bloc.dart';
import 'package:velmar_ads/core/common/widgets/velmar_app_bar.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/bookings_empty_view.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/bookings_list_error_view.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/bookings_loaded_view.dart';

class BookingsView extends StatefulWidget {
  const BookingsView({super.key});

  @override
  State<BookingsView> createState() => _BookingsViewState();
}

class _BookingsViewState extends State<BookingsView> {
  String? _lastLocation;

  @override
  Widget build(BuildContext context) {
    // Listen to GoRouterState matchedLocation changes
    try {
      final location = GoRouterState.of(context).matchedLocation;
      
      // If the user just switched to the Bookings tab (/bookings), trigger refresh
      if (location == '/bookings' && _lastLocation != '/bookings') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.read<BookingsBloc>().add(BookingsLoadUserBookings());
          }
        });
      }
      _lastLocation = location;
    } catch (_) {
      // In case GoRouterState is not present in context (e.g. testing)
    }

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
