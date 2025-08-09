import 'package:flutter/material.dart';
import 'package:portfolio_test2/core/app_localizations.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);

        final isSmallScreen = constraints.maxWidth < 900;
        final isMediumScreen =
            constraints.maxWidth < 1000 && constraints.maxWidth >= 900;

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
              isSmallScreen || isMediumScreen
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildLogo(context, theme),
                      const SizedBox(height: 24),
                      _buildNavLinks(
                        context,
                        theme,
                        isSmallScreen || isMediumScreen,
                      ),
                      const SizedBox(height: 24),
                      _buildCopyright(context, theme),
                    ],
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLogo(context, theme),
                      _buildNavLinks(
                        context,
                        theme,
                        isSmallScreen || isMediumScreen,
                      ),
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
    final links = [
      localizations.navHome,
      localizations.navAbout,
      localizations.navProjects,
      localizations.navContact,
    ];

    return isSmallOrMedium
        ? Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children:
              links.map((link) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      link,
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
              links.map((link) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      link,
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
