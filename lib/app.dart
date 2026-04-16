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
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling, // optional: prevent font scaling issues
          ),
          child: child!,
        );
      },
    );
  }
}
