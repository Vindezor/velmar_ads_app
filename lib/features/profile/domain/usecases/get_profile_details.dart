// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/profile/domain/entities/profile_details.dart';
import 'package:velmar_ads/features/profile/domain/repository/profile_repository.dart';

class GetProfileDetails implements UseCase<ProfileDetails, String> {
  final ProfileRepository _profileRepository;

  GetProfileDetails({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, ProfileDetails>> call(String userId) async {
    return await _profileRepository.getProfileDetails(userId);
  }
}
