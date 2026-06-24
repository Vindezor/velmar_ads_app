import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velmar_ads/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:velmar_ads/core/common/widgets/navigation_shell.dart';
import 'package:velmar_ads/core/router/app_routes.dart';
import 'package:velmar_ads/features/auth/presentation/pages/login_page.dart';
import 'package:velmar_ads/features/auth/presentation/pages/signup_page.dart';
import 'package:velmar_ads/features/bookings/presentation/pages/bookings_page.dart';
import 'package:velmar_ads/features/bookings/presentation/pages/schedule_selection_page.dart';
import 'package:velmar_ads/features/dashboard/domain/entities/billboard.dart';
import 'package:velmar_ads/features/dashboard/presentation/pages/billboard_detail_page.dart';
import 'package:velmar_ads/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:velmar_ads/features/library/presentation/pages/library_page.dart';
import 'package:velmar_ads/features/profile/presentation/pages/profile_page.dart';
import 'package:velmar_ads/init_dependencies.dart';

// Un pequeño puente (Helper) para convertir el Stream del Cubit en un Listenable que GoRouter entienda
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final Object _subscription;

  @override
  void dispose() {
    _subscription.toString();
    super.dispose();
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,

  // 1. Escucha en tiempo real los cambios del AppUserCubit
  refreshListenable: GoRouterRefreshStream(
    serviceLocator<AppUserCubit>().stream,
  ),

  // 2. Lógica de redirección basada en el estado de autenticación
  redirect: (context, state) {
    final userState = serviceLocator<AppUserCubit>().state;
    final isLoggedIn = userState is AppUserLoggedIn;

    // Verificamos si el usuario intenta ir a Login o Registro
    final isGoingToAuth =
        state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.register;

    // Caso A: El usuario NO está logueado y quiere entrar al Dashboard (u otra pantalla privada)
    if (!isLoggedIn && !isGoingToAuth) {
      return AppRoutes.login;
    }

    // Caso B: El usuario YA está logueado pero intenta volver a las pantallas de Auth
    if (isLoggedIn && isGoingToAuth) {
      return AppRoutes.dashboard;
    }

    // En cualquier otro caso, lo dejamos continuar normalmente
    return null;
  },

  routes: [
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const SignUpPage(),
    ),
    
    // StatefulShellRoute mantiene la barra inferior compartida y el estado de cada pestaña
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return NavigationShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              name: 'dashboard',
              builder: (context, state) => const DashboardPage(),
              routes: [
                GoRoute(
                  path: 'billboard/:id',
                  name: 'billboard-detail',
                  builder: (context, state) {
                    final billboard = state.extra as Billboard?;
                    return BillboardDetailPage(billboard: billboard);
                  },
                  routes: [
                    GoRoute(
                      path: 'book',
                      name: 'select-schedule',
                      builder: (context, state) {
                        final billboard = state.extra as Billboard?;
                        return ScheduleSelectionPage(billboard: billboard);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.bookings,
              name: 'bookings',
              builder: (context, state) => const BookingsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.library,
              name: 'library',
              builder: (context, state) => const LibraryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
