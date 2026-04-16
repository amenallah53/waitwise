import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waitwise/core/widgets/custom_appbar.dart';
import 'package:waitwise/core/widgets/custom_circular_timer.dart';
import 'package:waitwise/core/widgets/custom_button.dart';
import 'package:waitwise/core/widgets/custom_text_field.dart';
import 'package:waitwise/data/datasources/sessions_service.dart';
import 'package:waitwise/data/models/session_model.dart';
import 'package:waitwise/features/active_session/providers/reflection_provider.dart';

class ReflectionScreen extends ConsumerStatefulWidget {
  final ReflectionSession session;
  const ReflectionScreen({super.key, required this.session});

  @override
  ConsumerState<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends ConsumerState<ReflectionScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(reflectionProvider).response,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToComplete() {
    ref.read(reflectionProvider.notifier).clear();
    updateSessionCompletion(widget.session.id!, true);
    context.push(
      '/session/active/${widget.session.id}/complete',
      extra: {
        'durationMinutes': widget.session.durationMinutes,
        'session_id': widget.session.id,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reflectionProvider);
    final notifier = ref.read(reflectionProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: false,
      appBar: CustomAppbar(needToShowBack: true),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Scrollable content ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // ── Timer ────────────────────────────────────────────
                    Center(
                      child: CustomCircularTimer(
                        color: theme.colorScheme.primary,
                        durationMinutes: widget.session.durationMinutes,
                        onComplete: _navigateToComplete,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Session type label ────────────────────────────────
                    Text(
                      'REFLECTION MOMENT',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 1.2,
                        color: theme.colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Prompt card ───────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, 4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Text(
                        '"${widget.session.aiContent.prompt}"',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.55,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Response input ────────────────────────────────────
                    CustomTextField(
                      hintText: 'Start typing your thoughts here...',
                      maxLines: 5,
                      controller: _controller,
                      onChanged: notifier.updateResponse,
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Bottom action row ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                children: [
                  // Skip
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _controller.clear();
                        notifier.clear();
                        _navigateToComplete();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: const Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Text(
                          'Skip',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Done
                  Expanded(
                    child: CustomButton(
                      text: 'Done',
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: state.canSubmit
                          ? () async {
                              notifier.markDone();
                              _navigateToComplete();
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
