import 'package:go_router/go_router.dart';
import 'package:velmar_ads/features/auth/presentation/pages/login_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
);
