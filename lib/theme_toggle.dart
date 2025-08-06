import 'package:flutter/material.dart';

class ThemeToggle extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;

  const ThemeToggle({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Switch(
        key: ValueKey<bool>(isDarkMode),
        value: isDarkMode,
        onChanged: (_) => onToggle(),
        activeColor: Theme.of(context).colorScheme.primary,
        activeTrackColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.5),
        inactiveThumbColor: Theme.of(context).colorScheme.secondary,
        inactiveTrackColor: Theme.of(
          context,
        ).colorScheme.secondary.withValues(alpha: 0.5),
        thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
          if (states.contains(WidgetState.selected)) {
            return Icon(
              Icons.dark_mode,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 16,
            );
          }
          return Icon(
            Icons.light_mode,
            color: Theme.of(context).colorScheme.onSecondary,
            size: 16,
          );
        }),
      ),
    );
  }
}
