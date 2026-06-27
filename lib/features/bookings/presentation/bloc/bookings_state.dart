part of 'bookings_bloc.dart';

@immutable
sealed class BookingsState {}

// Initial state
final class BookingsInitial extends BookingsState {}

// Availability States
final class BookingsAvailabilityLoading extends BookingsState {}

final class BookingsAvailabilityLoaded extends BookingsState {
  final List<Booking> bookings;
  BookingsAvailabilityLoaded({required this.bookings});
}

final class BookingsAvailabilityError extends BookingsState {
  final String message;
  BookingsAvailabilityError({required this.message});
}

// Checkout / Confirmation States
class BookingsConfirmationLoading extends BookingsState {}

class BookingsConfirmationLoaded extends BookingsState {
  final double currentBalance;
  final String bookingTypeId;
  final DateTime startTime;
  final DateTime endTime;
  final Map<String, dynamic> priceData;
  final Map<String, dynamic> assetData;

  BookingsConfirmationLoaded({
    required this.currentBalance,
    required this.bookingTypeId,
    required this.startTime,
    required this.endTime,
    required this.priceData,
    required this.assetData,
  });
}

class BookingsConfirmationSubmitting extends BookingsState {
  final double currentBalance;
  final String bookingTypeId;
  final DateTime startTime;
  final DateTime endTime;
  final Map<String, dynamic> priceData;
  final Map<String, dynamic> assetData;

  BookingsConfirmationSubmitting({
    required this.currentBalance,
    required this.bookingTypeId,
    required this.startTime,
    required this.endTime,
    required this.priceData,
    required this.assetData,
  });
}

class BookingsConfirmationSuccess extends BookingsState {}

class BookingsConfirmationFailure extends BookingsState {
  final String error;
  final double currentBalance;
  final String bookingTypeId;
  final DateTime startTime;
  final DateTime endTime;
  final Map<String, dynamic> priceData;
  final Map<String, dynamic> assetData;

  BookingsConfirmationFailure({
    required this.error,
    required this.currentBalance,
    required this.bookingTypeId,
    required this.startTime,
    required this.endTime,
    required this.priceData,
    required this.assetData,
  });
}

class BookingsConfirmationLoadFailure extends BookingsState {
  final String error;
  BookingsConfirmationLoadFailure({required this.error});
}

// User Bookings Retrieval States
final class BookingsUserBookingsLoading extends BookingsState {}

final class BookingsUserBookingsLoaded extends BookingsState {
  final List<Booking> bookings;
  BookingsUserBookingsLoaded({required this.bookings});
}

final class BookingsUserBookingsError extends BookingsState {
  final String message;
  BookingsUserBookingsError({required this.message});
}

// Booking Detail States
final class BookingsBookingDetailLoading extends BookingsState {}

final class BookingsBookingDetailLoaded extends BookingsState {
  final Booking booking;
  BookingsBookingDetailLoaded({required this.booking});
}

final class BookingsBookingDetailError extends BookingsState {
  final String message;
  BookingsBookingDetailError({required this.message});
}

// Booking Correction States
final class BookingsCorrectionSubmitting extends BookingsState {}

final class BookingsCorrectionSuccess extends BookingsState {}

final class BookingsCorrectionFailure extends BookingsState {
  final String error;
  BookingsCorrectionFailure({required this.error});
}
