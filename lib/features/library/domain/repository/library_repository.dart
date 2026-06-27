import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';

abstract interface class LibraryRepository {
  Future<Either<Failure, String>> uploadAdAsset({
    required List<int> fileBytes,
    required String fileName,
    required String userId,
  });
}
