import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Switch(
            key: ValueKey<bool>(themeProvider.isDarkMode),
            value: themeProvider.isDarkMode,
            onChanged: (_) => themeProvider.toggleTheme(),
            activeColor: Theme.of(context).colorScheme.primary,
            activeTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            inactiveThumbColor: Theme.of(context).colorScheme.secondary,
            inactiveTrackColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            thumbIcon: MaterialStateProperty.resolveWith<Icon?>((states) {
              if (states.contains(MaterialState.selected)) {
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
      },
    );
  }
}