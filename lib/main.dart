import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velmar_ads/core/router/app_router.dart';
import 'package:velmar_ads/core/theme/theme.dart';
import 'package:velmar_ads/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:velmar_ads/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => serviceLocator<AuthBloc>())],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Velmar Ads',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
