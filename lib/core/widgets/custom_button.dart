import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Icon? icon;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null;

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9999),
          gradient: isDisabled
              ? null
              : LinearGradient(
                  colors: [theme.colorScheme.primary, const Color(0xFF9C27B0)],
                ),
          color: isDisabled
              ? theme.colorScheme.onSurface.withOpacity(0.15)
              : null,
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.35),
                    offset: const Offset(0, 10),
                    blurRadius: 25,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDisabled ? Colors.white70 : Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            if (icon != null) ...[const SizedBox(width: 10), icon!],
          ],
        ),
      ),
    );
  }
}
