import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/exceptions.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:velmar_ads/features/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardData? _cachedData;
  String? _cachedUserId;
  DateTime? _lastCacheTime;
  static const _ttl = Duration(seconds: 30);

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardData>> getDashboardData({
    required String userId,
    bool forceRefresh = false,
  }) async {
    // If user changed, invalidate cache immediately
    if (_cachedUserId != null && _cachedUserId != userId) {
      if (kDebugMode) {
        print('📦 [CACHE] Dashboard user cambiado de $_cachedUserId a $userId. Invalidando cache.');
      }
      _cachedData = null;
      _cachedUserId = null;
      _lastCacheTime = null;
    }

    if (!forceRefresh &&
        _cachedUserId == userId &&
        _cachedData != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _ttl) {
      if (kDebugMode) {
        print('📦 [CACHE HIT] Dashboard data para $userId');
      }
      return right(_cachedData!);
    }

    try {
      if (kDebugMode) {
        print('📦 [CACHE MISS] Dashboard data consultando Supabase para $userId (forceRefresh: $forceRefresh)');
      }
      // Fetch billboards and balance in parallel for better performance
      final results = await Future.wait([
        remoteDataSource.getBillboards(),
        remoteDataSource.getUserBalance(userId),
      ]);

      final billboards = results[0] as List<dynamic>;
      final balance = results[1] as double;

      final dashboardData = DashboardData(
        billboards: billboards.cast(),
        userBalance: balance,
      );

      _cachedData = dashboardData;
      _cachedUserId = userId;
      _lastCacheTime = DateTime.now();

      if (kDebugMode) {
        print('📦 [CACHE UPDATE] Dashboard cache actualizado para $userId');
      }

      return right(dashboardData);
    } on ServerException catch (e) {
      if (_cachedUserId == userId && _cachedData != null) {
        if (kDebugMode) {
          print('📦 [CACHE STALE] Retornando stale dashboard tras ServerException: ${e.message}');
        }
        return right(_cachedData!);
      }
      return left(Failure(e.message));
    } catch (e) {
      if (_cachedUserId == userId && _cachedData != null) {
        if (kDebugMode) {
          print('📦 [CACHE STALE] Retornando stale dashboard tras error inesperado: $e');
        }
        return right(_cachedData!);
      }
      return left(Failure(e.toString()));
    }
  }
}
