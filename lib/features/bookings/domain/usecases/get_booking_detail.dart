// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';
import 'package:velmar_ads/features/bookings/domain/repository/bookings_repository.dart';

class GetBookingDetail implements UseCase<Booking, String> {
  final BookingsRepository _bookingsRepository;

  GetBookingDetail({required BookingsRepository bookingsRepository})
      : _bookingsRepository = bookingsRepository;

  @override
  Future<Either<Failure, Booking>> call(String bookingId) async {
    return await _bookingsRepository.getBookingDetail(bookingId);
  }
}
