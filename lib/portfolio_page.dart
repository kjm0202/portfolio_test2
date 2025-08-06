import 'package:flutter/material.dart';
import 'intro_section.dart';
import 'projects_section.dart';
import 'contact_section.dart';
import 'footer.dart';
import 'theme_toggle.dart';

class PortfolioPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const PortfolioPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
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

  static const _navItems = [
    {'label': 'Home', 'icon': Icons.home_outlined, 'index': 0},
    {'label': 'Projects', 'icon': Icons.work_outline, 'index': 1},
    {'label': 'Contact', 'icon': Icons.mail_outline, 'index': 2},
  ];

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
    final shouldBeScrolled = scrollController.offset > 20;
    if (shouldBeScrolled != isScrolled) {
      setState(() {
        isScrolled = shouldBeScrolled;
      });
    }
  }

  void _scrollToSection(int index) {
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

    if (targetKey?.currentContext != null) {
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

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: false,
                    elevation: isScrolled ? 4 : 0,
                    backgroundColor:
                        isScrolled
                            ? theme.scaffoldBackgroundColor
                            : Colors.transparent,
                    title: Row(
                      children: [
                        Icon(
                          Icons.code,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "John Developer",
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      if (!isSmallScreen) ..._buildNavItems(theme),
                      const SizedBox(width: 16),
                      ThemeToggle(
                        isDarkMode: widget.isDarkMode,
                        onToggle: widget.onThemeToggle,
                      ),
                      const SizedBox(width: 24),
                    ],
                    bottom:
                        isSmallScreen
                            ? PreferredSize(
                              preferredSize: const Size.fromHeight(50),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(children: _buildNavItems(theme)),
                              ),
                            )
                            : null,
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
                            const Footer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (!isSmallScreen)
                Positioned(
                  bottom: 32,
                  right: 32,
                  child: FloatingActionButton(
                    onPressed: () {
                      scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    backgroundColor: theme.colorScheme.primary,
                    child: Icon(
                      Icons.arrow_upward,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildNavItems(ThemeData theme) {
    return _navItems.map((item) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextButton.icon(
          onPressed: () => _scrollToSection(item['index'] as int),
          icon: Icon(
            item['icon'] as IconData,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          label: Text(
            item['label'] as String,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }).toList();
  }
}
