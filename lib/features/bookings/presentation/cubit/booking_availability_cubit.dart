// ignore_for_file: prefer_initializing_formals

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/get_billboard_bookings.dart';

@immutable
sealed class BookingAvailabilityState {}

final class BookingAvailabilityInitial extends BookingAvailabilityState {}

final class BookingAvailabilityLoading extends BookingAvailabilityState {}

final class BookingAvailabilityLoaded extends BookingAvailabilityState {
  final List<Booking> bookings;
  BookingAvailabilityLoaded({required this.bookings});
}

final class BookingAvailabilityError extends BookingAvailabilityState {
  final String message;
  BookingAvailabilityError({required this.message});
}

class BookingAvailabilityCubit extends Cubit<BookingAvailabilityState> {
  final GetBillboardBookings _getBillboardBookings;

  BookingAvailabilityCubit({
    required GetBillboardBookings getBillboardBookings,
  })  : _getBillboardBookings = getBillboardBookings,
        super(BookingAvailabilityInitial());

  Future<void> fetchAvailability(String billboardId) async {
    emit(BookingAvailabilityLoading());
    final res = await _getBillboardBookings(billboardId);
    res.fold(
      (failure) => emit(BookingAvailabilityError(message: failure.message)),
      (bookings) => emit(BookingAvailabilityLoaded(bookings: bookings)),
    );
  }
}
