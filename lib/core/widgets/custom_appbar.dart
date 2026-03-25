import 'dart:ui';

import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9), // important!
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo2.png", height: 48, width: 48),
                const SizedBox(width: 0),
                Text(
                  "WaitWise",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
