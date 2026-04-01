import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waitwise/core/utils/current_user.dart';
import 'package:waitwise/core/widgets/custom_appbar.dart';
import 'package:waitwise/core/widgets/custom_bottom_nav.dart';
import 'package:waitwise/core/widgets/custom_button.dart';
import 'package:waitwise/core/widgets/custom_text_field.dart';
import 'package:waitwise/data/models/user_model.dart';
import '../providers/user_backlogs_provider.dart';

class UserBacklogsScreen extends ConsumerWidget {
  UserBacklogsScreen({super.key});

  static const int _maxLength = 40;

  final UserModel? currentUser = getCurrentUser();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(backlogProvider);
    final notifier = ref.read(backlogProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(),
      backgroundColor: const Color(0xFFF9F9F9),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // ── Header ─────────────────────────────────────────────────
              Text(
                'My Backlog',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your upcoming focus sessions and tasks.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.45),
                  fontSize: 16,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 32),

              // ── Add button ─────────────────────────────────────────────
              CustomButton(
                text: "Add to Backlog",
                onPressed: () async => _showAddDialog(context, notifier),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const SizedBox(height: 32),

              // ── List or empty state ────────────────────────────────────
              if (state.items.isEmpty)
                _EmptyState()
              else
                Column(
                  children: [
                    ...state.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _BacklogCard(
                          item: item,
                          maxLength: _maxLength,
                          onEdit: () =>
                              _showEditDialog(context, notifier, item),
                          onDelete: () =>
                              _showDeleteConfirm(context, notifier, item.id),
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ── Add dialog ──────────────────────────────────────────────────────────────
  void _showAddDialog(BuildContext context, BacklogNotifier notifier) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => _BacklogDialog(
        title: 'Add to Backlog',
        controller: controller,
        confirmLabel: 'Add',
        onConfirm: () {
          notifier.addItem(currentUser!.id!, controller.text);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  // ── Edit dialog ─────────────────────────────────────────────────────────────
  void _showEditDialog(
    BuildContext context,
    BacklogNotifier notifier,
    BacklogItem item,
  ) {
    final controller = TextEditingController(text: item.text);
    showDialog(
      context: context,
      builder: (ctx) => _BacklogDialog(
        title: 'Edit Item',
        controller: controller,
        confirmLabel: 'Save',
        onConfirm: () {
          notifier.editItem(item.id, controller.text);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  // ── Delete confirm ──────────────────────────────────────────────────────────
  void _showDeleteConfirm(
    BuildContext context,
    BacklogNotifier notifier,
    String id,
  ) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: Text(
          'Delete item?',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          "This can't be undone.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.55),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              notifier.deleteItem(id);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Backlog card ───────────────────────────────────────────────────────────────

class _BacklogCard extends StatelessWidget {
  final BacklogItem item;
  final int maxLength;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BacklogCard({
    required this.item,
    required this.maxLength,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayText = item.text.length > maxLength
        ? '${item.text.substring(0, maxLength)}…'
        : item.text;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Left accent bar ────────────────────────────────────────
            Container(
              width: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  /*topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),*/
                ),
              ),
            ),

            const SizedBox(width: 24),

            // ── Content ───────────────────────────────────────────────
            Expanded(
              /*child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),*/
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayText,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Added ${item.timeAgo}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              //),
            ),

            // ── Action icons ───────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _ActionIcon(
                  icon: Icons.edit_outlined,
                  onTap: onEdit,
                  color: theme.colorScheme.onSurface.withOpacity(0.45),
                ),
                const SizedBox(height: 8),
                _ActionIcon(
                  icon: Icons.delete_outline_rounded,
                  onTap: onDelete,
                  color: Colors.red.shade300,
                ),
              ],
            ),
            //const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

// ── Icon tap button ────────────────────────────────────────────────────────────

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _ActionIcon({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

// ── Add / Edit dialog ──────────────────────────────────────────────────────────

class _BacklogDialog extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String confirmLabel;
  final VoidCallback onConfirm;

  const _BacklogDialog({
    required this.title,
    required this.controller,
    required this.confirmLabel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: theme.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      content: CustomTextField(
        hintText: "What's on your mind?",
        controller: controller,
        //maxLength: 200,
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        FilledButton(
          onPressed: onConfirm,
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            confirmLabel,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: theme.colorScheme.onSurface.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'Your backlog is empty',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "Add to Backlog" to get started.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.3),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
