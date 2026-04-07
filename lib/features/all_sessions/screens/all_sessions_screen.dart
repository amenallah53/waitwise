// ============================================================
// lib/features/all_sessions/screens/all_sessions_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waitwise/core/widgets/custom_appbar.dart';
import 'package:waitwise/core/widgets/custom_bottom_nav.dart';
import 'package:waitwise/core/widgets/custom_session_row.dart';
import 'package:waitwise/features/all_sessions/providers/all_sessions_provider.dart';

class AllSessionsScreen extends ConsumerStatefulWidget {
  const AllSessionsScreen({super.key});

  @override
  ConsumerState<AllSessionsScreen> createState() => _AllSessionsScreenState();
}

class _AllSessionsScreenState extends ConsumerState<AllSessionsScreen> {
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(allSessionsProvider);
    final notifier = ref.read(allSessionsProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(needToShowBack: true),
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
            ? _ErrorView(
                message: state.error!,
                onRetry: () {
                  // reload
                  notifier.load('');
                },
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Session History',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 32,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${state.allSessions.length} total sessions',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.45,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        // Search toggle
                        GestureDetector(
                          onTap: () {
                            setState(() => _showSearch = !_showSearch);
                            if (!_showSearch) {
                              _searchController.clear();
                              notifier.clearSearch();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _showSearch
                                  ? theme.colorScheme.primary.withOpacity(0.1)
                                  : theme.colorScheme.onSurface.withOpacity(
                                      0.06,
                                    ),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Icon(
                              _showSearch
                                  ? Icons.search_off_rounded
                                  : Icons.search_rounded,
                              size: 20,
                              color: _showSearch
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withOpacity(
                                      0.5,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Search bar ──────────────────────────────────────
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    child: _showSearch
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              onChanged: notifier.setSearch,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 15,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search by title or context...',
                                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.35),
                                  fontSize: 15,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.35),
                                  size: 20,
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          _searchController.clear();
                                          notifier.clearSearch();
                                        },
                                        child: Icon(
                                          Icons.close_rounded,
                                          size: 18,
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.4),
                                        ),
                                      )
                                    : null,
                                filled: true,
                                fillColor: theme.colorScheme.onSurface
                                    .withOpacity(0.05),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 20),

                  // ── Filter chips ────────────────────────────────────
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: SessionFilter.values.map((f) {
                        final isActive = state.activeFilter == f;
                        final count = state.countFor(f);
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => notifier.setFilter(f),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutCubic,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface.withOpacity(
                                        0.06,
                                      ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    f.label,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: isActive
                                          ? Colors.white
                                          : theme.colorScheme.onSurface
                                                .withOpacity(0.6),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? Colors.white.withOpacity(0.25)
                                          : theme.colorScheme.onSurface
                                                .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      '$count',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            color: isActive
                                                ? Colors.white
                                                : theme.colorScheme.onSurface
                                                      .withOpacity(0.5),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Session list ────────────────────────────────────
                  Expanded(
                    child: state.filtered.isEmpty
                        ? _EmptyState(
                            isSearching: state.searchQuery.isNotEmpty,
                            filter: state.activeFilter,
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                            itemCount: state.filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) => CustomSessionRow(
                              session: state.filtered[i],
                              onTap: () {},
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isSearching;
  final SessionFilter filter;

  const _EmptyState({required this.isSearching, required this.filter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFiltered = filter != SessionFilter.all;

    final icon = isSearching
        ? Icons.search_off_rounded
        : isFiltered
        ? Icons.filter_list_off_rounded
        : Icons.history_rounded;

    final title = isSearching
        ? 'No results found'
        : isFiltered
        ? 'No ${filter.label.toLowerCase()} sessions yet'
        : 'No sessions yet';

    final subtitle = isSearching
        ? 'Try a different search term'
        : isFiltered
        ? 'Complete a ${filter.label.toLowerCase()} session to see it here'
        : 'Start your first session to see your history here';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: theme.colorScheme.onSurface.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface.withOpacity(0.55),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.35),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// ERROR VIEW
// ─────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: theme.colorScheme.onSurface.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'Could not load sessions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
