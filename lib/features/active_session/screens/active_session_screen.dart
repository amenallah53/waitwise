import 'dart:math';
import 'package:flutter/material.dart';
import 'package:waitwise/core/widgets/session_loading_screen.dart';
import 'package:waitwise/data/models/session_model.dart';
import 'package:waitwise/features/active_session/screens/quiz/quiz_screen.dart';
import 'package:waitwise/features/active_session/screens/reflection/reflection_screen.dart';
import 'package:waitwise/features/active_session/screens/task_session/task_session_screen.dart';

class ActiveSessionScreen extends StatefulWidget {
  const ActiveSessionScreen({super.key});

  @override
  State<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen> {
  SessionModel? _session;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateFetchSession();
  }

  /// Simulates the external automation workflow response.
  /// Replace this body with your actual API / DB call later.
  Future<void> _simulateFetchSession() async {
    await Future.delayed(const Duration(seconds: 1));

    final types = SessionType.values;
    final randomType = types[Random().nextInt(types.length)];

    final session = _buildMockSession(randomType);

    if (!mounted) return;
    setState(() {
      _session = session;
      _isLoading = false;
    });
  }

  SessionModel _buildMockSession(SessionType type) {
    final now = DateTime.now();

    switch (type) {
      case SessionType.quiz:
        return QuizSession(
          userId: 'mock-user',
          title: 'Quick Quiz: Finance Basics',
          context: 'Waiting for Train',
          durationMinutes: 5,
          userMood: 'focused',
          createdAt: now,
          aiContent: QuizContent(
            questions: [
              QuizQuestion(
                question: 'What does APY stand for in banking?',
                options: [
                  'Annual Percent Yield',
                  'Asset Price Yield',
                  'Annual Percentage Yield',
                  'Adjusted Payment Yield',
                ],
                correctIndex: 2,
                explanation:
                    'APY stands for Annual Percentage Yield. It reflects the real rate of return on savings, taking compounding interest into account.',
              ),
              QuizQuestion(
                question: 'What is a bull market?',
                options: [
                  'A market in decline',
                  'A market with rising prices',
                  'A commodity trading floor',
                  'A type of bond',
                ],
                correctIndex: 1,
                explanation:
                    'A bull market refers to a period when asset prices are rising or expected to rise, typically by 20% or more from recent lows.',
              ),
            ],
          ),
        );

      case SessionType.reflection:
        return ReflectionSession(
          userId: 'mock-user',
          title: 'Mindful Moment',
          context: 'Coffee Break',
          durationMinutes: 3,
          userMood: 'calm',
          createdAt: now,
          aiContent: ReflectionContent(
            prompt:
                'What is one thing that went unexpectedly well for you this week, and what made it possible?',
          ),
        );

      case SessionType.task:
        return TaskSession(
          userId: 'mock-user',
          title: 'Inbox Clearing',
          context: 'Early Arrival',
          durationMinutes: 7,
          userMood: 'busy',
          createdAt: now,
          aiContent: TaskContent(
            prompt: 'Clear your most urgent pending actions.',
            steps: [
              TaskStep(id: 1, text: 'Reply to the 3 oldest unread emails'),
              TaskStep(id: 2, text: 'Archive anything older than 7 days'),
              TaskStep(id: 3, text: 'Flag one item to follow up tomorrow'),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SessionLoadingScreen();
    }

    return switch (_session!) {
      ReflectionSession s => ReflectionScreen(session: s),
      QuizSession s => QuizScreen(session: s),
      TaskSession s => TasksScreen(session: s),
      _ => const SessionLoadingScreen(),
    };
  }
}
