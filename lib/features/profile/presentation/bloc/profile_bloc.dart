// ignore_for_file: prefer_initializing_formals

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:velmar_ads/features/profile/domain/entities/profile_details.dart';
import 'package:velmar_ads/features/profile/domain/usecases/get_profile_details.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileDetails _getProfileDetails;
  final AppUserCubit _appUserCubit;

  ProfileBloc({
    required GetProfileDetails getProfileDetails,
    required AppUserCubit appUserCubit,
  })  : _getProfileDetails = getProfileDetails,
        _appUserCubit = appUserCubit,
        super(ProfileInitial()) {
    on<ProfileLoadDetails>(_onLoadDetails);
    on<ProfileResetState>(_onResetState);
  }

  Future<void> _onLoadDetails(
    ProfileLoadDetails event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final userState = _appUserCubit.state;
    if (userState is! AppUserLoggedIn) {
      emit(ProfileError(message: 'Usuario no autenticado.'));
      return;
    }

    final result = await _getProfileDetails(userState.user.id);
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (details) => emit(ProfileLoaded(profileDetails: details)),
    );
  }

  void _onResetState(
    ProfileResetState event,
    Emitter<ProfileState> emit,
  ) {
    emit(ProfileInitial());
  }
}
