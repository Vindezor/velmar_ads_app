import 'package:flutter/material.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/library/domain/entities/creative_asset.dart';
import 'library_asset_card.dart';
import 'library_preview_dialog.dart';

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

  void _showPreview(CreativeAsset asset) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      barrierColor: Colors.black.withValues(alpha: 0.5), // Modern semi-transparent dark shade
      pageBuilder: (context, anim1, anim2) {
        return LibraryPreviewDialog(asset: asset);
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
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

    return RefreshIndicator(
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
                          onTap: () => _showPreview(asset),
                        );
                      },
                    ),
              const SizedBox(height: 96), // Space bottom navigation bar
            ],
          ),
        ),
      ),
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
