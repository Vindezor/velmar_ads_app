import 'package:flutter/material.dart';
import 'package:velmar_ads/core/router/app_router.dart';
import 'package:velmar_ads/core/theme/theme.dart';

void main() {
  runApp(const MainApp());
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
