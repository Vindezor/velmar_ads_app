// ignore_for_file: prefer_initializing_formals

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/features/library/domain/usecases/upload_ad_asset.dart';
import 'package:velmar_ads/features/library/domain/usecases/delete_ad_asset.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final UploadAdAsset _uploadAdAsset;
  final DeleteAdAsset _deleteAdAsset;

  LibraryBloc({
    required UploadAdAsset uploadAdAsset,
    required DeleteAdAsset deleteAdAsset,
  })  : _uploadAdAsset = uploadAdAsset,
        _deleteAdAsset = deleteAdAsset,
        super(LibraryInitial()) {
    on<LibraryUploadAsset>(_onUploadAsset);
    on<LibraryDeleteAsset>(_onDeleteAsset);
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

  Future<void> _onDeleteAsset(
    LibraryDeleteAsset event,
    Emitter<LibraryState> emit,
  ) async {
    await _deleteAdAsset(
      DeleteAdAssetParams(
        assetId: event.assetId,
        fileName: event.fileName,
        userId: event.userId,
      ),
    );
  }

  void _onReset(
    LibraryReset event,
    Emitter<LibraryState> emit,
  ) {
    emit(LibraryInitial());
  }
}
