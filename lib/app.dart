import 'package:flutter/material.dart';
import 'package:waitwise/core/theme/themes.dart';
import 'router.dart';

class WaitWiseApp extends StatelessWidget {
  const WaitWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WaitWise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
