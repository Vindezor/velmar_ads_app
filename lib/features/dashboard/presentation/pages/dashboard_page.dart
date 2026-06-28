import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/common/widgets/loader.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:velmar_ads/core/common/widgets/velmar_app_bar.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/dashboard_error_view.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/dashboard_loaded_view.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardBloc _dashboardBloc;
  int? _lastIndex;

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
    // Listen to StatefulNavigationShell index changes
    try {
      final shell = StatefulNavigationShell.of(context);
      final currentIndex = shell.currentIndex;
      
      // If the user just switched to the Dashboard tab (index 0), trigger refresh
      if (currentIndex == 0 && _lastIndex != 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _dashboardBloc.add(DashboardFetchData());
          }
        });
      }
      _lastIndex = currentIndex;
    } catch (_) {
      // In case StatefulNavigationShell is not present in context (e.g. testing)
    }

    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: const VelmarAppBar(showBackButton: false),
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
                  context.pushNamed(
                    'billboard-detail',
                    pathParameters: {'id': billboard.id},
                    extra: billboard,
                  );
                },
              ),
          };
        },
      ),
    );
  }
}
