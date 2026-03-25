import 'package:flutter/material.dart';

class SessionLoadingScreen extends StatefulWidget {
  const SessionLoadingScreen({super.key});

  @override
  State<SessionLoadingScreen> createState() => _SessionLoadingScreenState();
}

class _SessionLoadingScreenState extends State<SessionLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _shimmer = Tween<double>(
      begin: 0.3,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _shimmer,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top label ──────────────────────────────────────────
                  _SkeletonBox(width: 140, height: 16, opacity: _shimmer.value),
                  const SizedBox(height: 12),

                  // ── Title ──────────────────────────────────────────────
                  _SkeletonBox(
                    width: double.infinity,
                    height: 28,
                    opacity: _shimmer.value,
                  ),
                  const SizedBox(height: 8),
                  _SkeletonBox(
                    width: 220,
                    height: 28,
                    opacity: _shimmer.value * 0.85,
                  ),

                  const SizedBox(height: 32),

                  // ── Card ───────────────────────────────────────────────
                  _SkeletonBox(
                    width: double.infinity,
                    height: 160,
                    radius: 20,
                    opacity: _shimmer.value * 0.7,
                  ),

                  const SizedBox(height: 24),

                  // ── Three item rows ────────────────────────────────────
                  ..._buildItemRows(),

                  const Spacer(),

                  // ── Bottom button ──────────────────────────────────────
                  _SkeletonBox(
                    width: double.infinity,
                    height: 52,
                    radius: 30,
                    opacity: _shimmer.value * 0.6,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildItemRows() {
    final widths = [double.infinity, 280.0, 240.0];
    return widths
        .expand(
          (w) => [
            Row(
              children: [
                _SkeletonBox(
                  width: 40,
                  height: 40,
                  radius: 12,
                  opacity: _shimmer.value,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonBox(
                        width: w == double.infinity ? double.infinity : w,
                        height: 14,
                        opacity: _shimmer.value,
                      ),
                      const SizedBox(height: 6),
                      _SkeletonBox(
                        width: w == double.infinity ? 180 : w * 0.6,
                        height: 12,
                        opacity: _shimmer.value * 0.7,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        )
        .toList();
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final double opacity;

  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = 10,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
