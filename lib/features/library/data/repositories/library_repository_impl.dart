// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/exceptions.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/features/library/data/datasources/library_remote_data_source.dart';
import 'package:velmar_ads/features/library/domain/repository/library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryRemoteDataSource _remoteDataSource;

  LibraryRepositoryImpl({required LibraryRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, String>> uploadAdAsset({
    required List<int> fileBytes,
    required String fileName,
    required String userId,
  }) async {
    try {
      final fileUrl = await _remoteDataSource.uploadAdContent(
        fileBytes: fileBytes,
        fileName: fileName,
        userId: userId,
      );

      final assetId = await _remoteDataSource.createCreativeAsset(
        userId: userId,
        fileUrl: fileUrl,
        fileName: fileName,
      );

      return right(assetId);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
