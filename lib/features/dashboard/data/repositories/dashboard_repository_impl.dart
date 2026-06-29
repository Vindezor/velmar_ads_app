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
  static const _ttl = Duration(seconds: 60);

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardData>> getDashboardData({
    required String userId,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh &&
        _cachedUserId == userId &&
        _cachedData != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _ttl) {
      return right(_cachedData!);
    }

    try {
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

      return right(dashboardData);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
