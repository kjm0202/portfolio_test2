import 'package:flutter/material.dart';
import 'intro_section.dart';
import 'projects_section.dart';
import 'contact_section.dart';
import 'footer.dart';
import 'theme_toggle.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final scrollController = ScrollController();
  bool isScrolled = false;

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
    if (scrollController.offset > 20 && !isScrolled) {
      setState(() {
        isScrolled = true;
      });
    } else if (scrollController.offset <= 20 && isScrolled) {
      setState(() {
        isScrolled = false;
      });
    }
  }

  void _scrollToSection(int index) {
    final screenHeight = MediaQuery.of(context).size.height;
    scrollController.animateTo(
      index * screenHeight,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 800;

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
                backgroundColor: isScrolled 
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
                        color: theme.colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                actions: [
                  if (!isSmallScreen) ..._buildNavItems(),
                  const SizedBox(width: 16),
                  const ThemeToggle(),
                  const SizedBox(width: 24),
                ],
                bottom: isSmallScreen 
                    ? PreferredSize(
                        preferredSize: const Size.fromHeight(50),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: _buildNavItems(),
                          ),
                        ),
                      )
                    : null,
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const IntroSection(),
                    const Divider(height: 1, thickness: 1),
                    const ProjectsSection(),
                    const Divider(height: 1, thickness: 1),
                    const ContactSection(),
                    const Footer(),
                  ],
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
  }

  List<Widget> _buildNavItems() {
    final navItems = [
      {'label': 'Home', 'icon': Icons.home_outlined, 'index': 0},
      {'label': 'Projects', 'icon': Icons.work_outline, 'index': 1},
      {'label': 'Contact', 'icon': Icons.mail_outline, 'index': 2},
    ];

    return navItems.map((item) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextButton.icon(
          onPressed: () => _scrollToSection(item['index'] as int),
          icon: Icon(
            item['icon'] as IconData,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          label: Text(
            item['label'] as String,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }).toList();
  }
}