import 'package:flutter/material.dart';
import 'dart:math' show min;
import 'package:portfolio_test2/core/app_localizations.dart';
import 'package:portfolio_test2/data/projects.dart';
import 'package:portfolio_test2/presentation/widgets/section_header.dart';
import 'package:portfolio_test2/presentation/widgets/category_filter.dart';
import 'package:portfolio_test2/presentation/widgets/project_card.dart';

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
        final isSmallScreen = constraints.maxWidth < 1200;

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
              CategoryFilter(
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
    final filteredProjects = Projects.getByCategory(_selectedCategory);

    final spacing = screenWidth < 1200 ? 16.0 : 24.0;

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

        // 모바일(1열): ListView로 내용에 맞게 높이 자동 조정
        // 데스크톱(3열): GridView로 카드 높이 통일
        if (isSmallScreen) {
          // 모바일: ListView (높이 자동)
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredProjects.length,
            separatorBuilder: (context, index) => SizedBox(height: spacing),
            itemBuilder: (context, index) =>
                _buildAnimatedCard(filteredProjects, index, useFixedHeight: false),
          );
        } else {
          // 데스크톱: GridView (고정 높이)
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: 1.35,
            ),
            itemCount: filteredProjects.length,
            itemBuilder: (context, index) =>
                _buildAnimatedCard(filteredProjects, index, useFixedHeight: true),
          );
        }
      },
    );
  }

  Widget _buildAnimatedCard(
    List<Project> projects,
    int index, {
    required bool useFixedHeight,
  }) {
    final project = projects[index];
    final animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          (index / projects.length) * 0.7,
          min(1.0, ((index + 1) / projects.length) * 0.7 + 0.3),
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
        child: ProjectCard(
          project: project,
          useFixedHeight: useFixedHeight,
        ),
      ),
    );
  }
}
