// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/bookings/domain/repository/bookings_repository.dart';

class ResubmitBooking implements UseCase<void, ResubmitBookingParams> {
  final BookingsRepository _bookingsRepository;

  ResubmitBooking({required BookingsRepository bookingsRepository})
      : _bookingsRepository = bookingsRepository;

  @override
  Future<Either<Failure, void>> call(ResubmitBookingParams params) async {
    return await _bookingsRepository.resubmitBooking(
      bookingId: params.bookingId,
      assetId: params.assetId,
      notes: params.notes,
    );
  }
}

class ResubmitBookingParams {
  final String bookingId;
  final String assetId;
  final String? notes;

  const ResubmitBookingParams({
    required this.bookingId,
    required this.assetId,
    this.notes,
  });
}
