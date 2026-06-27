// ignore_for_file: prefer_initializing_formals

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/features/library/domain/usecases/upload_ad_asset.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final UploadAdAsset _uploadAdAsset;

  LibraryBloc({required UploadAdAsset uploadAdAsset})
      : _uploadAdAsset = uploadAdAsset,
        super(LibraryInitial()) {
    on<LibraryUploadAsset>(_onUploadAsset);
    on<LibraryReset>(_onReset);
  }

  Future<void> _onUploadAsset(
    LibraryUploadAsset event,
    Emitter<LibraryState> emit,
  ) async {
    emit(LibraryLoading());

    final result = await _uploadAdAsset(
      UploadAdAssetParams(
        fileBytes: event.fileBytes,
        fileName: event.fileName,
        userId: event.userId,
      ),
    );

    result.fold(
      (failure) => emit(LibraryUploadFailure(error: failure.message)),
      (assetId) => emit(LibraryUploadSuccess(assetId: assetId)),
    );
  }

  void _onReset(
    LibraryReset event,
    Emitter<LibraryState> emit,
  ) {
    emit(LibraryInitial());
  }
}
