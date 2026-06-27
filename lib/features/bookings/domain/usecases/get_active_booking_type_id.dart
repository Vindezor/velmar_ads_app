// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/bookings/domain/repository/bookings_repository.dart';

class GetActiveBookingTypeId implements UseCase<String, NoParams> {
  final BookingsRepository _bookingsRepository;

  GetActiveBookingTypeId({required BookingsRepository bookingsRepository})
      : _bookingsRepository = bookingsRepository;

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await _bookingsRepository.getActiveBookingTypeId();
  }
}
