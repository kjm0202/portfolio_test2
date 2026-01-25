import 'package:flutter/material.dart';
import 'package:portfolio_test2/presentation/widgets/settings_menu.dart';
import 'package:portfolio_test2/core/app_localizations.dart';

class PortfolioAppBar extends StatelessWidget {
  final bool isScrolled;
  final bool isSmallScreen;
  final ThemeData theme;
  final bool isDarkMode;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final Function(int) onNavigationItemTapped;

  const PortfolioAppBar({
    super.key,
    required this.isScrolled,
    required this.isSmallScreen,
    required this.theme,
    required this.isDarkMode,
    required this.themeMode,
    required this.onThemeChanged,
    required this.currentLocale,
    required this.onLocaleChanged,
    required this.onNavigationItemTapped,
  });

  // Navigation items data
  static const _navItems = [
    {'key': 'home', 'icon': Icons.home_outlined, 'index': 0},
    {'key': 'projects', 'icon': Icons.work_outline, 'index': 1},
    {'key': 'contact', 'icon': Icons.mail_outline, 'index': 2},
  ];

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      elevation: isScrolled ? 4 : 0,
      backgroundColor:
          isScrolled ? theme.scaffoldBackgroundColor : Colors.transparent,
      title: _buildTitle(context),
      actions: _buildActions(context),
      bottom: isSmallScreen ? _buildBottomNavigation(context) : null,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.code,
          color: theme.colorScheme.primary,
          size: isSmallScreen ? 24 : 28,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            AppLocalizations.of(context).appTitle,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 18 : 20,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      if (!isSmallScreen) ...[
        _buildNavigationRow(context),
        const SizedBox(width: 16),
      ],
      SettingsMenu(
        themeMode: themeMode,
        isDarkMode: isDarkMode,
        onThemeChanged: onThemeChanged,
        currentLocale: currentLocale,
        onLocaleChanged: onLocaleChanged,
      ),
      const SizedBox(width: 16),
    ];
  }

  Widget _buildNavigationRow(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    String getLabel(String key) {
      switch (key) {
        case 'home':
          return localizations.navHome;
        case 'projects':
          return localizations.navProjects;
        case 'contact':
          return localizations.navContact;
        default:
          return key;
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children:
          _navItems.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextButton.icon(
                onPressed: () => onNavigationItemTapped(item['index'] as int),
                icon: Icon(
                  item['icon'] as IconData,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                label: Text(
                  getLabel(item['key'] as String),
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  PreferredSize _buildBottomNavigation(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    String getLabel(String key) {
      switch (key) {
        case 'home':
          return localizations.navHome;
        case 'projects':
          return localizations.navProjects;
        case 'contact':
          return localizations.navContact;
        default:
          return key;
      }
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children:
              _navItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton.icon(
                    onPressed:
                        () => onNavigationItemTapped(item['index'] as int),
                    icon: Icon(
                      item['icon'] as IconData,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    label: Text(
                      getLabel(item['key'] as String),
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
