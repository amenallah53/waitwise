import 'dart:ui';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final bool obscureText;
  final int? maxLines;
  final void Function(String value)? onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.prefixIcon,
    this.obscureText = false,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF581C87).withOpacity(0.05),
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextField(
            maxLines: maxLines,
            controller: controller,
            obscureText: obscureText,
            onChanged: onChanged,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: theme.colorScheme.primary)
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
