// ignore_for_file: prefer_initializing_formals

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/features/library/domain/entities/creative_asset.dart';
import 'package:velmar_ads/features/library/domain/usecases/upload_ad_asset.dart';
import 'package:velmar_ads/features/library/domain/usecases/delete_ad_asset.dart';
import 'package:velmar_ads/features/library/domain/usecases/get_user_assets.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final UploadAdAsset _uploadAdAsset;
  final DeleteAdAsset _deleteAdAsset;
  final GetUserAssets _getUserAssets;

  LibraryBloc({
    required UploadAdAsset uploadAdAsset,
    required DeleteAdAsset deleteAdAsset,
    required GetUserAssets getUserAssets,
  })  : _uploadAdAsset = uploadAdAsset,
        _deleteAdAsset = deleteAdAsset,
        _getUserAssets = getUserAssets,
        super(LibraryInitial()) {
    on<LibraryUploadAsset>(_onUploadAsset);
    on<LibraryDeleteAsset>(_onDeleteAsset);
    on<LibraryReset>(_onReset);
    on<LibraryFetchAssets>(_onFetchAssets);
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

  Future<void> _onFetchAssets(
    LibraryFetchAssets event,
    Emitter<LibraryState> emit,
  ) async {
    if (state is! LibraryAssetsLoaded) {
      emit(LibraryAssetsLoading());
    }
    final result = await _getUserAssets(
      GetUserAssetsParams(
        userId: event.userId,
        forceRefresh: event.forceRefresh,
      ),
    );
    result.fold(
      (failure) => emit(LibraryAssetsError(message: failure.message)),
      (assets) => emit(LibraryAssetsLoaded(assets: assets)),
    );
  }
}
