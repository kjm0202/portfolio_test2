import 'package:flutter/material.dart';
import 'package:portfolio_test2/presentation/widgets/theme_toggle.dart';
import 'package:portfolio_test2/presentation/widgets/language_toggle.dart';
import 'package:portfolio_test2/presentation/widgets/settings_menu.dart';
import 'package:portfolio_test2/presentation/widgets/navigation_items.dart';
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

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      elevation: isScrolled ? 4 : 0,
      backgroundColor:
          isScrolled ? theme.scaffoldBackgroundColor : Colors.transparent,
      title: _buildTitle(context),
      actions: _buildActions(),
      bottom: isSmallScreen ? _buildBottomNavigation() : null,
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

  List<Widget> _buildActions() {
    return [
      if (!isSmallScreen) ...[
        NavigationItems(theme: theme, onItemTapped: onNavigationItemTapped),
        const SizedBox(width: 16),
      ],
      if (isSmallScreen)
        SettingsMenu(
          themeMode: themeMode,
          isDarkMode: isDarkMode,
          onThemeChanged: onThemeChanged,
          currentLocale: currentLocale,
          onLocaleChanged: onLocaleChanged,
        )
      else
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LanguageToggle(
                currentLocale: currentLocale,
                onLocaleChanged: onLocaleChanged,
              ),
              const SizedBox(width: 8),
              ThemeToggle(
                themeMode: themeMode,
                isDarkMode: isDarkMode,
                onThemeChanged: onThemeChanged,
              ),
            ],
          ),
        ),
      const SizedBox(width: 16),
    ];
  }

  PreferredSize _buildBottomNavigation() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: NavigationItems(
          theme: theme,
          onItemTapped: onNavigationItemTapped,
        ),
      ),
    );
  }
}
