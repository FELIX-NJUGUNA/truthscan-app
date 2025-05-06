import 'package:flutter/material.dart';
import 'package:truthscan_app/constants/app_theme.dart';
import 'package:truthscan_app/routes.dart';

class TruthScanApp extends StatelessWidget {
  const TruthScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TruthScan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
