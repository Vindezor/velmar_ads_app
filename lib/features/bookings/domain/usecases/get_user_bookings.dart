// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';
import 'package:velmar_ads/features/bookings/domain/repository/bookings_repository.dart';

class GetUserBookingsParams {
  final String userId;
  final bool forceRefresh;

  GetUserBookingsParams({
    required this.userId,
    this.forceRefresh = false,
  });
}

class GetUserBookings implements UseCase<List<Booking>, GetUserBookingsParams> {
  final BookingsRepository _bookingsRepository;

  GetUserBookings({required BookingsRepository bookingsRepository})
      : _bookingsRepository = bookingsRepository;

  @override
  Future<Either<Failure, List<Booking>>> call(GetUserBookingsParams params) async {
    return await _bookingsRepository.getUserBookings(
      params.userId,
      forceRefresh: params.forceRefresh,
    );
  }
}
