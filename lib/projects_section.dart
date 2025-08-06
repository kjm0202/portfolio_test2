import 'package:flutter/material.dart';
import 'dart:math' show min;

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
              "PORTFOLIO",
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
        Text("Featured Projects", style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          width: 600,
          child: Text(
            "Here are some of my recent projects. Each one was carefully crafted with attention to detail and user experience.",
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(ThemeData theme) {
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
                      category,
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
    // Filter projects based on selected category
    final filteredProjects =
        _selectedCategory == 'All'
            ? _projects
            : _projects
                .where((p) => p['category'] == _selectedCategory)
                .toList();

    // Calculate grid cross-axis count based on screen width
    int crossAxisCount = 3;
    if (screenWidth < 1200 && screenWidth >= 800) {
      crossAxisCount = 2;
    } else if (screenWidth < 800) {
      crossAxisCount = 1;
    }

    if (filteredProjects.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            "No projects found in this category.",
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
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: isSmallScreen ? 1.1 : 1.2,
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
                      color: theme.colorScheme.primary.withOpacity(0.1),
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
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                project['title'] as String,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  project['description'] as String,
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
                      'View Project',
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
