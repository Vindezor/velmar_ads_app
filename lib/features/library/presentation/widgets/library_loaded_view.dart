import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/library/domain/entities/creative_asset.dart';
import 'library_asset_card.dart';

class LibraryLoadedView extends StatefulWidget {
  final List<CreativeAsset> assets;
  final RefreshCallback onRefresh;

  const LibraryLoadedView({
    super.key,
    required this.assets,
    required this.onRefresh,
  });

  @override
  State<LibraryLoadedView> createState() => _LibraryLoadedViewState();
}

class _LibraryLoadedViewState extends State<LibraryLoadedView> {
  String _activeFilter = 'todos'; // todos, image, video
  CreativeAsset? _previewAsset;
  bool _showSearch = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CreativeAsset> get _filteredAssets {
    var list = widget.assets;

    // Apply category filter
    if (_activeFilter == 'image') {
      list = list.where((a) => a.fileType.toLowerCase() == 'image').toList();
    } else if (_activeFilter == 'video') {
      list = list.where((a) => a.fileType.toLowerCase() == 'video').toList();
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((a) => a.originalFilename
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final approvedCount = widget.assets
        .where((a) => a.status.toLowerCase() == 'approved')
        .length;

    // Responsive grid layout calculation
    final width = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (width >= 1024) {
      crossAxisCount = 4;
    } else if (width >= 600) {
      crossAxisCount = 3;
    }

    return Stack(
      children: [
        // Main view content
        RefreshIndicator(
          onRefresh: widget.onRefresh,
          backgroundColor: AppPallete.surfaceContainerLowest,
          color: AppPallete.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerPadding,
                vertical: AppSpacing.stackLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Biblioteca de Anuncios',
                              style: AppTypography.headlineLgMobile.copyWith(
                                color: AppPallete.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$approvedCount recursos aprobados',
                              style: AppTypography.bodySm.copyWith(
                                color: AppPallete.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Search Toggle Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showSearch = !_showSearch;
                            if (!_showSearch) {
                              _searchQuery = '';
                              _searchController.clear();
                            }
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppPallete.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppPallete.outlineVariant),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            _showSearch ? Icons.close : Icons.search,
                            color: AppPallete.onSurface,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.stackMd),

                  // Search bar field
                  if (_showSearch) ...[
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Buscar anuncios...',
                        prefixIcon: Icon(Icons.search, size: 20),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.stackMd),
                  ],

                  // Filter pills row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          _buildFilterPill('Todos', 'todos'),
                          const SizedBox(width: AppSpacing.base),
                          _buildFilterPill('Imágenes', 'image'),
                          const SizedBox(width: AppSpacing.base),
                          _buildFilterPill('Videos', 'video'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackMd),

                  // Assets Grid View
                  _filteredAssets.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 64),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.search_off_outlined,
                                  size: 48,
                                  color: AppPallete.secondary,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No se encontraron anuncios',
                                  style: AppTypography.bodyMd.copyWith(
                                    color: AppPallete.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: AppSpacing.gutter,
                            mainAxisSpacing: AppSpacing.gutter,
                            childAspectRatio: 4 / 6.8,
                          ),
                          itemCount: _filteredAssets.length,
                          itemBuilder: (context, index) {
                            final asset = _filteredAssets[index];
                            return LibraryAssetCard(
                              asset: asset,
                              onTap: () {
                                setState(() {
                                  _previewAsset = asset;
                                });
                              },
                            );
                          },
                        ),
                  const SizedBox(height: 96), // Space bottom navigation bar
                ],
              ),
            ),
          ),
        ),

        // Fullscreen Preview Modal
        if (_previewAsset != null)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _previewAsset = null;
                });
              },
              child: Container(
                color: Colors.black.withValues(alpha: 0.95),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Stack(
                    children: [
                      // Preview Content
                      Positioned.fill(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.gutter),
                            child: Hero(
                              tag: 'preview-${_previewAsset!.id}',
                              child: Container(
                                constraints: const BoxConstraints(maxHeight: 700),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black54,
                                      blurRadius: 24,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Image.network(
                                  _previewAsset!.fileUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppPallete.surfaceContainerLow,
                                      width: 250,
                                      height: 400,
                                      child: const Icon(
                                        Icons.broken_image_outlined,
                                        color: AppPallete.secondary,
                                        size: 48,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Top Controls Overlay
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.containerPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Close button
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _previewAsset = null;
                                    });
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white24),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                // Download label button (simple visual feedback)
                                GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Descargando archivo...'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppPallete.primary,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'Descargar',
                                      style: AppTypography.labelMd.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Bottom Metadata Info Gradient Panel
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(AppSpacing.containerPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _previewAsset!.originalFilename,
                                style: AppTypography.headlineMd.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    size: 16,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Subido: ${_previewAsset!.createdAt.day} ${_previewAsset!.createdAt.month}',
                                    style: AppTypography.bodySm.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(
                                    Icons.aspect_ratio,
                                    size: 16,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '1080x1920',
                                    style: AppTypography.bodySm.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterPill(String label, String value) {
    final isSelected = _activeFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppPallete.primary : AppPallete.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppPallete.primary : AppPallete.outlineVariant,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppPallete.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.labelMd.copyWith(
            color: isSelected ? Colors.white : AppPallete.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
