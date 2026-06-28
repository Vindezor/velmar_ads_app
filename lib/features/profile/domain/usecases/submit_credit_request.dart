// ignore_for_file: prefer_initializing_formals

import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/profile/domain/repository/profile_repository.dart';

class SubmitCreditRequestParams {
  final double amount;
  final Uint8List fileBytes;
  final String fileName;
  final String userId;
  final String? paymentNotes;

  const SubmitCreditRequestParams({
    required this.amount,
    required this.fileBytes,
    required this.fileName,
    required this.userId,
    this.paymentNotes,
  });
}

class SubmitCreditRequest implements UseCase<void, SubmitCreditRequestParams> {
  final ProfileRepository _profileRepository;

  SubmitCreditRequest({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, void>> call(SubmitCreditRequestParams params) async {
    return await _profileRepository.submitCreditRequest(
      amount: params.amount,
      fileBytes: params.fileBytes,
      fileName: params.fileName,
      userId: params.userId,
      paymentNotes: params.paymentNotes,
    );
  }
}
