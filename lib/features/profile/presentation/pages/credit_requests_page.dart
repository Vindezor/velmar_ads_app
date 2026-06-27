import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/bookings_app_bar.dart';
import 'package:velmar_ads/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:velmar_ads/features/profile/presentation/widgets/credit_requests_list.dart';
import 'package:velmar_ads/features/profile/presentation/widgets/credit_requests_error_view.dart';

class CreditRequestsPage extends StatelessWidget {
  const CreditRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.surfaceContainerLowest,
      appBar: const BookingsAppBar(),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return switch (state) {
            ProfileInitial() ||
            ProfileLoading() ||
            ProfileCreditRequestsLoading() ||
            ProfileRequestSubmitting() ||
            ProfileRequestSuccess() ||
            ProfileRequestError() ||
            ProfileLoaded() => const Center(
                child: CircularProgressIndicator(color: AppPallete.primary),
              ),
            ProfileCreditRequestsLoaded(creditRequests: final requests) =>
              CreditRequestsList(creditRequests: requests),
            ProfileCreditRequestsError(message: final msg) ||
            ProfileError(message: final msg) => CreditRequestsErrorView(
                errorMessage: msg,
                onRetry: () {
                  context.read<ProfileBloc>().add(ProfileLoadCreditRequests());
                },
              ),
          };
        },
      ),
    );
  }
}
