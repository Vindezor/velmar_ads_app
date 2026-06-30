// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/profile/domain/entities/credit_request.dart';
import 'package:velmar_ads/features/profile/domain/repository/profile_repository.dart';

class GetCreditRequestsParams {
  final String userId;
  final bool forceRefresh;

  GetCreditRequestsParams({
    required this.userId,
    this.forceRefresh = false,
  });
}

class GetCreditRequests implements UseCase<List<CreditRequest>, GetCreditRequestsParams> {
  final ProfileRepository _profileRepository;

  GetCreditRequests({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, List<CreditRequest>>> call(GetCreditRequestsParams params) async {
    return await _profileRepository.getCreditRequests(
      params.userId,
      forceRefresh: params.forceRefresh,
    );
  }
}
