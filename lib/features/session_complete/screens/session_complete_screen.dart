import 'package:flutter/material.dart';
import 'package:waitwise/core/widgets/custom_appbar.dart';
import 'package:waitwise/core/widgets/custom_bottom_nav.dart';

class SessionCompleteScreen extends StatelessWidget {
  const SessionCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppbar(),
      bottomNavigationBar: CustomBottomNav(currentIndex: 2),
      body: Center(child: Text('Session Complete Screen')),
    );
  }
}
