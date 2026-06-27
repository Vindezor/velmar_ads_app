// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/bookings/domain/repository/bookings_repository.dart';

class CalculateBookingPrice implements UseCase<Map<String, dynamic>, CalculateBookingPriceParams> {
  final BookingsRepository _bookingsRepository;

  CalculateBookingPrice({required BookingsRepository bookingsRepository})
      : _bookingsRepository = bookingsRepository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(CalculateBookingPriceParams params) async {
    return await _bookingsRepository.calculateBookingPrice(
      billboardId: params.billboardId,
      bookingTypeId: params.bookingTypeId,
      startTime: params.startTime,
      endTime: params.endTime,
    );
  }
}

class CalculateBookingPriceParams {
  final String billboardId;
  final String bookingTypeId;
  final DateTime startTime;
  final DateTime endTime;

  const CalculateBookingPriceParams({
    required this.billboardId,
    required this.bookingTypeId,
    required this.startTime,
    required this.endTime,
  });
}
