import 'package:fpdart/fpdart.dart';
import 'package:velmar_ads/core/error/failures.dart';
import 'package:velmar_ads/core/usecase/usecase.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:velmar_ads/features/dashboard/domain/repository/dashboard_repository.dart';

class GetDashboardData implements UseCase<DashboardData, String> {
  final DashboardRepository repository;

  GetDashboardData({required this.repository});

  @override
  Future<Either<Failure, DashboardData>> call(String params) async {
    return await repository.getDashboardData(userId: params);
  }
}
