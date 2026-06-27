import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:velmar_ads/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/init_dependencies.dart';

class ProfileMenuOptions extends StatefulWidget {
  const ProfileMenuOptions({super.key});

  @override
  State<ProfileMenuOptions> createState() => _ProfileMenuOptionsState();
}

class _ProfileMenuOptionsState extends State<ProfileMenuOptions> {
  bool _isDarkMode = false;

  void _onLogout(BuildContext context) async {
    try {
      // Clear local user cubit state
      context.read<AppUserCubit>().updateUser(null);
      
      // Sign out from Supabase
      await serviceLocator<SupabaseClient>().auth.signOut();
      
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión cerrada con éxito.')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppPallete.surfaceContainerLowest,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppPallete.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dark Mode
          Padding(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.dark_mode_outlined,
                      color: AppPallete.secondary,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.stackMd),
                    Text(
                      'Modo Oscuro',
                      style: AppTypography.bodyLg.copyWith(
                        color: AppPallete.onSurface,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _isDarkMode,
                  onChanged: (val) {
                    setState(() {
                      _isDarkMode = val;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isDarkMode ? 'Modo oscuro activado' : 'Modo oscuro desactivado',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  activeTrackColor: AppPallete.primary,
                ),
              ],
            ),
          ),
          const Divider(color: AppPallete.outlineVariant, height: 1),
          // Support
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Soporte técnico presionado.')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.help_outline,
                        color: AppPallete.secondary,
                        size: 24,
                      ),
                      const SizedBox(width: AppSpacing.stackMd),
                      Text(
                        'Soporte técnico',
                        style: AppTypography.bodyLg.copyWith(
                          color: AppPallete.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppPallete.secondary,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: AppPallete.outlineVariant, height: 1),
          // Logout
          InkWell(
            onTap: () => _onLogout(context),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              child: Row(
                children: [
                  const Icon(
                    Icons.logout,
                    color: AppPallete.error,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.stackMd),
                  Text(
                    'Cerrar sesión',
                    style: AppTypography.bodyLg.copyWith(
                      color: AppPallete.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
