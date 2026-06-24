import 'package:velmar_ads/features/dashboard/domain/entities/billboard.dart';

class DashboardData {
  final List<Billboard> billboards;
  final double userBalance;

  DashboardData({
    required this.billboards,
    required this.userBalance,
  });
}
