import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/utils/show_snackbar.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/billboard.dart';
import 'package:velmar_ads/features/library/presentation/bloc/library_bloc.dart';
import 'package:velmar_ads/features/library/presentation/widgets/asset_upload_app_bar.dart';
import 'package:velmar_ads/features/library/presentation/widgets/asset_upload_header.dart';
import 'package:velmar_ads/features/library/presentation/widgets/asset_upload_tabs.dart';
import 'package:velmar_ads/features/library/presentation/widgets/asset_upload_dropzone.dart';
import 'package:velmar_ads/features/library/presentation/widgets/asset_upload_progress.dart';
import 'package:velmar_ads/features/library/presentation/widgets/asset_upload_preview.dart';
import 'package:velmar_ads/features/library/presentation/widgets/asset_upload_footer.dart';

enum UploadState { idle, uploading, completed }

class AssetUploadPage extends StatefulWidget {
  final Billboard? billboard;
  final DateTime? selectedDate;
  final List<int>? selectedSlots;

  const AssetUploadPage({
    super.key,
    required this.billboard,
    required this.selectedDate,
    required this.selectedSlots,
  });

  @override
  State<AssetUploadPage> createState() => _AssetUploadPageState();
}

class _AssetUploadPageState extends State<AssetUploadPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _uploadController;
  double _uploadProgress = 0.0;
  UploadState _state = UploadState.idle;
  String? _uploadedAssetId;

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
            _state = UploadState.completed;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _uploadController.dispose();
    super.dispose();
  }

  void _startUpload() {
    final userState = context.read<AppUserCubit>().state;
    if (userState is! AppUserLoggedIn) {
      showSnackBar(context: context, message: 'Usuario no autenticado.');
      return;
    }
    final userId = userState.user.id;

    setState(() {
      _state = UploadState.uploading;
      _uploadProgress = 0.0;
      _uploadedAssetId = null;
    });

    _uploadController.forward(from: 0.0);

    // Array de bytes de un PNG transparente real de 1x1 píxeles
    final List<int> mockPngBytes = [
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
      0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
      0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0xDA, 0x63, 0x60, 0x18, 0x05, 0xA3,
      0x60, 0x14, 0x8C, 0x00, 0x08, 0x00, 0x45, 0x06, 0x7B, 0x94, 0x11, 0x00,
      0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
    ];

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'campaign_summer_2024_$timestamp.png';

    context.read<LibraryBloc>().add(
          LibraryUploadAsset(
            fileBytes: mockPngBytes,
            fileName: fileName,
            userId: userId,
          ),
        );
  }

  void _cancelUpload() {
    _uploadController.reset();
    context.read<LibraryBloc>().add(LibraryReset());
    setState(() {
      _state = UploadState.idle;
      _uploadProgress = 0.0;
      _uploadedAssetId = null;
    });
  }

  void _onCancelPressed() {
    if (_state != UploadState.idle) {
      _cancelUpload();
    } else {
      context.pop();
    }
  }

  void _onConfirmPressed() {
    final b = widget.billboard;
    final selectedDate = widget.selectedDate;
    final selectedSlots = widget.selectedSlots;
    final assetId = _uploadedAssetId;

    if (b == null ||
        selectedDate == null ||
        selectedSlots == null ||
        assetId == null) {
      showSnackBar(context: context, message: 'Datos de reserva incompletos.');
      return;
    }

    context.pushNamed(
      'booking-confirmation',
      pathParameters: {'id': b.id},
      extra: {
        'billboard': b,
        'selectedDate': selectedDate,
        'selectedSlots': selectedSlots,
        'assetId': assetId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.billboard == null) {
      return Scaffold(
        appBar: const AssetUploadAppBar(),
        body: Center(
          child: Text(
            'Billboard no encontrado',
            style: AppTypography.bodyLg.copyWith(color: AppPallete.error),
          ),
        ),
      );
    }

    return BlocConsumer<LibraryBloc, LibraryState>(
      listener: (context, state) {
        if (state is LibraryUploadSuccess) {
          _uploadedAssetId = state.assetId;
          // Si la animación ya terminó, pasar inmediatamente a completado
          if (!_uploadController.isAnimating && _uploadProgress >= 1.0) {
            setState(() {
              _state = UploadState.completed;
            });
          }
        } else if (state is LibraryUploadFailure) {
          showSnackBar(
            context: context,
            message: 'Error al subir asset: ${state.error}',
          );
          _cancelUpload();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppPallete.background,
          appBar: const AssetUploadAppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerPadding,
                vertical: AppSpacing.stackLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AssetUploadHeader(),
                  const SizedBox(height: AppSpacing.stackLg),
                  // Options Container
                  Container(
                    decoration: BoxDecoration(
                      color: AppPallete.surfaceContainerLowest,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(AppRadius.lg),
                      ),
                      border: Border.all(color: AppPallete.borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        const AssetUploadTabs(),
                        Padding(
                          padding: const EdgeInsets.all(
                            AppSpacing.containerPadding,
                          ),
                          child: Column(
                            children: [
                              if (_state == UploadState.idle)
                                AssetUploadDropzone(
                                  onUploadTriggered: _startUpload,
                                ),
                              if (_state == UploadState.uploading)
                                AssetUploadProgress(
                                  progress: _uploadProgress,
                                  onCancel: _cancelUpload,
                                ),
                              if (_state == UploadState.completed)
                                const AssetUploadPreview(),
                            ],
                          ),
                        ),
                        AssetUploadFooter(
                          onCancel: _onCancelPressed,
                          onConfirm: _state == UploadState.completed
                              ? _onConfirmPressed
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
