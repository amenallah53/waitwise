import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:waitwise/core/utils/current_user.dart';
import 'package:waitwise/core/widgets/custom_appbar.dart';
import 'package:waitwise/core/widgets/custom_bottom_nav.dart';
import 'package:waitwise/core/widgets/custom_button.dart';
import 'package:waitwise/core/widgets/custom_text_field.dart';
import 'package:waitwise/data/models/user_model.dart';
import 'package:waitwise/features/context_picker/providers/context_picker_provider.dart';

class ContextPickerScreen extends ConsumerWidget {
  const ContextPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(contextPickerProvider);
    final notifier = ref.read(contextPickerProvider.notifier);
    final theme = Theme.of(context);

    final UserModel? currentUser = getCurrentUser();

    return Scaffold(
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
      appBar: CustomAppbar(),
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // ── Greeting ───────────────────────────────────────────────
              Text(
                'Hi, ${currentUser?.name ?? "there"}!',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 36,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Let's make this\nwait ",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                        color: theme.colorScheme.primary,
                        height: 1.15,
                      ),
                    ),
                    TextSpan(
                      text: 'count.',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                        color: theme.colorScheme.primary,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Transform your pause into progress.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 48),

              // ── Current context label ──────────────────────────────────
              _SectionLabel(label: 'CURRENT CONTEXT'),
              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Where are you now? (e.g., waiting for bus)',
                onChanged: notifier.setContext,
                prefixIcon: Icons.location_on_outlined,
              ),

              const SizedBox(height: 32),

              // ── Mood section ───────────────────────────────────────────
              _SectionLabel(label: 'HOW ARE YOU FEELING?'),
              const SizedBox(height: 16),

              // Horizontal scrollable mood chips
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: UserMood.values.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final mood = UserMood.values[i];
                    final isSelected = state.selectedMood == mood;

                    return GestureDetector(
                      onTap: () => notifier.selectMood(mood),
                      child: AnimatedContainer(
                        /*margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),*/
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 8,
                        ),
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        width: 82,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(48),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? theme.colorScheme.primary.withOpacity(0.35)
                                  : Colors.black.withOpacity(0.05),
                              blurRadius: isSelected ? 14 : 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              mood.icon,
                              size: 26,
                              color: isSelected
                                  ? const Color(0xFFFFCAFF) // same as text
                                  : theme.colorScheme.onSurface.withOpacity(
                                      0.5,
                                    ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              mood.label.toUpperCase(),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? const Color(0xFFFFCAFF)
                                    : theme.colorScheme.onSurface.withOpacity(
                                        0.5,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // ── Duration ───────────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _SectionLabel(label: 'AVAILABLE TIME'),
                  const Spacer(),
                  // Big animated number
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, anim) => SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 0.4),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: anim,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: Text(
                      '${state.durationMinutes}',
                      key: ValueKey(state.durationMinutes),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 48,
                        color: theme.colorScheme.primary,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Text(
                      'min',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.75),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Minimal slider — just the dot in primary color
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: theme.colorScheme.primary.withOpacity(0.25),
                  inactiveTrackColor: theme.colorScheme.onSurface.withOpacity(
                    0.1,
                  ),
                  thumbColor: theme.colorScheme.primary,
                  overlayColor: theme.colorScheme.primary.withOpacity(0.1),
                  trackHeight: 10,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 12,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 24,
                  ),
                  trackShape: const RoundedRectSliderTrackShape(),
                ),
                child: Slider(
                  value: state.durationMinutes.toDouble(),
                  min: 1,
                  max: 10,
                  //divisions: 9,
                  onChanged: (v) => notifier.setDuration(v.round()),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1m',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.75),
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '10m',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.75),
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Quote card ─────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF6B3FA0), const Color(0xFF3D1A6E)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '"Patience is not the ability to wait, but the ability to keep a good attitude while waiting."',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.55,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // ── CTA ────────────────────────────────────────────────────
              CustomButton(
                text: 'Start my session',
                onPressed: state.isReady
                    ? () async {
                        final data = {
                          'session_id': Uuid().v4(),
                          'user_id': currentUser?.id ?? 'unknown',
                          'context': state.context,
                          'mood': state.selectedMood!.label,
                          'duration': state.durationMinutes,
                        };
                        notifier.reset();
                        context.go(
                          '/session/active/${data['session_id']}',
                          extra: data,
                        );
                      }
                    : null,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Small reusable section label ──────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 14,
      ),
    );
  }
}
