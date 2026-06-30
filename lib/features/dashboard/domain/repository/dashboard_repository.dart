import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/dashboard_data.dart';

abstract interface class DashboardRepository {
  Future<Either<Failure, DashboardData>> getDashboardData({
    required String userId,
    bool forceRefresh = false,
  });
}
