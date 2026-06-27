part of 'bookings_bloc.dart';

@immutable
sealed class BookingsEvent {}

final class BookingsFetchAvailability extends BookingsEvent {
  final String billboardId;
  BookingsFetchAvailability({required this.billboardId});
}

final class BookingsLoadConfirmationData extends BookingsEvent {
  final String userId;
  final String billboardId;
  final DateTime selectedDate;
  final List<int> selectedSlots;
  final String assetId;

  BookingsLoadConfirmationData({
    required this.userId,
    required this.billboardId,
    required this.selectedDate,
    required this.selectedSlots,
    required this.assetId,
  });
}

final class BookingsSubmitCheckout extends BookingsEvent {
  final String userId;
  final String billboardId;
  final String assetId;

  BookingsSubmitCheckout({
    required this.userId,
    required this.billboardId,
    required this.assetId,
  });
}

final class BookingsLoadUserBookings extends BookingsEvent {}
