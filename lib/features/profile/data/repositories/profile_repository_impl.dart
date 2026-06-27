// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/exceptions.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:velmar_ads/features/profile/domain/entities/profile_details.dart';
import 'package:velmar_ads/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  const ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, ProfileDetails>> getProfileDetails(String userId) async {
    try {
      final futures = await Future.wait([
        _remoteDataSource.getUserCredits(userId),
        _remoteDataSource.getMovementHistory(userId),
      ]);

      final credits = futures[0] as double;
      final movements = futures[1] as List<dynamic>;

      return right(
        ProfileDetails(
          credits: credits,
          movements: movements.cast(),
        ),
      );
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
