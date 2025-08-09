import 'package:flutter/material.dart';
import 'package:portfolio_test2/presentation/sections/intro_section.dart';
import 'package:portfolio_test2/presentation/sections/projects_section.dart';
import 'package:portfolio_test2/presentation/sections/contact_section.dart';
import 'package:portfolio_test2/presentation/sections/footer.dart';
import 'package:portfolio_test2/presentation/app_bar/portfolio_app_bar.dart';
import 'package:portfolio_test2/presentation/widgets/scroll_to_top_button.dart';

class PortfolioPage extends StatefulWidget {
  final bool isDarkMode;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const PortfolioPage({
    super.key,
    required this.isDarkMode,
    required this.themeMode,
    required this.onThemeChanged,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final scrollController = ScrollController();
  bool isScrolled = false;

  // GlobalKeys for each section to get their positions
  final GlobalKey _introKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    final shouldBeScrolled = scrollController.offset > 20;
    if (shouldBeScrolled != isScrolled) {
      setState(() {
        isScrolled = shouldBeScrolled;
      });
    }
  }

  void _scrollToSection(int index) {
    if (!mounted) return;

    GlobalKey? targetKey;

    switch (index) {
      case 0:
        targetKey = _introKey;
        break;
      case 1:
        targetKey = _projectsKey;
        break;
      case 2:
        targetKey = _contactKey;
        break;
    }

    if (targetKey?.currentContext != null && mounted) {
      final RenderBox renderBox =
          targetKey!.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);

      // Account for the app bar height (approximately 80px)
      final targetOffset = position.dy + scrollController.offset - 80;

      scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);
        final isSmallScreen = constraints.maxWidth < 800;
        // 모바일/태블릿(폴더블 포함)에서는 푸터가 전체 가로를 차지하도록 별도 슬리버로 분리
        final isLargeScreen = constraints.maxWidth >= 1200;

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                controller: scrollController,
                slivers: [
                  PortfolioAppBar(
                    isScrolled: isScrolled,
                    isSmallScreen: isSmallScreen,
                    theme: theme,
                    isDarkMode: widget.isDarkMode,
                    themeMode: widget.themeMode,
                    onThemeChanged: widget.onThemeChanged,
                    currentLocale: widget.currentLocale,
                    onLocaleChanged: widget.onLocaleChanged,
                    onNavigationItemTapped: _scrollToSection,
                  ),
                  SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Column(
                          children: [
                            IntroSection(key: _introKey),
                            const Divider(height: 1, thickness: 1),
                            ProjectsSection(key: _projectsKey),
                            const Divider(height: 1, thickness: 1),
                            ContactSection(key: _contactKey),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 푸터: 모바일/태블릿에서는 전체 가로, 데스크톱에서는 본문 폭에 맞춰 노출
                  SliverToBoxAdapter(
                    child:
                        !isLargeScreen
                            ? const Footer()
                            : Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1200,
                                ),
                                child: const Footer(),
                              ),
                            ),
                  ),
                ],
              ),
              ScrollToTopButton(
                scrollController: scrollController,
                theme: theme,
                mounted: mounted,
              ),
            ],
          ),
        );
      },
    );
  }
}
