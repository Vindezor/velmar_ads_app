import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/features/profile/domain/entities/profile_details.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, ProfileDetails>> getProfileDetails(String userId);
}
