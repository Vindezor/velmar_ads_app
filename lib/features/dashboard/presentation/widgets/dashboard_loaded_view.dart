import 'package:flutter/material.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/billboard.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/dashboard_inventory_list.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/dashboard_sub_header.dart';

class DashboardLoadedView extends StatelessWidget {
  final DashboardData data;
  final RefreshCallback onRefresh;
  final ValueChanged<Billboard>? onBillboardTap;

  const DashboardLoadedView({
    super.key,
    required this.data,
    required this.onRefresh,
    this.onBillboardTap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardSubHeader(userBalance: data.userBalance),
                  DashboardInventoryList(
                    billboards: data.billboards,
                    onBillboardTap: onBillboardTap,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
