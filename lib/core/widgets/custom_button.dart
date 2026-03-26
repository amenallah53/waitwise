import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Icon? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon = const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.35),
              offset: const Offset(0, 10),
              blurRadius: 25,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
          borderRadius: BorderRadius.circular(9999),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              const Color(0xFF9C27B0),
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 12),
            this.icon!,
          ],
        ),
      ),
    );
  }
}
