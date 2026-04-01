// ── Circular countdown timer ───────────────────────────────────────────────────

import 'package:flutter/material.dart';

class CustomCircularTimer extends StatefulWidget {
  final int durationMinutes;
  final VoidCallback? onComplete;
  final Color color;

  const CustomCircularTimer({
    super.key,
    required this.durationMinutes,
    this.onComplete,
    required this.color,
  });

  @override
  State<CustomCircularTimer> createState() => CircularTimerState();
}

class CircularTimerState extends State<CustomCircularTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: widget.durationMinutes),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // navigate when timer ends
        if (mounted) {
          widget.onComplete?.call();
        }
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTime(double progress) {
    final totalSeconds = (widget.durationMinutes * 60 * (1 - progress)).round();
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox(
          width: 110,
          height: 110,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1 - _controller.value,
                strokeWidth: 8,
                backgroundColor: widget.color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                strokeCap: StrokeCap.round,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Remaining',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(_controller.value),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
