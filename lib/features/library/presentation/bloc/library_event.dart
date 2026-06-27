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

final class LibraryReset extends LibraryEvent {}
