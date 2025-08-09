import 'package:flutter/material.dart';
import 'package:portfolio_test2/core/app_localizations.dart';

class NavigationItems extends StatelessWidget {
  final ThemeData theme;
  final Function(int) onItemTapped;

  const NavigationItems({
    super.key,
    required this.theme,
    required this.onItemTapped,
  });

  static const _navItems = [
    {'key': 'home', 'icon': Icons.home_outlined, 'index': 0},
    {'key': 'projects', 'icon': Icons.work_outline, 'index': 1},
    {'key': 'contact', 'icon': Icons.mail_outline, 'index': 2},
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Row(
      children:
          _navItems.map((item) {
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

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextButton.icon(
                onPressed: () => onItemTapped(item['index'] as int),
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
}
