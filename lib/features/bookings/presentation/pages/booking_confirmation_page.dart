import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/show_snackbar.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/billboard.dart';
import 'package:velmar_ads/features/bookings/presentation/bloc/bookings_bloc.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/confirmation_app_bar.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/confirmation_header.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/confirmation_asset_card.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/confirmation_details_bento.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/confirmation_pricing_breakdown.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/confirmation_wallet_impact.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/confirmation_action_area.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/booking_success_view.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/booking_error_view.dart';

class BookingConfirmationPage extends StatelessWidget {
  final Billboard? billboard;
  final DateTime? selectedDate;
  final List<int>? selectedSlots;
  final String? assetId;

  const BookingConfirmationPage({
    super.key,
    required this.billboard,
    required this.selectedDate,
    required this.selectedSlots,
    required this.assetId,
  });

  void _confirmBooking(BuildContext context) {
    if (billboard == null || assetId == null) {
      showSnackBar(context: context, message: 'Faltan datos de la reserva.');
      return;
    }

    final userState = context.read<AppUserCubit>().state;
    if (userState is! AppUserLoggedIn) {
      showSnackBar(context: context, message: 'Usuario no autenticado.');
      return;
    }

    context.read<BookingsBloc>().add(
          BookingsSubmitCheckout(
            userId: userState.user.id,
            billboardId: billboard!.id,
            assetId: assetId!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    if (billboard == null || selectedDate == null || selectedSlots == null || assetId == null) {
      return const Scaffold(
        appBar: ConfirmationAppBar(),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.containerPadding),
            child: Text(
              'Faltan datos de la reserva para continuar.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppPallete.error),
            ),
          ),
        ),
      );
    }

    return BlocConsumer<BookingsBloc, BookingsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return switch (state) {
          BookingsInitial() || BookingsConfirmationLoading() => const Scaffold(
              backgroundColor: AppPallete.background,
              appBar: ConfirmationAppBar(),
              body: Center(child: CircularProgressIndicator()),
            ),
          BookingsConfirmationLoadFailure(:final error) => Scaffold(
              appBar: const ConfirmationAppBar(),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.containerPadding),
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyLg.copyWith(color: AppPallete.error),
                  ),
                ),
              ),
            ),
          BookingsConfirmationSuccess() => Scaffold(
              backgroundColor: AppPallete.background,
              appBar: const ConfirmationAppBar(),
              body: BookingSuccessView(
                billboard: billboard!,
                startTime: DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  (List<int>.from(selectedSlots!)..sort()).first,
                ),
                endTime: DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  (List<int>.from(selectedSlots!)..sort()).last + 1,
                ),
              ),
            ),
          BookingsConfirmationFailure(:final error, :final currentBalance, :final priceData) => Scaffold(
              backgroundColor: AppPallete.background,
              appBar: const ConfirmationAppBar(),
              body: BookingErrorView(
                errorMessage: error,
                currentBalance: currentBalance,
                totalCredits: (priceData['total'] as num?)?.toDouble() ?? 0.0,
                onRetry: () {
                  context.read<BookingsBloc>().add(
                        BookingsLoadConfirmationData(
                          userId: (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id,
                          billboardId: billboard!.id,
                          selectedDate: selectedDate!,
                          selectedSlots: selectedSlots!,
                          assetId: assetId!,
                        ),
                      );
                },
              ),
            ),
          BookingsConfirmationLoaded() ||
          BookingsConfirmationSubmitting() =>
            _buildConfirmationView(context, state),
          _ => const Scaffold(
              backgroundColor: AppPallete.background,
              appBar: ConfirmationAppBar(),
              body: Center(child: CircularProgressIndicator()),
            ),
        };
      },
    );
  }

  Widget _buildConfirmationView(BuildContext context, BookingsState state) {
    final double currentBalance;
    final Map<String, dynamic> priceData;
    final Map<String, dynamic> assetData;
    final bool isSubmitting;

    switch (state) {
      case BookingsConfirmationLoaded():
        currentBalance = state.currentBalance;
        priceData = state.priceData;
        assetData = state.assetData;
        isSubmitting = false;
      case BookingsConfirmationSubmitting():
        currentBalance = state.currentBalance;
        priceData = state.priceData;
        assetData = state.assetData;
        isSubmitting = true;
      case BookingsConfirmationFailure():
        currentBalance = state.currentBalance;
        priceData = state.priceData;
        assetData = state.assetData;
        isSubmitting = false;
      default:
        currentBalance = 0.0;
        priceData = const {};
        assetData = const {};
        isSubmitting = false;
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isLargeScreen = screenWidth > 900;

    final originalFilename = assetData['original_filename'] as String? ?? 'N/A';
    final fileType = assetData['file_type'] as String? ?? 'N/A';
    final fileSizeMb = (assetData['file_size_mb'] as num?)?.toDouble() ?? 0.0;
    final fileUrl = assetData['file_url'] as String? ?? '';

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppPallete.background,
          appBar: const ConfirmationAppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerPadding,
                vertical: AppSpacing.stackLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ConfirmationHeader(),
                  const SizedBox(height: AppSpacing.stackLg),
                  if (isLargeScreen)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column: Asset & Bento Details
                        Expanded(
                          flex: 7,
                          child: Column(
                            children: [
                              ConfirmationAssetCard(
                                originalFilename: originalFilename,
                                fileType: fileType,
                                fileSizeMb: fileSizeMb,
                                fileUrl: fileUrl,
                              ),
                              const SizedBox(height: AppSpacing.stackLg),
                              ConfirmationDetailsBento(
                                billboard: billboard!,
                                selectedDate: selectedDate!,
                                selectedSlots: selectedSlots!,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.stackLg),
                        // Right Column: Price Breakdown, Wallet & Actions
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              ConfirmationPricingBreakdown(
                                selectedHours: selectedSlots!.length,
                                basePrice: billboard!.pricePerHour,
                                priceData: priceData,
                              ),
                              const SizedBox(height: AppSpacing.stackLg),
                              ConfirmationWalletImpact(
                                currentBalance: currentBalance,
                                amountToDeduct: (priceData['total'] as num?)?.toDouble() ??
                                    (selectedSlots!.length * billboard!.pricePerHour),
                              ),
                              const SizedBox(height: AppSpacing.stackLg),
                              ConfirmationActionArea(
                                onConfirm: () => _confirmBooking(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        ConfirmationAssetCard(
                          originalFilename: originalFilename,
                          fileType: fileType,
                          fileSizeMb: fileSizeMb,
                          fileUrl: fileUrl,
                        ),
                        const SizedBox(height: AppSpacing.stackLg),
                        ConfirmationDetailsBento(
                          billboard: billboard!,
                          selectedDate: selectedDate!,
                          selectedSlots: selectedSlots!,
                        ),
                        const SizedBox(height: AppSpacing.stackLg),
                        ConfirmationPricingBreakdown(
                          selectedHours: selectedSlots!.length,
                          basePrice: billboard!.pricePerHour,
                          priceData: priceData,
                        ),
                        const SizedBox(height: AppSpacing.stackLg),
                        ConfirmationWalletImpact(
                          currentBalance: currentBalance,
                          amountToDeduct: (priceData['total'] as num?)?.toDouble() ??
                              (selectedSlots!.length * billboard!.pricePerHour),
                        ),
                        const SizedBox(height: AppSpacing.stackLg),
                        ConfirmationActionArea(
                          onConfirm: () => _confirmBooking(context),
                        ),
                      ],
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
        if (isSubmitting)
          Positioned.fill(
            child: Container(
              color: Colors.black38,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
