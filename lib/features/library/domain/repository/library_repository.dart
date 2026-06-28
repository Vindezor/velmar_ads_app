import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/features/library/domain/entities/creative_asset.dart';

abstract interface class LibraryRepository {
  Future<Either<Failure, String>> uploadAdAsset({
    required List<int> fileBytes,
    required String fileName,
    required String userId,
  });

  Future<Either<Failure, void>> deleteAdAsset({
    required String assetId,
    required String fileName,
    required String userId,
  });

  Future<Either<Failure, List<CreativeAsset>>> getUserAssets(String userId);
}
