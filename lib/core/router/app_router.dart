import 'package:go_router/go_router.dart';
import 'package:velmar_ads/features/auth/presentation/pages/login_page.dart';
import 'package:velmar_ads/features/auth/presentation/pages/signup_page.dart';
import 'package:velmar_ads/features/dashboard/presentation/pages/dashboard_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
  ],
);
