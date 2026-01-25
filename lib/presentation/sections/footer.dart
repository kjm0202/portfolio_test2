import 'package:flutter/material.dart';
import 'package:portfolio_test2/core/app_localizations.dart';

class Footer extends StatelessWidget {
  final Function(int)? onNavigationItemTapped;

  const Footer({super.key, this.onNavigationItemTapped});

  // App bar와 동일한 네비게이션 아이템
  static const _navItems = [
    {'key': 'home', 'index': 0},
    {'key': 'projects', 'index': 1},
    {'key': 'contact', 'index': 2},
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);

        // 1200px 미만은 모바일(태블릿 포함)
        final isSmallScreen = constraints.maxWidth < 1200;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 20 : 40,
            vertical: 32,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child:
              isSmallScreen
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildLogo(context, theme),
                      const SizedBox(height: 24),
                      _buildNavLinks(context, theme, isSmallScreen),
                      const SizedBox(height: 24),
                      _buildCopyright(context, theme),
                    ],
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLogo(context, theme),
                      _buildNavLinks(context, theme, isSmallScreen),
                      _buildCopyright(context, theme),
                    ],
                  ),
        );
      },
    );
  }

  Widget _buildLogo(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.code, color: theme.colorScheme.primary, size: 28),
        const SizedBox(width: 8),
        Text(
          AppLocalizations.of(context).developerName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildNavLinks(
    BuildContext context,
    ThemeData theme,
    bool isSmallOrMedium,
  ) {
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

    return isSmallOrMedium
        ? Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children:
              _navItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton(
                    onPressed: () =>
                        onNavigationItemTapped?.call(item['index'] as int),
                    child: Text(
                      getLabel(item['key'] as String),
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
        )
        : Row(
          mainAxisSize: MainAxisSize.min,
          children:
              _navItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextButton(
                    onPressed: () =>
                        onNavigationItemTapped?.call(item['index'] as int),
                    child: Text(
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

  Widget _buildCopyright(BuildContext context, ThemeData theme) {
    return Text(
      "© ${DateTime.now().year} ${AppLocalizations.of(context).developerName}. ${AppLocalizations.of(context).allRightsReserved}",
      style: TextStyle(
        fontSize: 14,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
    );
  }
}
