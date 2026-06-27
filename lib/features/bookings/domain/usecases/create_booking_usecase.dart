// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/bookings/domain/repository/bookings_repository.dart';

class CreateBookingUseCase implements UseCase<Map<String, dynamic>, CreateBookingParams> {
  final BookingsRepository _bookingsRepository;

  CreateBookingUseCase({required BookingsRepository bookingsRepository})
      : _bookingsRepository = bookingsRepository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(CreateBookingParams params) async {
    return await _bookingsRepository.createBooking(
      userId: params.userId,
      billboardId: params.billboardId,
      bookingTypeId: params.bookingTypeId,
      startTime: params.startTime,
      endTime: params.endTime,
      assetId: params.assetId,
    );
  }
}

class CreateBookingParams {
  final String userId;
  final String billboardId;
  final String bookingTypeId;
  final DateTime startTime;
  final DateTime endTime;
  final String assetId;

  const CreateBookingParams({
    required this.userId,
    required this.billboardId,
    required this.bookingTypeId,
    required this.startTime,
    required this.endTime,
    required this.assetId,
  });
}
