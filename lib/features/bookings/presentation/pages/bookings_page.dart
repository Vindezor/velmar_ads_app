import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/features/bookings/presentation/bloc/bookings_bloc.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/bookings_view.dart';
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
