// ignore_for_file: prefer_initializing_formals

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/exceptions.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/features/bookings/data/datasources/bookings_remote_data_source.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';
import 'package:velmar_ads/features/bookings/domain/repository/bookings_repository.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  final BookingsRemoteDataSource _remoteDataSource;

  List<Booking>? _cachedUserBookings;
  String? _cachedUserId;
  DateTime? _lastCacheTime;
  static const _ttl = Duration(seconds: 60);

  BookingsRepositoryImpl({required BookingsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<Booking>>> getBillboardBookings(String billboardId) async {
    try {
      final bookings = await _remoteDataSource.getBillboardBookings(billboardId);
      return right(bookings);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, double>> getUserCredits(String userId) async {
    try {
      final credits = await _remoteDataSource.getUserCredits(userId);
      return right(credits);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> getActiveBookingTypeId() async {
    try {
      final typeId = await _remoteDataSource.getActiveBookingTypeId();
      return right(typeId);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> calculateBookingPrice({
    required String billboardId,
    required String bookingTypeId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final priceMap = await _remoteDataSource.calculateBookingPrice(
        billboardId: billboardId,
        bookingTypeId: bookingTypeId,
        startTime: startTime,
        endTime: endTime,
      );
      return right(priceMap);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createBooking({
    required String userId,
    required String billboardId,
    required String bookingTypeId,
    required DateTime startTime,
    required DateTime endTime,
    required String assetId,
  }) async {
    try {
      final result = await _remoteDataSource.createBooking(
        userId: userId,
        billboardId: billboardId,
        bookingTypeId: bookingTypeId,
        startTime: startTime,
        endTime: endTime,
        assetId: assetId,
      );
      if (result['success'] == true) {
        if (kDebugMode) {
          print('📦 [CACHE] Booking creado con éxito. Invalidando cache de bookings para $userId.');
        }
        _cachedUserBookings = null;
        _cachedUserId = null;
        _lastCacheTime = null;
      }
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCreativeAsset(String assetId) async {
    try {
      final result = await _remoteDataSource.getCreativeAsset(assetId);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getUserBookings(String userId, {bool forceRefresh = false}) async {
    // If user changed, invalidate cache immediately
    if (_cachedUserId != null && _cachedUserId != userId) {
      if (kDebugMode) {
        print('📦 [CACHE] Bookings user cambiado de $_cachedUserId a $userId. Invalidando cache.');
      }
      _cachedUserBookings = null;
      _cachedUserId = null;
      _lastCacheTime = null;
    }

    if (!forceRefresh &&
        _cachedUserId == userId &&
        _cachedUserBookings != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _ttl) {
      if (kDebugMode) {
        print('📦 [CACHE HIT] Bookings para $userId');
      }
      return right(_cachedUserBookings!);
    }

    try {
      if (kDebugMode) {
        print('📦 [CACHE MISS] Bookings consultando Supabase para $userId (forceRefresh: $forceRefresh)');
      }
      final bookings = await _remoteDataSource.getUserBookings(userId);
      _cachedUserBookings = bookings;
      _cachedUserId = userId;
      _lastCacheTime = DateTime.now();
      
      if (kDebugMode) {
        print('📦 [CACHE UPDATE] Bookings cache actualizado con ${bookings.length} items para $userId');
      }
      return right(bookings);
    } on ServerException catch (e) {
      if (_cachedUserId == userId && _cachedUserBookings != null) {
        if (kDebugMode) {
          print('📦 [CACHE STALE] Retornando stale bookings tras ServerException: ${e.message}');
        }
        return right(_cachedUserBookings!);
      }
      return left(Failure(e.message));
    } catch (e) {
      if (_cachedUserId == userId && _cachedUserBookings != null) {
        if (kDebugMode) {
          print('📦 [CACHE STALE] Retornando stale bookings tras error inesperado: $e');
        }
        return right(_cachedUserBookings!);
      }
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Booking>> getBookingDetail(String bookingId) async {
    try {
      final booking = await _remoteDataSource.getBookingDetail(bookingId);
      return right(booking);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> resubmitBooking({
    required String bookingId,
    required String assetId,
    String? notes,
  }) async {
    try {
      await _remoteDataSource.resubmitBooking(
        bookingId: bookingId,
        assetId: assetId,
        notes: notes,
      );
      if (kDebugMode) {
        print('📦 [CACHE] Reserva re-enviada. Invalidando cache de bookings.');
      }
      _cachedUserBookings = null;
      _cachedUserId = null;
      _lastCacheTime = null;
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
