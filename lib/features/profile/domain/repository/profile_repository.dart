import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/features/profile/domain/entities/profile_details.dart';
import 'package:velmar_ads/features/profile/domain/entities/credit_request.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, ProfileDetails>> getProfileDetails(String userId);
  
  Future<Either<Failure, void>> submitCreditRequest({
    required double amount,
    required Uint8List fileBytes,
    required String fileName,
    required String userId,
    String? paymentNotes,
  });

  Future<Either<Failure, List<CreditRequest>>> getCreditRequests(String userId);
}

