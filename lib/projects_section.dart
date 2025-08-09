import 'package:flutter/material.dart';
import 'dart:math' show min;
import 'app_localizations.dart';
import 'models/project.dart';
import 'services/project_service.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ProjectCategory _selectedCategory = ProjectCategory.all;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    if (mounted) {
      try {
        _controller.forward();
      } catch (e) {
        // Controller might be disposed
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!mounted) return const SizedBox.shrink();
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
    if (!mounted) return const SizedBox.shrink();
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
    if (!mounted) return const SizedBox.shrink();
    final localizations = AppLocalizations.of(context);
    final categories = ProjectService.getFilterCategories();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ChoiceChip(
                label: Text(
                  ProjectService.getCategoryLabel(category, localizations),
                  style: TextStyle(
                    color: isSelected
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
                  if (selected && mounted) {
                    setState(() {
                      _selectedCategory = category;
                    });
                    if (mounted) {
                      try {
                        _controller.reset();
                        _controller.forward();
                      } catch (e) {
                        // Controller might be disposed
                      }
                    }
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
    if (!mounted) return const SizedBox.shrink();
    final localizations = AppLocalizations.of(context);
    // Filter projects based on selected category
    final filteredProjects = ProjectService.getFilteredProjects(_selectedCategory);

    // Calculate card width based on screen width
    double cardWidth;
    if (screenWidth >= 1200) {
      cardWidth = (screenWidth - 80 - 48) / 3; // 3 columns with padding and spacing
    } else if (screenWidth >= 900) {
      cardWidth = (screenWidth - 80 - 24) / 2; // 2 columns
    } else if (screenWidth >= 600) {
      cardWidth = (screenWidth - 80 - 24) / 2; // 2 columns
    } else {
      cardWidth = screenWidth - 40; // 1 column with padding
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
        if (!mounted) {
          return const SizedBox.shrink();
        }
        return Wrap(
          spacing: screenWidth < 600 ? 16 : 24,
          runSpacing: screenWidth < 600 ? 16 : 24,
          children: filteredProjects.asMap().entries.map((entry) {
            final index = entry.key;
            final project = entry.value;
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
                child: SizedBox(
                  width: cardWidth,
                  child: _buildProjectCard(theme, project),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildProjectCard(ThemeData theme, Project project) {
    if (!mounted) return const SizedBox.shrink();
    final localizations = AppLocalizations.of(context);

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
                      project.icon,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  Chip(
                    label: Text(
                      ProjectService.getCategoryLabel(project.category, localizations),
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
                ProjectService.getLocalizedProjectTitle(project, localizations),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                ProjectService.getLocalizedProjectDescription(project, localizations),
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
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
