// ignore_for_file: prefer_initializing_formals

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
        _cachedUserBookings = null;
        _cachedUserId = null;
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
    if (!forceRefresh &&
        _cachedUserId == userId &&
        _cachedUserBookings != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _ttl) {
      return right(_cachedUserBookings!);
    }

    try {
      final bookings = await _remoteDataSource.getUserBookings(userId);
      _cachedUserBookings = bookings;
      _cachedUserId = userId;
      _lastCacheTime = DateTime.now();
      return right(bookings);
    } on ServerException catch (e) {
      return left(Failure(e.message));
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
      _cachedUserBookings = null;
      _cachedUserId = null;
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
