import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/core/common/widgets/loader.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/show_snackbar.dart';
import 'package:velmar_ads/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/billboard_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardBloc>().add(DashboardFetchData());
    });
  }

  String _formatCurrency(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    final buffer = StringBuffer();
    int count = 0;
    for (int i = integerPart.length - 1; i >= 0; i--) {
      buffer.write(integerPart[i]);
      count++;
      if (count == 3 && i > 0) {
        buffer.write(',');
        count = 0;
      }
    }
    final reversedInteger = buffer.toString().split('').reversed.join('');
    return '\$$reversedInteger.$decimalPart';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: AppBar(
        backgroundColor: AppPallete.surfaceContainerLowest,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Velmar Ads',
          style: AppTypography.headlineMd.copyWith(
            color: AppPallete.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppPallete.primary),
            onPressed: () {
              showSnackBar(context: context, message: 'No hay notificaciones nuevas');
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return const Center(child: Loader());
          }

          if (state is DashboardError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.containerPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppPallete.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar el dashboard',
                      style: AppTypography.labelMd.copyWith(
                        color: AppPallete.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: AppTypography.bodySm.copyWith(
                        color: AppPallete.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DashboardBloc>().add(DashboardFetchData());
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is DashboardLoaded) {
            final data = state.data;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(DashboardFetchData());
              },
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
                    // Sub-Header: Balance & Toggle
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.containerPadding,
                        vertical: AppSpacing.stackMd,
                      ),
                      decoration: BoxDecoration(
                        color: AppPallete.background,
                        border: Border(
                          bottom: BorderSide(
                            color: AppPallete.borderColor.withValues(alpha: 0.5),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Balance info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Available Balance',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppPallete.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatCurrency(data.userBalance),
                                style: AppTypography.headlineMd.copyWith(
                                  color: AppPallete.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          // Map/List Segmented Toggle
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppPallete.surfaceContainer,
                              borderRadius: AppRadius.borderDefault,
                              border: Border.all(
                                color: AppPallete.borderColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                // Map Button (disabled style)
                                InkWell(
                                  onTap: () {
                                    showSnackBar(
                                      context: context,
                                      message: 'Mapa deshabilitado temporalmente',
                                    );
                                  },
                                  borderRadius: AppRadius.borderSm,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.map_outlined,
                                          size: 18,
                                          color: AppPallete.onSurfaceVariant,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Map',
                                          style: AppTypography.labelMd.copyWith(
                                            color: AppPallete.onSurfaceVariant,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // List Button (active style)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppPallete.surfaceContainerLowest,
                                    borderRadius: AppRadius.borderSm,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.format_list_bulleted,
                                        size: 18,
                                        color: AppPallete.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'List',
                                        style: AppTypography.labelMd.copyWith(
                                          color: AppPallete.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Main Inventory Listing
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.containerPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Nearby Inventory',
                                style: AppTypography.labelMd.copyWith(
                                  color: AppPallete.onSurface,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                '${data.billboards.length} Screens found',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppPallete.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Inventory List
                          if (data.billboards.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 40.0),
                                child: Text(
                                  'No hay pantallas disponibles en esta zona.',
                                  style: AppTypography.bodyMd.copyWith(
                                    color: AppPallete.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.billboards.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final billboard = data.billboards[index];
                                return BillboardCard(
                                  billboard: billboard,
                                  onTap: () {
                                    showSnackBar(
                                      context: context,
                                      message: 'Reservar ${billboard.name}',
                                    );
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppPallete.background,
        border: Border(
          top: BorderSide(
            color: AppPallete.borderColor.withValues(alpha: 0.5),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Active Tab: Map (Inventory Explore)
              _buildNavBarItem(
                icon: Icons.map,
                label: 'Map',
                isActive: true,
                onTap: () {},
              ),
              // Inactive Tabs
              _buildNavBarItem(
                icon: Icons.calendar_today_outlined,
                label: 'My Bookings',
                isActive: false,
                onTap: () {
                  showSnackBar(context: context, message: 'Sección en desarrollo');
                },
              ),
              _buildNavBarItem(
                icon: Icons.folder_open_outlined,
                label: 'Library',
                isActive: false,
                onTap: () {
                  showSnackBar(context: context, message: 'Sección en desarrollo');
                },
              ),
              _buildNavBarItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isActive: false,
                onTap: () {
                  showSnackBar(context: context, message: 'Sección en desarrollo');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color = isActive ? AppPallete.primary : AppPallete.secondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSm.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
