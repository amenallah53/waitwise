// ─────────────────────────────────────────
// SESSION ROW
// ─────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:waitwise/data/models/session_model.dart';

class CustomSessionRow extends StatelessWidget {
  final SessionModel session;
  final VoidCallback onTap;

  const CustomSessionRow({
    super.key,
    required this.session,
    required this.onTap,
  });

  Color _dotColor(ThemeData theme) => switch (session.sessionType) {
    SessionType.quiz => theme.colorScheme.tertiary,
    SessionType.reflection => theme.colorScheme.secondary,
    SessionType.task => theme.colorScheme.primary,
  };

  Color _badgeBg(ThemeData theme) => switch (session.sessionType) {
    SessionType.quiz => theme.colorScheme.tertiary.withOpacity(0.1),
    SessionType.reflection => theme.colorScheme.secondary.withOpacity(0.1),
    SessionType.task => theme.colorScheme.primary.withOpacity(0.1),
  };

  String get _typeLabel => switch (session.sessionType) {
    SessionType.quiz => 'Quiz',
    SessionType.reflection => 'Reflection',
    SessionType.task => 'Task',
  };

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.07),
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Type dot
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _dotColor(theme),
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(width: 14),

            // Title + meta row
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title ?? 'Untitled',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _badgeBg(theme),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _typeLabel,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: _dotColor(theme),
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Context
                      if (session.context != null &&
                          session.context!.isNotEmpty) ...[
                        Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.35),
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            session.context!,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.45,
                              ),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Right side: duration + time ago
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${session.durationMinutes}m',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _timeAgo(session.createdAt),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: theme.colorScheme.onSurface.withOpacity(0.25),
            ),
          ],
        ),
      ),
    );
  }
}
