import 'package:flutter/material.dart';
import 'dart:math' show min;
import 'app_localizations.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  static const List<String> _filterCategories = [
    'All',
    'Web',
    'Mobile',
    'UI/UX',
    // 'Backend',
  ];
  String _selectedCategory = 'All';

  static const List<Map<String, dynamic>> _projects = [
    {
      'title': 'E-Commerce App',
      'category': 'Mobile',
      'icon': Icons.shopping_bag_outlined,
      'description':
          'A clean, modern e-commerce app with a seamless checkout process.',
    },
    {
      'title': 'Portfolio Website',
      'category': 'Web',
      'icon': Icons.web_outlined,
      'description': 'Responsive portfolio website built with Flutter web.',
    },
    {
      'title': 'Task Manager',
      'category': 'UI/UX',
      'icon': Icons.check_circle_outline,
      'description':
          'A beautiful task management UI with intuitive interactions.',
    },
    {
      'title': 'API Service',
      'category': 'Backend',
      'icon': Icons.settings_ethernet_outlined,
      'description':
          'RESTful API developed for a client project with secure auth.',
    },
    {
      'title': 'Travel App',
      'category': 'Mobile',
      'icon': Icons.flight_outlined,
      'description':
          'User-friendly travel booking app with personalized recommendations.',
    },
    {
      'title': 'Banking Dashboard',
      'category': 'Web',
      'icon': Icons.account_balance_outlined,
      'description':
          'Secure banking dashboard with real-time transaction monitoring.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getCardAspectRatio(double screenWidth, int crossAxisCount) {
    // 화면 크기와 컬럼 수에 따라 카드 비율 조정
    if (screenWidth < 600) {
      return 1.1; // 모바일: 세로가 조금 더 긴 카드
    } else if (screenWidth < 900) {
      return 1.0; // 폴더블/태블릿: 정사각형에 가까운 카드
    } else if (crossAxisCount == 2) {
      return 1.1; // 중간 화면에서 2컬럼: 적당한 비율
    } else {
      return 1.2; // 큰 화면에서 3컬럼: 가로가 조금 더 긴 카드
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final theme = Theme.of(context);
        final isSmallScreen = constraints.maxWidth < 800;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 20 : 40,
            vertical: 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(theme),
              const SizedBox(height: 32),
              _buildCategoryFilter(theme),
              const SizedBox(height: 40),
              _buildProjectsGrid(theme, isSmallScreen, constraints.maxWidth),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(ThemeData theme) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              localizations.portfolioLabel,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(localizations.featuredProjects, style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          width: 600,
          child: Text(
            localizations.projectsDescription,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(ThemeData theme) {
    final localizations = AppLocalizations.of(context);

    String getCategoryLabel(String category) {
      switch (category) {
        case 'All':
          return localizations.categoryAll;
        case 'Web':
          return localizations.categoryWeb;
        case 'Mobile':
          return localizations.categoryMobile;
        case 'UI/UX':
          return localizations.categoryUIUX;
        /* case 'Backend':
          return localizations.categoryBackend; */
        default:
          return category;
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            _filterCategories.map((category) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: ChoiceChip(
                    label: Text(
                      getCategoryLabel(category),
                      style: TextStyle(
                        color:
                            isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.primary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: theme.colorScheme.primary,
                    backgroundColor: theme.colorScheme.surface,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = category;
                          _controller.reset();
                          _controller.forward();
                        });
                      }
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildProjectsGrid(
    ThemeData theme,
    bool isSmallScreen,
    double screenWidth,
  ) {
    final localizations = AppLocalizations.of(context);
    // Filter projects based on selected category
    final filteredProjects =
        _selectedCategory == 'All'
            ? _projects
            : _projects
                .where((p) => p['category'] == _selectedCategory)
                .toList();

    // Calculate grid cross-axis count based on screen width with better breakpoints
    int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 3;
    } else if (screenWidth >= 900) {
      crossAxisCount = 2; // 폴더블 폰 펼친 상태 (900-1200px)
    } else if (screenWidth >= 600) {
      crossAxisCount = 2; // 태블릿 세로 모드 (600-900px)
    } else {
      crossAxisCount = 1; // 일반 폰 (600px 미만)
    }

    if (filteredProjects.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            localizations.noProjectsFound,
            style: theme.textTheme.titleMedium,
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: screenWidth < 600 ? 16 : 24,
            mainAxisSpacing: screenWidth < 600 ? 16 : 24,
            childAspectRatio: _getCardAspectRatio(screenWidth, crossAxisCount),
          ),
          itemCount: filteredProjects.length,
          itemBuilder: (context, index) {
            final project = filteredProjects[index];
            final animation = Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  (index / filteredProjects.length) * 0.7,
                  min(1.0, ((index + 1) / filteredProjects.length) * 0.7 + 0.3),
                  curve: Curves.easeOut,
                ),
              ),
            );

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(animation),
                child: _buildProjectCard(theme, project),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProjectCard(ThemeData theme, Map<String, dynamic> project) {
    final localizations = AppLocalizations.of(context);

    String getProjectTitle(String title) {
      switch (title) {
        case 'E-Commerce App':
          return localizations.projectECommerceTitle;
        case 'Portfolio Website':
          return localizations.projectPortfolioTitle;
        case 'Task Manager':
          return localizations.projectTaskManagerTitle;
        case 'API Service':
          return localizations.projectAPIServiceTitle;
        case 'Travel App':
          return localizations.projectTravelAppTitle;
        case 'Banking Dashboard':
          return localizations.projectBankingTitle;
        default:
          return title;
      }
    }

    String getProjectDescription(String description) {
      switch (description) {
        case 'A clean, modern e-commerce app with a seamless checkout process.':
          return localizations.projectECommerceDesc;
        case 'Responsive portfolio website built with Flutter web.':
          return localizations.projectPortfolioDesc;
        case 'A beautiful task management UI with intuitive interactions.':
          return localizations.projectTaskManagerDesc;
        case 'RESTful API developed for a client project with secure auth.':
          return localizations.projectAPIServiceDesc;
        case 'User-friendly travel booking app with personalized recommendations.':
          return localizations.projectTravelAppDesc;
        case 'Secure banking dashboard with real-time transaction monitoring.':
          return localizations.projectBankingDesc;
        default:
          return description;
      }
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      project['icon'] as IconData,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  Chip(
                    label: Text(
                      project['category'] as String,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.1,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                getProjectTitle(project['title'] as String),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  getProjectDescription(project['description'] as String),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.remove_red_eye_outlined,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    label: Text(
                      localizations.viewProject,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
