import 'package:flutter/material.dart';

class ThemeToggle extends StatelessWidget {
  final ThemeMode themeMode;
  final bool isDarkMode; // 현재 실제 다크모드 상태 (시스템 테마 반영)
  final ValueChanged<ThemeMode> onThemeChanged;

  const ThemeToggle({
    super.key,
    required this.themeMode,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return Icons.auto_mode;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Auto';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  Color _getButtonColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (themeMode) {
      case ThemeMode.system:
        return colorScheme.tertiary;
      case ThemeMode.light:
        return colorScheme.secondary;
      case ThemeMode.dark:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ThemeMode>(
      initialValue: themeMode,
      onSelected: onThemeChanged,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _getButtonColor(context).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _getButtonColor(context).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getThemeIcon(themeMode),
              size: 20,
              color: _getButtonColor(context),
            ),
            const SizedBox(width: 8),
            Text(
              _getThemeLabel(themeMode),
              style: TextStyle(
                color: _getButtonColor(context),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: _getButtonColor(context).withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
      itemBuilder:
          (BuildContext context) => [
            _buildMenuItem(context, ThemeMode.system),
            _buildMenuItem(context, ThemeMode.light),
            _buildMenuItem(context, ThemeMode.dark),
          ],
    );
  }

  PopupMenuItem<ThemeMode> _buildMenuItem(
    BuildContext context,
    ThemeMode mode,
  ) {
    final isSelected = mode == themeMode;
    final colorScheme = Theme.of(context).colorScheme;

    Color itemColor;
    switch (mode) {
      case ThemeMode.system:
        itemColor = colorScheme.tertiary;
        break;
      case ThemeMode.light:
        itemColor = colorScheme.secondary;
        break;
      case ThemeMode.dark:
        itemColor = colorScheme.primary;
        break;
    }

    return PopupMenuItem<ThemeMode>(
      value: mode,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              _getThemeIcon(mode),
              size: 20,
              color:
                  isSelected
                      ? itemColor
                      : colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _getThemeLabel(mode),
                style: TextStyle(
                  color: isSelected ? itemColor : colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(Icons.check, size: 18, color: itemColor),
            ],
          ],
        ),
      ),
    );
  }
}
