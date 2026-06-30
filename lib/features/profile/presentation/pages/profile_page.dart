import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/common/widgets/velmar_app_bar.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/bookings_list_error_view.dart';
import 'package:velmar_ads/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:velmar_ads/features/profile/presentation/widgets/profile_header.dart';
import 'package:velmar_ads/features/profile/presentation/widgets/profile_balance_card.dart';
import 'package:velmar_ads/features/profile/presentation/widgets/profile_movement_list.dart';
import 'package:velmar_ads/features/profile/presentation/widgets/profile_menu_options.dart';
import 'package:velmar_ads/init_dependencies.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ProfileBloc>()..add(ProfileLoadDetails()),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String? _lastLocation;

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<AppUserCubit>().state;
    if (userState is! AppUserLoggedIn) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppPallete.primary),
        ),
      );
    }

    final currentUser = userState.user;

    // Listen to GoRouterState matchedLocation changes
    try {
      final location = GoRouterState.of(context).matchedLocation;
      
      // If the user just switched to the Profile tab (/profile), trigger refresh
      if (location == '/profile' && _lastLocation != '/profile') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.read<ProfileBloc>().add(ProfileLoadDetails(forceRefresh: false));
          }
        });
      }
      _lastLocation = location;
    } catch (_) {
      // In case GoRouterState is not present in context (e.g. testing)
    }

    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: const VelmarAppBar(showBackButton: false),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return switch (state) {
            ProfileInitial() ||
            ProfileLoading() ||
            ProfileRequestSubmitting() ||
            ProfileRequestSuccess() ||
            ProfileRequestError() ||
            ProfileCreditRequestsLoading() ||
            ProfileCreditRequestsLoaded() ||
            ProfileCreditRequestsError() => const Center(
                child: CircularProgressIndicator(color: AppPallete.primary),
              ),
            ProfileLoaded(
              profileDetails: final details,
            ) =>
                LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 768;

                final leftSide = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfileHeader(user: currentUser),
                    const SizedBox(height: AppSpacing.stackLg),
                    ProfileBalanceCard(
                      credits: details.credits,
                    ),
                    const SizedBox(height: AppSpacing.stackLg),
                    if (!isWide) ...[
                      ProfileMovementList(
                        credits: details.credits,
                        movements: details.movements,
                      ),
                      const SizedBox(height: AppSpacing.stackLg),
                    ],
                    const ProfileMenuOptions(),
                  ],
                );

                return RefreshIndicator(
                  onRefresh: () async {
                    final bloc = context.read<ProfileBloc>();
                    bloc.add(ProfileLoadDetails(forceRefresh: true));
                    // Esperar a que termine de recargar (isRefreshing sea false) o falle
                    await bloc.stream.firstWhere((state) {
                      if (state is ProfileLoaded) {
                        return !state.isRefreshing;
                      }
                      return true; // Detener en caso de error u otro estado
                    });
                  },
                  color: AppPallete.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.containerPadding,
                          vertical: AppSpacing.stackLg,
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: AppSpacing.maxWidth,
                            ),
                            child: isWide
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: leftSide,
                                      ),
                                      const SizedBox(width: AppSpacing.stackLg),
                                      Expanded(
                                        flex: 7,
                                        child: ProfileMovementList(
                                          credits: details.credits,
                                          movements: details.movements,
                                        ),
                                      ),
                                    ],
                                  )
                                : leftSide,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            ProfileError(message: final msg) => BookingsListErrorView(
                errorMessage: msg,
                onRetry: () {
                  context.read<ProfileBloc>().add(ProfileLoadDetails(forceRefresh: true));
                },
              ),
          };
        },
      ),
    );
  }
}
