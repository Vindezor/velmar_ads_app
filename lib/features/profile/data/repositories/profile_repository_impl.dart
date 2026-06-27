// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/exceptions.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:velmar_ads/features/profile/data/models/credit_request_model.dart';
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

  @override
  Future<Either<Failure, void>> submitCreditRequest({
    required double amount,
    required String filePath,
    required String fileName,
    required String userId,
    String? paymentNotes,
  }) async {
    try {
      // 1. Upload payment proof
      final proofUrl = await _remoteDataSource.uploadPaymentProof(filePath, fileName, userId);

      // 2. Generate unique order number (e.g. CR-timestamp)
      final orderNumber = 'CR-${DateTime.now().millisecondsSinceEpoch}';

      // 3. Construct the model
      final request = CreditRequestModel(
        id: '', // database auto-generates uuid
        userId: userId,
        orderNumber: orderNumber,
        creditsRequested: amount,
        usdAmount: amount,
        paymentProofUrl: proofUrl,
        paymentNotes: paymentNotes ?? 'Transferencia bancaria',
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 4. Submit to database
      await _remoteDataSource.createCreditRequest(request);
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
