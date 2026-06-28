// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/library/domain/repository/library_repository.dart';

class DeleteAdAssetParams {
  final String assetId;
  final String fileName;
  final String userId;

  DeleteAdAssetParams({
    required this.assetId,
    required this.fileName,
    required this.userId,
  });
}

class DeleteAdAsset implements UseCase<void, DeleteAdAssetParams> {
  final LibraryRepository _repository;

  DeleteAdAsset({required LibraryRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, void>> call(DeleteAdAssetParams params) async {
    return await _repository.deleteAdAsset(
      assetId: params.assetId,
      fileName: params.fileName,
      userId: params.userId,
    );
  }
}
