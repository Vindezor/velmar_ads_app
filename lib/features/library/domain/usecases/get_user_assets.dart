// ignore_for_file: prefer_initializing_formals

import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/library/domain/entities/creative_asset.dart';
import 'package:velmar_ads/features/library/domain/repository/library_repository.dart';

class GetUserAssets implements UseCase<List<CreativeAsset>, String> {
  final LibraryRepository _libraryRepository;

  GetUserAssets({required LibraryRepository libraryRepository})
      : _libraryRepository = libraryRepository;

  @override
  Future<Either<Failure, List<CreativeAsset>>> call(String userId) async {
    return await _libraryRepository.getUserAssets(userId);
  }
}
