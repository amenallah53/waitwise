import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waitwise/core/utils/current_user.dart';
import 'package:waitwise/data/models/user_model.dart';
import 'package:waitwise/features/session_complete/providers/session_complete_provider.dart';
import 'package:waitwise/core/widgets/custom_appbar.dart';
import 'package:waitwise/core/widgets/custom_button.dart';
import 'package:waitwise/features/user_backlogs/providers/user_backlogs_provider.dart';
import 'package:go_router/go_router.dart';

class SessionCompleteScreen extends ConsumerStatefulWidget {
  const SessionCompleteScreen({super.key});

  @override
  ConsumerState<SessionCompleteScreen> createState() =>
      _SessionCompleteScreenState();
}

class _SessionCompleteScreenState extends ConsumerState<SessionCompleteScreen> {
  late TextEditingController _localController;
  int _durationMinutes = 0;
  //String _sessionID = '';

  @override
  void initState() {
    super.initState();
    _localController = TextEditingController();
  }

  @override
  void dispose() {
    _localController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // didChangeDependencies is the earliest safe place to call GoRouterState.of(context)
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    _durationMinutes = extra?['durationMinutes'] ?? 0;
    //_sessionID = extra?['session_id'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionCompleteProvider);
    //final notifierSession = ref.read(sessionCompleteProvider.notifier);
    final notifier = ref.read(backlogProvider.notifier);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final UserModel? currentUser = getCurrentUser();

    return Scaffold(
      appBar: const CustomAppbar(needToShowBack: true),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // ── Top Icon Container ──────────────────────
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: scheme.primary.withOpacity(0.25),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: scheme.onPrimary,
                    size: 48,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Text(
                "$_durationMinutes minutes well spent!",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                  color: scheme.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "You've reclaimed your time. Great focus\nduring this interval.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurface.withOpacity(0.5),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              _InfoCard(
                icon: Icons.calendar_today_rounded,
                accentColor: scheme.secondary,
                label: "SESSIONS THIS WEEK",
                value: "${state.sessionsThisWeek}",
              ),

              const SizedBox(height: 16),

              _InfoCard(
                icon: Icons.local_fire_department_rounded,
                accentColor: scheme.tertiary,
                label: "CURRENT STREAK",
                value: "${state.currentStreak} days",
              ),

              const SizedBox(height: 24),

              // ── Backlog Input Card (Integrated) ──────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Anything to add to your\nbacklog after this session?",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .end, //aligns button with text field to the end as field  grows
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _localController,
                              minLines: 3,
                              maxLines: 5,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: "Ideas, tasks, or follow-ups...",
                                hintStyle: TextStyle(
                                  fontFamily:
                                      theme.textTheme.bodyLarge?.fontFamily,
                                  color: Colors.grey.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                // Increased vertical padding increases the perceived height
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical:
                                      30, // fixed height to prevent jump when adding lines
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 12.0,
                              bottom: 12.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (_localController.text.isNotEmpty) {
                                  notifier.addItem(
                                    currentUser!.id!,
                                    _localController.text,
                                  );
                                  _localController.clear();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Added to backlog"),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: theme.colorScheme.onPrimary,
                                  size: 23,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              CustomButton(
                text: "Back to Home",
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: scheme.onPrimary,
                  size: 20,
                ),
                onPressed: () async {
                  context.push('/home');
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.accentColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface.withOpacity(0.4),
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
