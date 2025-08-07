import 'package:flutter/material.dart';

class SettingsMenu extends StatelessWidget {
  final ThemeMode themeMode;
  final bool isDarkMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const SettingsMenu({
    super.key,
    required this.themeMode,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.currentLocale,
    required this.onLocaleChanged,
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

  String _getLanguageLabel(Locale locale) {
    return locale.languageCode == 'ko' ? '한국어' : 'English';
  }

  String _getLanguageCode(Locale locale) {
    return locale.languageCode.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings, size: 18, color: colorScheme.primary),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: colorScheme.primary.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
      itemBuilder:
          (BuildContext context) => [
            // 언어 섹션
            PopupMenuItem<String>(
              enabled: false,
              child: Text(
                'Language',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'lang_en',
              child: _buildLanguageItem(
                context,
                const Locale('en', ''),
                'English',
                'EN',
              ),
            ),
            PopupMenuItem<String>(
              value: 'lang_ko',
              child: _buildLanguageItem(
                context,
                const Locale('ko', ''),
                '한국어',
                'KO',
              ),
            ),
            const PopupMenuDivider(),
            // 테마 섹션
            PopupMenuItem<String>(
              enabled: false,
              child: Text(
                'Theme',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'theme_system',
              child: _buildThemeItem(context, ThemeMode.system),
            ),
            PopupMenuItem<String>(
              value: 'theme_light',
              child: _buildThemeItem(context, ThemeMode.light),
            ),
            PopupMenuItem<String>(
              value: 'theme_dark',
              child: _buildThemeItem(context, ThemeMode.dark),
            ),
          ],
      onSelected: (String value) {
        if (value.startsWith('lang_')) {
          final langCode = value.split('_')[1];
          onLocaleChanged(Locale(langCode, ''));
        } else if (value.startsWith('theme_')) {
          final themeString = value.split('_')[1];
          ThemeMode newTheme;
          switch (themeString) {
            case 'light':
              newTheme = ThemeMode.light;
              break;
            case 'dark':
              newTheme = ThemeMode.dark;
              break;
            case 'system':
            default:
              newTheme = ThemeMode.system;
              break;
          }
          onThemeChanged(newTheme);
        }
      },
    );
  }

  Widget _buildLanguageItem(
    BuildContext context,
    Locale locale,
    String label,
    String code,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = currentLocale.languageCode == locale.languageCode;

    return Row(
      children: [
        Container(
          width: 24,
          height: 16,
          decoration: BoxDecoration(
            color:
                isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              code,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color:
                    isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
        if (isSelected) Icon(Icons.check, size: 18, color: colorScheme.primary),
      ],
    );
  }

  Widget _buildThemeItem(BuildContext context, ThemeMode mode) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = themeMode == mode;

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

    return Row(
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
        if (mode == ThemeMode.system) ...[
          const SizedBox(width: 8),
          Icon(
            isDarkMode ? Icons.dark_mode : Icons.light_mode,
            size: 16,
            color:
                isSelected
                    ? itemColor.withValues(alpha: 0.7)
                    : colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ],
        if (isSelected) ...[
          const SizedBox(width: 8),
          Icon(Icons.check, size: 18, color: itemColor),
        ],
      ],
    );
  }
}
