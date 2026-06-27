import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/bookings_app_bar.dart';
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

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

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

    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: const BookingsAppBar(),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return switch (state) {
            ProfileInitial() ||
            ProfileLoading() ||
            ProfileRequestSubmitting() ||
            ProfileRequestSuccess() ||
            ProfileRequestError() => const Center(
                child: CircularProgressIndicator(color: AppPallete.primary),
              ),
            ProfileLoaded(profileDetails: final details) => LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 768;

                  final leftSide = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProfileHeader(user: currentUser),
                      const SizedBox(height: AppSpacing.stackLg),
                      ProfileBalanceCard(credits: details.credits),
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

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.containerPadding,
                        vertical: AppSpacing.stackLg,
                      ),
                      child: Center(
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
                  );
                },
              ),
            ProfileError(message: final msg) => BookingsListErrorView(
                errorMessage: msg,
                onRetry: () {
                  context.read<ProfileBloc>().add(ProfileLoadDetails());
                },
              ),
          };
        },
      ),
    );
  }
}
