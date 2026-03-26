import 'package:flutter/material.dart';
import 'package:waitwise/core/widgets/custom_appbar.dart';
import 'package:waitwise/core/widgets/custom_bottom_nav.dart';

class UserBacklogsScreen extends StatelessWidget {
  const UserBacklogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppbar(),
      bottomNavigationBar: CustomBottomNav(currentIndex: 2),
      body: Center(child: Text('User Backlogs Screen')),
    );
  }
}
