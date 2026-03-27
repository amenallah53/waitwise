import 'package:flutter/material.dart';
import 'package:waitwise/core/widgets/custom_appbar.dart';
import 'package:waitwise/data/models/session_model.dart';

class ReflectionScreen extends StatelessWidget {
  const ReflectionScreen({super.key, required ReflectionSession session});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppbar(needToShowBack: true),
      body: Center(
        child: Text(
          'Reflection Session\n(Coming Soon!)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
