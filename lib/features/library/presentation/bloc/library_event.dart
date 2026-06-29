part of 'library_bloc.dart';

@immutable
sealed class LibraryEvent {}

final class LibraryUploadAsset extends LibraryEvent {
  final List<int> fileBytes;
  final String fileName;
  final String userId;

  LibraryUploadAsset({
    required this.fileBytes,
    required this.fileName,
    required this.userId,
  });
}

final class LibraryDeleteAsset extends LibraryEvent {
  final String assetId;
  final String fileName;
  final String userId;

  LibraryDeleteAsset({
    required this.assetId,
    required this.fileName,
    required this.userId,
  });
}

final class LibraryReset extends LibraryEvent {}

final class LibraryFetchAssets extends LibraryEvent {
  final String userId;
  final bool forceRefresh;
  LibraryFetchAssets({required this.userId, this.forceRefresh = false});
}
