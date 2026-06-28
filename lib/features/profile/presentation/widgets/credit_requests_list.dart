import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/profile/domain/entities/credit_request.dart';
import 'package:velmar_ads/features/profile/presentation/widgets/credit_requests_header.dart';
import 'package:velmar_ads/features/profile/presentation/widgets/credit_request_card.dart';

class CreditRequestsList extends StatelessWidget {
  final List<CreditRequest> creditRequests;

  const CreditRequestsList({
    super.key,
    required this.creditRequests,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total pending amount
    final totalPending = creditRequests
        .where((r) => r.status.toLowerCase() == 'pending')
        .fold<double>(0.0, (sum, r) => sum + r.creditsRequested);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerPadding,
        vertical: AppSpacing.stackLg,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CreditRequestsHeader(totalPending: totalPending),
              const SizedBox(height: AppSpacing.stackLg),
              if (creditRequests.isEmpty)
                _buildEmptyState()
              else LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 768;
                    final isExtraWide = constraints.maxWidth >= 1100;
                    final crossAxisCount = isExtraWide ? 3 : (isWide ? 2 : 1);
                    
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: AppSpacing.stackLg,
                        crossAxisSpacing: AppSpacing.stackLg,
                        mainAxisExtent: 210, // Fixed height to keep cards aligned
                      ),
                      itemCount: creditRequests.length,
                      itemBuilder: (context, index) {
                        return CreditRequestCard(request: creditRequests[index]);
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 16),
      decoration: BoxDecoration(
        color: AppPallete.surfaceContainerLowest,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppPallete.outlineVariant),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: AppPallete.secondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.gutter),
          Text(
            'Sin solicitudes de crédito',
            style: AppTypography.headlineMd.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppPallete.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.stackSm),
          Text(
            'Aún no has realizado ninguna solicitud de crédito en tu cuenta.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySm.copyWith(
              color: AppPallete.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
