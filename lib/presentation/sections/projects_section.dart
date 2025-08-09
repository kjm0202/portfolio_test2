import 'package:flutter/material.dart';
import 'dart:math' show min;
import 'package:portfolio_test2/core/app_localizations.dart';
import 'package:portfolio_test2/domain/models/project.dart';
import 'package:portfolio_test2/domain/services/project_service.dart';
import 'package:portfolio_test2/presentation/sections/widgets/section_header.dart';
import 'package:portfolio_test2/presentation/sections/projects/projects_category_filter.dart';
import 'package:portfolio_test2/presentation/sections/projects/project_card.dart';

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
              ProjectsCategoryFilter(
                selected: _selectedCategory,
                onChanged: (newCategory) {
                  if (!mounted) return;
                  setState(() => _selectedCategory = newCategory);
                  if (mounted) {
                    try {
                      _controller.reset();
                      _controller.forward();
                    } catch (_) {}
                  }
                },
              ),
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
    return SectionHeader(
      label: localizations.portfolioLabel,
      title: localizations.featuredProjects,
      description: localizations.projectsDescription,
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
    final filteredProjects = ProjectService.getFilteredProjects(
      _selectedCategory,
    );

    // Calculate card width based on screen width
    double cardWidth;
    if (screenWidth >= 1200) {
      cardWidth =
          (screenWidth - 80 - 48) / 3; // 3 columns with padding and spacing
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
          children:
              filteredProjects.asMap().entries.map((entry) {
                final index = entry.key;
                final project = entry.value;
                final animation = Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                      (index / filteredProjects.length) * 0.7,
                      min(
                        1.0,
                        ((index + 1) / filteredProjects.length) * 0.7 + 0.3,
                      ),
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
                      child: ProjectCard(project: project),
                    ),
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}
