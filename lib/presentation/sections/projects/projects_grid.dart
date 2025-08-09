import 'package:flutter/material.dart';
import 'package:portfolio_test2/domain/models/project.dart';
import 'package:portfolio_test2/presentation/sections/projects/project_card.dart';

class ProjectsGrid extends StatelessWidget {
  final List<Project> projects;
  final double screenWidth;

  const ProjectsGrid({
    super.key,
    required this.projects,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    // 기존 계산식을 유지하여 동일한 카드 폭을 유지
    double cardWidth;
    if (screenWidth >= 1200) {
      cardWidth = (screenWidth - 80 - 48) / 3;
    } else if (screenWidth >= 900) {
      cardWidth = (screenWidth - 80 - 24) / 2;
    } else if (screenWidth >= 600) {
      cardWidth = (screenWidth - 80 - 24) / 2;
    } else {
      cardWidth = screenWidth - 40;
    }

    return Wrap(
      spacing: screenWidth < 600 ? 16 : 24,
      runSpacing: screenWidth < 600 ? 16 : 24,
      children:
          projects
              .map(
                (p) =>
                    SizedBox(width: cardWidth, child: ProjectCard(project: p)),
              )
              .toList(),
    );
  }
}
