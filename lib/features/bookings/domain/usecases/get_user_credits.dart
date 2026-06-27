// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/bookings/domain/repository/bookings_repository.dart';

class GetUserCredits implements UseCase<double, String> {
  final BookingsRepository _bookingsRepository;

  GetUserCredits({required BookingsRepository bookingsRepository})
      : _bookingsRepository = bookingsRepository;

  @override
  Future<Either<Failure, double>> call(String userId) async {
    return await _bookingsRepository.getUserCredits(userId);
  }
}
