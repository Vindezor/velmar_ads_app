// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/library/domain/repository/library_repository.dart';

import 'package:velmar_ads/features/library/domain/entities/creative_asset.dart';

class UploadAdAsset implements UseCase<CreativeAsset, UploadAdAssetParams> {
  final LibraryRepository _repository;

  UploadAdAsset({required LibraryRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, CreativeAsset>> call(UploadAdAssetParams params) async {
    return await _repository.uploadAdAsset(
      fileBytes: params.fileBytes,
      fileName: params.fileName,
      userId: params.userId,
    );
  }
}

class UploadAdAssetParams {
  final List<int> fileBytes;
  final String fileName;
  final String userId;

  UploadAdAssetParams({
    required this.fileBytes,
    required this.fileName,
    required this.userId,
  });
}
