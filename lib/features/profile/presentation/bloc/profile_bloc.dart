// ignore_for_file: prefer_initializing_formals

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:velmar_ads/features/profile/domain/entities/profile_details.dart';
import 'package:velmar_ads/features/profile/domain/entities/credit_request.dart';
import 'package:velmar_ads/features/profile/domain/usecases/get_profile_details.dart';
import 'package:velmar_ads/features/profile/domain/usecases/submit_credit_request.dart';
import 'package:velmar_ads/features/profile/domain/usecases/get_credit_requests.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileDetails _getProfileDetails;
  final SubmitCreditRequest _submitCreditRequest;
  final GetCreditRequests _getCreditRequests;
  final AppUserCubit _appUserCubit;

  ProfileBloc({
    required GetProfileDetails getProfileDetails,
    required SubmitCreditRequest submitCreditRequest,
    required GetCreditRequests getCreditRequests,
    required AppUserCubit appUserCubit,
  })  : _getProfileDetails = getProfileDetails,
        _submitCreditRequest = submitCreditRequest,
        _getCreditRequests = getCreditRequests,
        _appUserCubit = appUserCubit,
        super(ProfileInitial()) {
    on<ProfileLoadDetails>(_onLoadDetails);
    on<ProfileSubmitRequest>(_onSubmitRequest);
    on<ProfileLoadCreditRequests>(_onLoadCreditRequests);
    on<ProfileResetState>(_onResetState);
  }

  Future<void> _onLoadDetails(
    ProfileLoadDetails event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileLoaded(
        profileDetails: currentState.profileDetails,
        isRefreshing: true,
      ));
    } else {
      emit(ProfileLoading());
    }

    final userState = _appUserCubit.state;
    if (userState is! AppUserLoggedIn) {
      emit(ProfileError(message: 'Usuario no autenticado.'));
      return;
    }

    final result = await _getProfileDetails(
      GetProfileDetailsParams(
        userId: userState.user.id,
        forceRefresh: event.forceRefresh,
      ),
    );
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (details) => emit(ProfileLoaded(profileDetails: details, isRefreshing: false)),
    );
  }

  Future<void> _onSubmitRequest(
    ProfileSubmitRequest event,
    Emitter<ProfileState> emit,
  ) async {
    final userState = _appUserCubit.state;
    if (userState is! AppUserLoggedIn) {
      emit(ProfileRequestError(message: 'Usuario no autenticado.'));
      return;
    }

    emit(ProfileRequestSubmitting());

    final result = await _submitCreditRequest(
      SubmitCreditRequestParams(
        amount: event.amount,
        fileBytes: event.fileBytes,
        fileName: event.fileName,
        userId: userState.user.id,
        paymentNotes: event.paymentNotes,
      ),
    );

    result.fold(
      (failure) => emit(ProfileRequestError(message: failure.message)),
      (_) => emit(ProfileRequestSuccess()),
    );
  }

  void _onResetState(
    ProfileResetState event,
    Emitter<ProfileState> emit,
  ) {
    emit(ProfileInitial());
  }

  Future<void> _onLoadCreditRequests(
    ProfileLoadCreditRequests event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileCreditRequestsLoaded) {
      emit(ProfileCreditRequestsLoading());
    }

    final userState = _appUserCubit.state;
    if (userState is! AppUserLoggedIn) {
      emit(ProfileCreditRequestsError(message: 'Usuario no autenticado.'));
      return;
    }

    final result = await _getCreditRequests(
      GetCreditRequestsParams(
        userId: userState.user.id,
        forceRefresh: event.forceRefresh,
      ),
    );
    result.fold(
      (failure) => emit(ProfileCreditRequestsError(message: failure.message)),
      (requests) => emit(ProfileCreditRequestsLoaded(creditRequests: requests)),
    );
  }
}
