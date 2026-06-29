// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/exceptions.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/features/library/data/datasources/library_remote_data_source.dart';
import 'package:velmar_ads/features/library/domain/entities/creative_asset.dart';
import 'package:velmar_ads/features/library/domain/repository/library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryRemoteDataSource _remoteDataSource;

  List<CreativeAsset>? _cachedUserAssets;
  String? _cachedUserId;
  DateTime? _lastCacheTime;
  static const _ttl = Duration(seconds: 60);

  LibraryRepositoryImpl({required LibraryRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, String>> uploadAdAsset({
    required List<int> fileBytes,
    required String fileName,
    required String userId,
  }) async {
    final path = '$userId/$fileName';
    bool isUploaded = false;

    try {
      // Check if a creative asset with this original filename already exists for this user
      final existingAssets = await _remoteDataSource.getUserAssets(userId);
      final duplicateExists = existingAssets.any(
        (asset) => asset.originalFilename.toLowerCase() == fileName.toLowerCase(),
      );

      if (duplicateExists) {
        return left(Failure('Ya tienes un anuncio con este nombre en tu biblioteca. Elige el archivo existente o cámbiale el nombre para continuar.'));
      }

      final fileUrl = await _remoteDataSource.uploadAdContent(
        fileBytes: fileBytes,
        fileName: fileName,
        userId: userId,
      );
      isUploaded = true;

      final fileSizeMb = fileBytes.length / (1024 * 1024);
      final lowerName = fileName.toLowerCase();
      final isVideo = lowerName.endsWith('.mp4') || lowerName.endsWith('.mov') || lowerName.endsWith('.avi') || lowerName.endsWith('.m4v');
      final fileType = isVideo ? 'video' : 'image';

      final assetId = await _remoteDataSource.createCreativeAsset(
        userId: userId,
        fileUrl: fileUrl,
        fileName: fileName,
        fileSizeMb: fileSizeMb,
        fileType: fileType,
      );

      _cachedUserAssets = null;
      _cachedUserId = null;

      return right(assetId);
    } on ServerException catch (e) {
      if (isUploaded) {
        try {
          await _remoteDataSource.deleteAdContent(path);
        } catch (_) {}
      }
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAdAsset({
    required String assetId,
    required String fileName,
    required String userId,
  }) async {
    try {
      await _remoteDataSource.deleteCreativeAsset(assetId);
      final path = '$userId/$fileName';
      await _remoteDataSource.deleteAdContent(path);
      _cachedUserAssets = null;
      _cachedUserId = null;
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CreativeAsset>>> getUserAssets(String userId, {bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _cachedUserId == userId &&
        _cachedUserAssets != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _ttl) {
      return right(_cachedUserAssets!);
    }

    try {
      final assets = await _remoteDataSource.getUserAssets(userId);
      _cachedUserAssets = assets;
      _cachedUserId = userId;
      _lastCacheTime = DateTime.now();
      return right(assets);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
