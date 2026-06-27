import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/bookings/domain/entities/booking.dart';
import 'package:velmar_ads/features/bookings/presentation/bloc/bookings_bloc.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/bookings_app_bar.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/correction_warning_banner.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/correction_rejected_asset_card.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/correction_upload_zone.dart';
import 'package:velmar_ads/features/bookings/presentation/widgets/correction_specs_box.dart';
import 'package:velmar_ads/features/library/presentation/bloc/library_bloc.dart';
import 'package:velmar_ads/init_dependencies.dart';

class BookingCorrectionPage extends StatelessWidget {
  final Booking booking;

  const BookingCorrectionPage({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<LibraryBloc>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<BookingsBloc>(),
        ),
      ],
      child: BookingCorrectionView(booking: booking),
    );
  }
}

class BookingCorrectionView extends StatefulWidget {
  final Booking booking;

  const BookingCorrectionView({
    super.key,
    required this.booking,
  });

  @override
  State<BookingCorrectionView> createState() => _BookingCorrectionViewState();
}

class _BookingCorrectionViewState extends State<BookingCorrectionView>
    with SingleTickerProviderStateMixin {
  late AnimationController _uploadController;
  double _uploadProgress = 0.0;
  CorrectionUploadState _uploadState = CorrectionUploadState.idle;
  String? _uploadedAssetId;
  String? _uploadedFileName;

  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _uploadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _uploadController.addListener(() {
      setState(() {
        _uploadProgress = _uploadController.value;
      });
    });

    _uploadController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final libraryState = context.read<LibraryBloc>().state;
        if (libraryState is LibraryUploadSuccess) {
          setState(() {
            _uploadState = CorrectionUploadState.completed;
            _uploadedAssetId = libraryState.assetId;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _uploadController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _startUpload() async {
    final userState = context.read<AppUserCubit>().state;
    if (userState is! AppUserLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario no autenticado.')),
      );
      return;
    }
    final userId = userState.user.id;

    setState(() {
      _uploadState = CorrectionUploadState.uploading;
      _uploadProgress = 0.0;
      _uploadedAssetId = null;
    });

    _uploadController.forward(from: 0.0);

    try {
      const url = 'https://lh3.googleusercontent.com/aida-public/AB6AXuDY0w3KW2MBy0AEYCjjQn92MQVdy-tETVgM-QMKfdGbpJLYz2QSCfnO4jx71zptYuQlyj-hWmg2Y92DP4LDVH_capKE6qMu0iodkV4WogjUeb02ryVaVIHjQjQ_VCgrvM972XpgbjHYOcmXTxPQfG6IMAM2ma36oZJuOSp3b0MgnKZxgfy0faZpfKKMy0kRuthlfFnNsZ45dQwzlXX-FPaW0mlLEIFLV6DBBXT8AwlOckA78ltbhH4fY7vazPr-GBcAtbY64FrDNJk';
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();

      final bytesBuilder = BytesBuilder();
      await for (final chunk in response) {
        bytesBuilder.add(chunk);
      }
      final fileBytes = bytesBuilder.takeBytes();

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'verano_ad_corregido_$timestamp.png';

      if (!mounted) return;

      context.read<LibraryBloc>().add(
            LibraryUploadAsset(
              fileBytes: fileBytes,
              fileName: fileName,
              userId: userId,
            ),
          );
      
      setState(() {
        _uploadedFileName = fileName;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al descargar imagen de prueba: $e')),
      );
      _cancelUpload();
    }
  }

  void _cancelUpload() {
    _uploadController.reset();
    context.read<LibraryBloc>().add(LibraryReset());
    setState(() {
      _uploadState = CorrectionUploadState.idle;
      _uploadProgress = 0.0;
      _uploadedAssetId = null;
      _uploadedFileName = null;
    });
  }

  void _submitCorrection() {
    final assetId = _uploadedAssetId;
    if (assetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, sube un archivo corregido primero.')),
      );
      return;
    }

    context.read<BookingsBloc>().add(
          BookingsSubmitCorrection(
            bookingId: widget.booking.id,
            assetId: assetId,
            notes: _notesController.text.trim().isEmpty 
                ? null 
                : _notesController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final campaignName = widget.booking.assetOriginalFilename ?? 'Lanzamiento Verano 2024';

    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: const BookingsAppBar(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LibraryBloc, LibraryState>(
            listener: (context, state) {
              if (state is LibraryUploadFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al subir archivo: ${state.error}')),
                );
                _cancelUpload();
              }
            },
          ),
          BlocListener<BookingsBloc, BookingsState>(
            listener: (context, state) {
              if (state is BookingsCorrectionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Corrección enviada correctamente.')),
                );
                // Return to bookings history list
                context.pop();
              } else if (state is BookingsCorrectionFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al enviar corrección: ${state.error}')),
                );
              }
            },
          ),
        ],
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 768;

            final leftColumn = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Corrección de Anuncio',
                      style: isWide
                          ? AppTypography.headlineLg.copyWith(
                              color: AppPallete.onSurface,
                              fontWeight: FontWeight.bold,
                            )
                          : AppTypography.headlineLgMobile.copyWith(
                              color: AppPallete.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Campaña: $campaignName',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppPallete.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.stackLg),
                const CorrectionWarningBanner(),
                const SizedBox(height: AppSpacing.stackLg),
                CorrectionRejectedAssetCard(booking: widget.booking),
              ],
            );

            final rightColumn = Container(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              decoration: BoxDecoration(
                color: AppPallete.surfaceContainerLowest,
                borderRadius: AppRadius.borderMd,
                border: Border.all(color: AppPallete.outlineVariant),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Subir Corrección',
                    style: AppTypography.headlineMd.copyWith(
                      color: AppPallete.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  CorrectionUploadZone(
                    state: _uploadState,
                    progress: _uploadProgress,
                    fileName: _uploadedFileName,
                    onTap: _startUpload,
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  const CorrectionSpecsBox(),
                  const SizedBox(height: AppSpacing.gutter),
                  // Notes Input
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Notas para el moderador (Opcional)',
                        style: AppTypography.labelSm.copyWith(
                          color: AppPallete.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Ej: Se aumentó el tamaño de fuente según lo solicitado...',
                          hintStyle: AppTypography.bodySm.copyWith(
                            color: AppPallete.secondary,
                          ),
                          filled: true,
                          fillColor: AppPallete.surfaceContainerLowest,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppPallete.primary),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppPallete.outlineVariant),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: AppTypography.bodyMd.copyWith(
                          color: AppPallete.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  // Action Button
                  BlocBuilder<BookingsBloc, BookingsState>(
                    builder: (context, state) {
                      final isSubmitting = state is BookingsCorrectionSubmitting;
                      final isEnabled = _uploadedAssetId != null && !isSubmitting;

                      return ElevatedButton.icon(
                        onPressed: isEnabled ? _submitCorrection : null,
                        icon: isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: AppPallete.onPrimary,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.send,
                                size: 20,
                                color: AppPallete.onPrimary,
                              ),
                        label: Text(
                          'Enviar Corrección',
                          style: AppTypography.labelMd.copyWith(
                            color: AppPallete.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPallete.primary,
                          foregroundColor: AppPallete.onPrimary,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.borderMd,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.containerPadding),
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
                                flex: 7,
                                child: leftColumn,
                              ),
                              const SizedBox(width: AppSpacing.stackLg),
                              Expanded(
                                flex: 5,
                                child: rightColumn,
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              leftColumn,
                              const SizedBox(height: AppSpacing.stackLg),
                              rightColumn,
                            ],
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
