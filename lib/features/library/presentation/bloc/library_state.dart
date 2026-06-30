part of 'library_bloc.dart';

@immutable
sealed class LibraryState {}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryUploadSuccess extends LibraryState {
  final String assetId;
  LibraryUploadSuccess({required this.assetId});
}

class LibraryUploadFailure extends LibraryState {
  final String error;
  LibraryUploadFailure({required this.error});
}

class LibraryAssetsLoading extends LibraryState {}

class LibraryAssetsLoaded extends LibraryState {
  final List<CreativeAsset> assets;
  LibraryAssetsLoaded({required this.assets});
}

class LibraryAssetsError extends LibraryState {
  final String message;
  LibraryAssetsError({required this.message});
}
