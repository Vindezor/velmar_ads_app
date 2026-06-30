// ignore_for_file: prefer_initializing_formals

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:velmar_ads/features/dashboard/domain/usecases/get_dashboard_data.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardData _getDashboardData;
  final AppUserCubit _appUserCubit;

  DashboardBloc({
    required GetDashboardData getDashboardData,
    required AppUserCubit appUserCubit,
  })  : _getDashboardData = getDashboardData,
        _appUserCubit = appUserCubit,
        super(DashboardInitial()) {
    on<DashboardFetchData>(_onFetchData);
  }

  Future<void> _onFetchData(
    DashboardFetchData event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is! DashboardLoaded) {
      emit(DashboardLoading());
    }

    final userState = _appUserCubit.state;
    if (userState is! AppUserLoggedIn) {
      emit(DashboardError(message: 'Usuario no autenticado'));
      return;
    }

    final userId = userState.user.id;
    final res = await _getDashboardData(
      GetDashboardDataParams(
        userId: userId,
        forceRefresh: event.forceRefresh,
      ),
    );

    res.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (data) => emit(DashboardLoaded(data: data)),
    );
  }
}
