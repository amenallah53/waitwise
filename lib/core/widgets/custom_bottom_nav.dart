import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.push('/home');
        break;
      case 1:
        context.push('/dashboard');
        break;
      case 2:
        context.push('/backlogs');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _item(context, Icons.home, "Home", 0),
          _item(context, Icons.grid_view_rounded, "Dashboard", 1),
          _item(context, Icons.access_time, "Backlog", 2),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _onTap(context, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? theme.colorScheme.primary : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? theme.colorScheme.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
