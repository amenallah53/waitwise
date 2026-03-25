import 'dart:math';
import 'package:flutter/material.dart';
import 'package:waitwise/core/widgets/session_loading_screen.dart';
import 'package:waitwise/features/active_session/screens/quiz/quiz_screen.dart';
import 'package:waitwise/features/active_session/screens/reflection/reflection_screen.dart';
import 'package:waitwise/features/active_session/screens/tasks/tasks_screen.dart';
import 'package:waitwise/features/active_session/session_type.dart';

class ActiveSessionScreen extends StatefulWidget {
  const ActiveSessionScreen({super.key});

  @override
  State<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen> {
  SessionType? _sessionType;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateFetchSession();
  }

  /// Simulates the external automation workflow response.
  /// Replace this body with your actual API / DB call later.
  Future<void> _simulateFetchSession() async {
    await Future.delayed(const Duration(seconds: 3));

    final types = SessionType.values;
    final random = types[Random().nextInt(types.length)];

    if (!mounted) return;
    setState(() {
      _sessionType = random;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SessionLoadingScreen();
    }

    return switch (_sessionType!) {
      SessionType.reflection => const ReflectionScreen(),
      SessionType.quiz => const QuizScreen(),
      SessionType.tasks => const TasksScreen(),
    };
  }
}
