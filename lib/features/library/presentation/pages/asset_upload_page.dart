import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:velmar_ads/features/library/presentation/widgets/asset_upload_approved_list.dart';

enum UploadState { idle, uploading, completed }

class AssetUploadPage extends StatefulWidget {
  final Billboard? billboard;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<int>? selectedSlots;

  const AssetUploadPage({
    super.key,
    this.billboard,
    this.startDate,
    this.endDate,
    this.selectedSlots,
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
  String? _uploadedFileName;
  bool _isNavigatingToConfirmation = false;
  int _activeTabIndex = 0;

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

  Future<void> _startUpload() async {
    final userState = context.read<AppUserCubit>().state;
    if (userState is! AppUserLoggedIn) {
      showSnackBar(context: context, message: 'Usuario no autenticado.');
      return;
    }
    final userId = userState.user.id;

    try {
      final picker = ImagePicker();
      // Pick either image or video from gallery
      final XFile? mediaFile = await picker.pickMedia();

      if (mediaFile == null) {
        return;
      }

      setState(() {
        _state = UploadState.uploading;
        _uploadProgress = 0.0;
        _uploadedAssetId = null;
        _uploadedFileName = null;
      });

      _uploadController.forward(from: 0.0);

      final fileBytes = await mediaFile.readAsBytes();
      final fileName = mediaFile.name; // Keep the original file name!

      if (!mounted) return;

      setState(() {
        _uploadedFileName = fileName;
      });

      context.read<LibraryBloc>().add(
            LibraryUploadAsset(
              fileBytes: fileBytes,
              fileName: fileName,
              userId: userId,
            ),
          );
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context: context, message: 'Error al seleccionar archivo: $e');
      _cancelUpload();
    }
  }

  void _cleanupUploadedAsset() {
    if (_uploadedAssetId != null && _uploadedFileName != null) {
      final userState = context.read<AppUserCubit>().state;
      if (userState is AppUserLoggedIn) {
        context.read<LibraryBloc>().add(
              LibraryDeleteAsset(
                assetId: _uploadedAssetId!,
                fileName: _uploadedFileName!,
                userId: userState.user.id,
              ),
            );
      }
    }
  }

  void _cancelUpload() {
    _cleanupUploadedAsset();
    _uploadController.reset();
    context.read<LibraryBloc>().add(LibraryReset());
    setState(() {
      _state = UploadState.idle;
      _uploadProgress = 0.0;
      _uploadedAssetId = null;
      _uploadedFileName = null;
    });
  }

  void _onCancelPressed() {
    if (_state != UploadState.idle) {
      _cancelUpload();
    } else {
      context.pop();
    }
  }

  void _onConfirmPressed() async {
    final b = widget.billboard;
    final startDate = widget.startDate;
    final endDate = widget.endDate;
    final selectedSlots = widget.selectedSlots;
    final assetId = _uploadedAssetId;

    if (b == null ||
        startDate == null ||
        endDate == null ||
        selectedSlots == null ||
        assetId == null) {
      showSnackBar(context: context, message: 'Datos de reserva incompletos.');
      return;
    }

    setState(() {
      _isNavigatingToConfirmation = true;
    });

    await context.pushNamed(
      'booking-confirmation',
      pathParameters: {'id': b.id},
      extra: {
        'billboard': b,
        'startDate': startDate,
        'endDate': endDate,
        'selectedSlots': selectedSlots,
        'assetId': assetId,
      },
    );

    if (mounted) {
      setState(() {
        _isNavigatingToConfirmation = false;
      });
    }
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
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop && !_isNavigatingToConfirmation) {
              _cleanupUploadedAsset();
            }
          },
          child: Scaffold(
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
                          AssetUploadTabs(
                            activeIndex: _activeTabIndex,
                            onTabChanged: (index) {
                              if (_activeTabIndex == index) return;
                              setState(() {
                                _activeTabIndex = index;
                                _uploadedAssetId = null;
                                _uploadedFileName = null;
                                _state = UploadState.idle;
                                _uploadProgress = 0.0;
                              });
                              context.read<LibraryBloc>().add(LibraryReset());

                              if (index == 1) {
                                final userState = context.read<AppUserCubit>().state;
                                if (userState is AppUserLoggedIn) {
                                  context.read<LibraryBloc>().add(
                                    LibraryFetchAssets(userId: userState.user.id),
                                  );
                                }
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(
                              AppSpacing.containerPadding,
                            ),
                            child: Column(
                              children: [
                                if (_activeTabIndex == 0) ...[
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
                                ] else
                                  AssetUploadApprovedList(
                                    selectedAssetId: _uploadedAssetId,
                                    onAssetSelected: (asset) {
                                      setState(() {
                                        _uploadedAssetId = asset.id;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                          AssetUploadFooter(
                            onCancel: _onCancelPressed,
                            onConfirm: (_activeTabIndex == 0 && _state == UploadState.completed) ||
                                    (_activeTabIndex == 1 && _uploadedAssetId != null)
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
          ),
        );
      },
    );
  }
}
