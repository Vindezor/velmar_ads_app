import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/exceptions.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:velmar_ads/features/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  const DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardData>> getDashboardData({
    required String userId,
  }) async {
    try {
      // Fetch billboards and balance in parallel for better performance
      final results = await Future.wait([
        remoteDataSource.getBillboards(),
        remoteDataSource.getUserBalance(userId),
      ]);

      final billboards = results[0] as List<dynamic>;
      final balance = results[1] as double;

      return right(
        DashboardData(
          billboards: billboards.cast(),
          userBalance: balance,
        ),
      );
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
