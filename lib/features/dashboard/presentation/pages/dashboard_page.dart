import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/core/common/widgets/loader.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/show_snackbar.dart';
import 'package:velmar_ads/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/dashboard_bottom_nav_bar.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/dashboard_error_view.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/dashboard_loaded_view.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardBloc _dashboardBloc;

  @override
  void initState() {
    super.initState();
    _dashboardBloc = context.read<DashboardBloc>();
    _loadData();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dashboardBloc.add(DashboardFetchData());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: const DashboardAppBar(),
      bottomNavigationBar: DashboardBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index > 0) {
            showSnackBar(context: context, message: 'Sección en desarrollo');
          }
        },
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return switch (state) {
            DashboardInitial() || DashboardLoading() => const Center(child: Loader()),
            DashboardError(:final message) => DashboardErrorView(
                message: message,
                onRetry: _loadData,
              ),
            DashboardLoaded(:final data) => DashboardLoadedView(
                data: data,
                onRefresh: () async => _loadData(),
                onBillboardTap: (billboard) {
                  showSnackBar(
                    context: context,
                    message: 'Reservar ${billboard.name}',
                  );
                },
              ),
          };
        },
      ),
    );
  }
}
