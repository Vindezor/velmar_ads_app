import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/core/common/widgets/velmar_app_bar.dart';
import 'package:velmar_ads/features/library/presentation/bloc/library_bloc.dart';
import 'package:velmar_ads/features/library/presentation/widgets/library_empty_view.dart';
import 'package:velmar_ads/features/library/presentation/widgets/library_loaded_view.dart';
import 'package:velmar_ads/init_dependencies.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

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

    final userId = userState.user.id;

    return BlocProvider(
      create: (context) => serviceLocator<LibraryBloc>()..add(LibraryFetchAssets(userId: userId)),
      child: LibraryView(userId: userId),
    );
  }
}

class LibraryView extends StatefulWidget {
  final String userId;
  const LibraryView({super.key, required this.userId});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  int? _lastIndex;

  @override
  Widget build(BuildContext context) {
    // Listen to StatefulNavigationShell index changes
    try {
      final shell = StatefulNavigationShell.of(context);
      final currentIndex = shell.currentIndex;
      
      // If the user just switched to the Library tab (index 2), trigger refresh
      if (currentIndex == 2 && _lastIndex != 2) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.read<LibraryBloc>().add(LibraryFetchAssets(userId: widget.userId));
          }
        });
      }
      _lastIndex = currentIndex;
    } catch (_) {
      // In case StatefulNavigationShell is not present in context (e.g. testing)
    }

    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: const VelmarAppBar(showBackButton: false),
      body: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          return switch (state) {
            LibraryAssetsLoading() || LibraryInitial() || LibraryLoading() => const Center(
                child: CircularProgressIndicator(color: AppPallete.primary),
              ),
            LibraryAssetsLoaded(assets: final assets) => assets.isEmpty
                ? const LibraryEmptyView()
                : LibraryLoadedView(
                    assets: assets,
                    onRefresh: () async {
                      context.read<LibraryBloc>().add(LibraryFetchAssets(userId: widget.userId));
                    },
                  ),
            LibraryAssetsError(message: final msg) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.gutter),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: AppPallete.error),
                      const SizedBox(height: 16),
                      Text(
                        msg,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMd.copyWith(color: AppPallete.error),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<LibraryBloc>().add(LibraryFetchAssets(userId: widget.userId));
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              ),
            _ => const Center(
                child: CircularProgressIndicator(color: AppPallete.primary),
              ),
          };
        },
      ),
    );
  }
}
