import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final FutureCallback? onPressed; // accepts both sync and async callbacks
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
  State<CustomButton> createState() => _CustomButtonState();
}

// Typedef so the button accepts both () => void and () async => void
typedef FutureCallback = Future<void> Function();

class _CustomButtonState extends State<CustomButton> {
  bool _isLoading = false;

  Future<void> _handleTap() async {
    if (_isLoading || widget.onPressed == null) return;
    setState(() => _isLoading = true);
    try {
      await widget.onPressed!();
    } finally {
      // Only update state if still mounted (screen may have navigated away)
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = widget.onPressed == null || _isLoading;

    return GestureDetector(
      onTap: isDisabled ? null : _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9999),
          gradient: isDisabled
              ? null
              : LinearGradient(
                  colors: [theme.colorScheme.primary, const Color(0xFF9C27B0)],
                ),
          color: isDisabled ? Colors.grey[400] : null,
        ),
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _isLoading
              ? const SizedBox(
                  key: ValueKey('loader'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  key: const ValueKey('content'),
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.text,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDisabled ? Colors.white70 : Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    if (widget.icon != null) ...[
                      const SizedBox(width: 10),
                      widget.icon!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
