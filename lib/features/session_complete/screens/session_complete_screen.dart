import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waitwise/core/utils/current_user.dart';
import 'package:waitwise/core/widgets/custom_appbar.dart';
import 'package:waitwise/core/widgets/custom_button.dart';
import 'package:waitwise/data/models/user_model.dart';
import 'package:waitwise/features/dashboard/providers/dashboard_provider.dart';
import 'package:waitwise/features/session_complete/providers/session_complete_provider.dart';
import 'package:waitwise/features/user_backlogs/providers/user_backlogs_provider.dart';

import 'package:waitwise/data/datasources/sessions_service.dart';

class SessionCompleteScreen extends ConsumerStatefulWidget {
  final String? sessionId;
  final int durationMinutes;

  const SessionCompleteScreen({
    super.key,
    this.sessionId,
    this.durationMinutes = 0,
  });

  @override
  ConsumerState<SessionCompleteScreen> createState() =>
      _SessionCompleteScreenState();
}

class _SessionCompleteScreenState extends ConsumerState<SessionCompleteScreen> {
  late TextEditingController _localController;
  int _durationMinutes = 0;

  @override
  void initState() {
    super.initState();
    _localController = TextEditingController();
    if (widget.sessionId != null) {
      updateSessionCompletion(widget.sessionId!, true);
    }
  }

  @override
  void dispose() {
    _localController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionCompleteProvider);
    final notifier = ref.read(backlogProvider.notifier);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final UserModel? currentUser = getCurrentUser();

    // ── Pre-compute colors once, avoiding repeated withOpacity calls ──
    final primaryShadowColor = Color.fromRGBO(
      scheme.primary.r.toInt(),
      scheme.primary.g.toInt(),
      scheme.primary.b.toInt(),
      0.25,
    );
    final addBtnShadowColor = Color.fromRGBO(
      scheme.primary.r.toInt(),
      scheme.primary.g.toInt(),
      scheme.primary.b.toInt(),
      0.3,
    );
    final subtitleColor = Color.fromRGBO(
      scheme.onSurface.r.toInt(),
      scheme.onSurface.g.toInt(),
      scheme.onSurface.b.toInt(),
      0.5,
    );

    return Scaffold(
      extendBody: false,
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
                        color: primaryShadowColor,
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
                "${widget.durationMinutes} minutes well spent!",
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
                  color: subtitleColor,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              _InfoCard(
                icon: Icons.calendar_today_rounded,
                accentColor: scheme.secondary,
                label: "TOTAL SESSIONS",
                value: "${currentUser?.sessionsCompleted ?? 0}",
              ),

              const SizedBox(height: 16),

              _InfoCard(
                icon: Icons.local_fire_department_rounded,
                accentColor: scheme.tertiary,
                label: "CURRENT STREAK",
                value: "${currentUser?.currentStreak ?? 0} days",
              ),

              const SizedBox(height: 24),

              // ── Backlog Input Card ──────────────────────
              RepaintBoundary(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(32),
                    // Simplified shadow — single layer, no opacity math
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x08000000), // ~3% black, pre-computed
                        blurRadius: 20,
                        offset: Offset(0, 10),
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
                          color: scheme.onSurface,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Container(
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                                    color: scheme.onSurface.withAlpha(96),
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 30,
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
                                  if (_localController.text.isNotEmpty && currentUser?.id != null) {
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
                                    color: scheme.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: addBtnShadowColor,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: scheme.onPrimary,
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
                  ref.invalidate(dashboardProvider);
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

    // Pre-compute to avoid withOpacity in paint phase
    final accentBg = Color.fromRGBO(
      accentColor.r.toInt(),
      accentColor.g.toInt(),
      accentColor.b.toInt(),
      0.12,
    );
    final labelColor = Color.fromRGBO(
      scheme.onSurface.r.toInt(),
      scheme.onSurface.g.toInt(),
      scheme.onSurface.b.toInt(),
      0.4,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0x0A000000), // ~4% black, pre-computed
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentBg,
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
                  color: labelColor,
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
