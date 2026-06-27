// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';
import 'package:velmar_ads/features/bookings/domain/repository/bookings_repository.dart';

class GetUserBookings implements UseCase<List<Booking>, String> {
  final BookingsRepository _bookingsRepository;

  GetUserBookings({required BookingsRepository bookingsRepository})
      : _bookingsRepository = bookingsRepository;

  @override
  Future<Either<Failure, List<Booking>>> call(String userId) async {
    return await _bookingsRepository.getUserBookings(userId);
  }
}
