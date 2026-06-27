// ignore_for_file: prefer_initializing_formals

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/get_billboard_bookings.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/calculate_booking_price.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/get_active_booking_type_id.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/get_user_credits.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/get_creative_asset.dart';
import 'package:velmar_ads/features/bookings/domain/usecases/get_user_bookings.dart';
import 'package:velmar_ads/core/common/cubits/app_user/app_user_cubit.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final GetBillboardBookings _getBillboardBookings;
  final GetUserCredits _getUserCredits;
  final GetActiveBookingTypeId _getActiveBookingTypeId;
  final CalculateBookingPrice _calculateBookingPrice;
  final CreateBookingUseCase _createBookingUseCase;
  final GetCreativeAsset _getCreativeAsset;
  final GetUserBookings _getUserBookings;
  final AppUserCubit _appUserCubit;

  BookingsBloc({
    required GetBillboardBookings getBillboardBookings,
    required GetUserCredits getUserCredits,
    required GetActiveBookingTypeId getActiveBookingTypeId,
    required CalculateBookingPrice calculateBookingPrice,
    required CreateBookingUseCase createBookingUseCase,
    required GetCreativeAsset getCreativeAsset,
    required GetUserBookings getUserBookings,
    required AppUserCubit appUserCubit,
  })  : _getBillboardBookings = getBillboardBookings,
        _getUserCredits = getUserCredits,
        _getActiveBookingTypeId = getActiveBookingTypeId,
        _calculateBookingPrice = calculateBookingPrice,
        _createBookingUseCase = createBookingUseCase,
        _getCreativeAsset = getCreativeAsset,
        _getUserBookings = getUserBookings,
        _appUserCubit = appUserCubit,
        super(BookingsInitial()) {
    on<BookingsFetchAvailability>(_onFetchAvailability);
    on<BookingsLoadConfirmationData>(_onLoadConfirmationData);
    on<BookingsSubmitCheckout>(_onSubmitCheckout);
    on<BookingsLoadUserBookings>(_onLoadUserBookings);
  }

  Future<void> _onFetchAvailability(
    BookingsFetchAvailability event,
    Emitter<BookingsState> emit,
  ) async {
    emit(BookingsAvailabilityLoading());
    final res = await _getBillboardBookings(event.billboardId);
    res.fold(
      (failure) => emit(BookingsAvailabilityError(message: failure.message)),
      (bookings) => emit(BookingsAvailabilityLoaded(bookings: bookings)),
    );
  }

  Future<void> _onLoadConfirmationData(
    BookingsLoadConfirmationData event,
    Emitter<BookingsState> emit,
  ) async {
    emit(BookingsConfirmationLoading());

    // 1. Obtener saldo, tipo de reserva activo y asset en paralelo
    final profileResFuture = _getUserCredits(event.userId);
    final bookingTypeResFuture = _getActiveBookingTypeId(NoParams());
    final assetResFuture = _getCreativeAsset(event.assetId);

    final results = await Future.wait([profileResFuture, bookingTypeResFuture, assetResFuture]);

    final profileRes = results[0] as Either<Failure, double>;
    final bookingTypeRes = results[1] as Either<Failure, String>;
    final assetRes = results[2] as Either<Failure, Map<String, dynamic>>;

    double currentBalance = 0.0;
    String bookingTypeId = '';
    Map<String, dynamic> assetData = {};

    bool hasError = false;
    String errorMessage = '';

    profileRes.fold(
      (failure) {
        hasError = true;
        errorMessage = failure.message;
      },
      (credits) => currentBalance = credits,
    );

    if (hasError) {
      emit(BookingsConfirmationLoadFailure(error: errorMessage));
      return;
    }

    bookingTypeRes.fold(
      (failure) {
        hasError = true;
        errorMessage = failure.message;
      },
      (typeId) => bookingTypeId = typeId,
    );

    if (hasError) {
      emit(BookingsConfirmationLoadFailure(error: errorMessage));
      return;
    }

    assetRes.fold(
      (failure) {
        hasError = true;
        errorMessage = failure.message;
      },
      (data) => assetData = data,
    );

    if (hasError) {
      emit(BookingsConfirmationLoadFailure(error: errorMessage));
      return;
    }

    // 2. Calcular inicio y fin
    final sortedSlots = List<int>.from(event.selectedSlots)..sort();
    if (sortedSlots.isEmpty) {
      emit(BookingsConfirmationLoadFailure(error: 'No se seleccionaron horarios de reserva.'));
      return;
    }
    final minHour = sortedSlots.first;
    final maxHour = sortedSlots.last;

    final startTime = DateTime(
      event.selectedDate.year,
      event.selectedDate.month,
      event.selectedDate.day,
      minHour,
    );
    final endTime = DateTime(
      event.selectedDate.year,
      event.selectedDate.month,
      event.selectedDate.day,
      maxHour + 1,
    );

    // 3. Calcular precio
    final priceRes = await _calculateBookingPrice(
      CalculateBookingPriceParams(
        billboardId: event.billboardId,
        bookingTypeId: bookingTypeId,
        startTime: startTime.toUtc(),
        endTime: endTime.toUtc(),
      ),
    );

    priceRes.fold(
      (failure) => emit(BookingsConfirmationLoadFailure(error: failure.message)),
      (priceMap) {
        emit(
          BookingsConfirmationLoaded(
            currentBalance: currentBalance,
            bookingTypeId: bookingTypeId,
            startTime: startTime,
            endTime: endTime,
            priceData: priceMap,
            assetData: assetData,
          ),
        );
      },
    );
  }

  Future<void> _onSubmitCheckout(
    BookingsSubmitCheckout event,
    Emitter<BookingsState> emit,
  ) async {
    final DateTime startTime;
    final DateTime endTime;
    final double currentBalance;
    final String bookingTypeId;
    final Map<String, dynamic> priceData;
    final Map<String, dynamic> assetData;

    final currentState = state;
    if (currentState is BookingsConfirmationLoaded) {
      currentBalance = currentState.currentBalance;
      bookingTypeId = currentState.bookingTypeId;
      startTime = currentState.startTime;
      endTime = currentState.endTime;
      priceData = currentState.priceData;
      assetData = currentState.assetData;
    } else if (currentState is BookingsConfirmationFailure) {
      currentBalance = currentState.currentBalance;
      bookingTypeId = currentState.bookingTypeId;
      startTime = currentState.startTime;
      endTime = currentState.endTime;
      priceData = currentState.priceData;
      assetData = currentState.assetData;
    } else {
      return;
    }

    emit(
      BookingsConfirmationSubmitting(
        currentBalance: currentBalance,
        bookingTypeId: bookingTypeId,
        startTime: startTime,
        endTime: endTime,
        priceData: priceData,
        assetData: assetData,
      ),
    );

    final result = await _createBookingUseCase(
      CreateBookingParams(
        userId: event.userId,
        billboardId: event.billboardId,
        bookingTypeId: bookingTypeId,
        startTime: startTime.toUtc(),
        endTime: endTime.toUtc(),
        assetId: event.assetId,
      ),
    );

    result.fold(
      (failure) => emit(
        BookingsConfirmationFailure(
          error: failure.message,
          currentBalance: currentBalance,
          bookingTypeId: bookingTypeId,
          startTime: startTime,
          endTime: endTime,
          priceData: priceData,
          assetData: assetData,
        ),
      ),
      (response) {
        if (response['success'] == true) {
          emit(BookingsConfirmationSuccess());
        } else {
          emit(
            BookingsConfirmationFailure(
              error: response['error'] ?? 'Error desconocido al crear la reserva.',
              currentBalance: currentBalance,
              bookingTypeId: bookingTypeId,
              startTime: startTime,
              endTime: endTime,
              priceData: priceData,
              assetData: assetData,
            ),
          );
        }
      },
    );
  }

  Future<void> _onLoadUserBookings(
    BookingsLoadUserBookings event,
    Emitter<BookingsState> emit,
  ) async {
    emit(BookingsUserBookingsLoading());
    final userState = _appUserCubit.state;
    if (userState is! AppUserLoggedIn) {
      emit(BookingsUserBookingsError(message: 'Usuario no autenticado.'));
      return;
    }
    final res = await _getUserBookings(userState.user.id);
    res.fold(
      (failure) => emit(BookingsUserBookingsError(message: failure.message)),
      (bookings) => emit(BookingsUserBookingsLoaded(bookings: bookings)),
    );
  }
}
