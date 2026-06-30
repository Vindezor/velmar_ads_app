// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/library/domain/entities/creative_asset.dart';
import 'package:velmar_ads/features/library/domain/repository/library_repository.dart';

class GetUserAssetsParams {
  final String userId;
  final bool forceRefresh;

  GetUserAssetsParams({
    required this.userId,
    this.forceRefresh = false,
  });
}

class GetUserAssets implements UseCase<List<CreativeAsset>, GetUserAssetsParams> {
  final LibraryRepository _libraryRepository;

  GetUserAssets({required LibraryRepository libraryRepository})
      : _libraryRepository = libraryRepository;

  @override
  Future<Either<Failure, List<CreativeAsset>>> call(GetUserAssetsParams params) async {
    return await _libraryRepository.getUserAssets(
      params.userId,
      forceRefresh: params.forceRefresh,
    );
  }
}
