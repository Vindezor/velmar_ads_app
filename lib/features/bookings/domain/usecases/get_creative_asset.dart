// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/bookings/domain/repository/bookings_repository.dart';

class GetCreativeAsset implements UseCase<Map<String, dynamic>, String> {
  final BookingsRepository _bookingsRepository;

  GetCreativeAsset({required BookingsRepository bookingsRepository})
      : _bookingsRepository = bookingsRepository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String assetId) async {
    return await _bookingsRepository.getCreativeAsset(assetId);
  }
}
