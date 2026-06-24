import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/show_snackbar.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/billboard.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/billboard_detail_action_bar.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/billboard_detail_app_bar.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/billboard_detail_availability.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/billboard_detail_hero.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/billboard_detail_info.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/billboard_detail_photos.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/billboard_detail_rates.dart';
import 'package:velmar_ads/features/dashboard/presentation/widgets/billboard_detail_specs.dart';

class BillboardDetailPage extends StatelessWidget {
  final Billboard? billboard;

  const BillboardDetailPage({
    super.key,
    required this.billboard,
  });

  @override
  Widget build(BuildContext context) {
    if (billboard == null) {
      return const Scaffold(
        appBar: BillboardDetailAppBar(),
        body: Center(
          child: Text('Pantalla no encontrada'),
        ),
      );
    }

    final b = billboard!;

    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: const BillboardDetailAppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100), // Espacio para evitar que la barra de acción solape el contenido
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BillboardDetailHero(imageUrl: b.imageUrl),
                  BillboardDetailInfo(
                    name: b.name,
                    address: b.address,
                    screenClassLabel: b.screenClassLabel,
                    widthM: b.widthM,
                    heightM: b.heightM,
                  ),
                  const BillboardDetailPhotos(),
                  const SizedBox(height: 16),
                  BillboardDetailRates(basePricePerHour: b.pricePerHour),
                  const SizedBox(height: 24),
                  const BillboardDetailAvailability(),
                  const SizedBox(height: 24),
                  BillboardDetailSpecs(
                    resolutionW: b.resolutionW,
                    resolutionH: b.resolutionH,
                    acceptedFormats: b.acceptedFormats,
                    maxFileSizeMb: b.maxFileSizeMb,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BillboardDetailActionBar(
              onPressed: () {
                showSnackBar(
                  context: context,
                  message: 'Seleccionar horario para ${b.name}',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
