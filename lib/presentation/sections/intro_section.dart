import 'package:flutter/material.dart';
import 'dart:math' show min;
import 'package:portfolio_test2/core/app_localizations.dart';

class IntroSection extends StatelessWidget {
  const IntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);
        final localizations = AppLocalizations.of(context);
        final isSmallScreen = constraints.maxWidth < 1200;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 20 : 40,
            vertical: 60,
          ),
          child: Column(
            // 모바일/태블릿에서는 중앙 정렬, 데스크톱에서는 왼쪽 정렬
            crossAxisAlignment:
                isSmallScreen
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment:
                    isSmallScreen
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!isSmallScreen) _buildProfileImage(context),
                  Flexible(
                    child: Column(
                      // 모바일/태블릿에서는 중앙 정렬
                      crossAxisAlignment:
                          isSmallScreen
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                      children: [
                        if (isSmallScreen) _buildProfileImage(context),
                        const SizedBox(height: 24),
                        Text(
                          localizations.introGreeting,
                          style: theme.textTheme.titleMedium,
                          textAlign:
                              isSmallScreen ? TextAlign.center : TextAlign.start,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize:
                              isSmallScreen
                                  ? MainAxisSize.min
                                  : MainAxisSize.max,
                          mainAxisAlignment:
                              isSmallScreen
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.start,
                          children: [
                            // 이름에만 그라데이션 적용
                            ShaderMask(
                              shaderCallback:
                                  (bounds) => LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.secondary,
                                    ],
                                  ).createShader(bounds),
                              child: Text(
                                localizations.developerName,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: isSmallScreen ? 32 : 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (localizations.locale.languageCode ==
                                "ko") ...[
                              const SizedBox(width: 8),
                              // "입니다"는 일반 텍스트 색상 (라이트: 검정, 다크: 흰색)
                              Text(
                                localizations.developerNameSuffix,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: isSmallScreen ? 32 : 48,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          localizations.jobTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                          textAlign:
                              isSmallScreen ? TextAlign.center : TextAlign.start,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          localizations.introDescription,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                          textAlign:
                              isSmallScreen ? TextAlign.center : TextAlign.start,
                        ),
                        const SizedBox(height: 32),
                        Wrap(
                          spacing: 16.0,
                          runSpacing: 12.0,
                          alignment:
                              isSmallScreen
                                  ? WrapAlignment.center
                                  : WrapAlignment.start,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.download_rounded,
                                color: theme.colorScheme.onPrimary,
                              ),
                              label: Text(
                                localizations.downloadCV,
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 16 : 24,
                                  vertical: 16,
                                ),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 16 : 24,
                                  vertical: 16,
                                ),
                              ),
                              child: Text(
                                localizations.contactMe,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // TODO: 소셜 링크 아이콘 임시 비활성화
                        // const SizedBox(height: 24),
                        // _buildSocialLinks(context, isSmallScreen),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 1200;

        return Container(
          constraints: BoxConstraints(
            maxWidth: 450,
            minWidth: min(isSmallScreen ? constraints.maxWidth - 40 : 350, 450),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.8),
                      Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: isSmallScreen ? 120 : 150,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.person,
                    size: isSmallScreen ? 120 : 150,
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withValues(alpha: 0.5),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.code,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context).yearsExperience,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSocialLinks(BuildContext context, bool isSmallScreen) {
    final socialIcons = [
      Icons.mail_outline_rounded,
      Icons.facebook_outlined,
      Icons.school_outlined,
      Icons.work_outlined,
      Icons.code,
    ];

    return Row(
      mainAxisAlignment:
          isSmallScreen ? MainAxisAlignment.center : MainAxisAlignment.start,
      children:
          socialIcons.map((icon) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
