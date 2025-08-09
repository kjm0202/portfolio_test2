import 'package:flutter/material.dart';
import 'package:portfolio_test2/domain/models/project.dart';

/// 프로젝트 ID 상수들 - 데이터와 함께 관리
class ProjectIds {
  static const String dreamhue = 'dreamhue';
  static const String portfolio = 'portfolio';
  static const String connectedFarm = 'connectedFarm';
  static const String connect = 'connect';
  static const String sims = 'sims';
  static const String gachonNoti = 'gachonNoti';

  /// 모든 프로젝트 ID 목록 (검증용)
  static const List<String> all = [
    dreamhue,
    portfolio,
    connectedFarm,
    connect,
    sims,
    gachonNoti,
  ];
}

class ProjectsData {
  static const List<ProjectCategory> filterCategories = [
    ProjectCategory.all,
    ProjectCategory.web,
    ProjectCategory.mobile,
    ProjectCategory.uiux,
    // ProjectCategory.backend, // Commented out as in original
  ];

  static const List<Project> projects = [
    Project(
      id: ProjectIds.dreamhue,
      category: ProjectCategory.mobile,
      icon: Icons.bedtime_outlined,
    ),
    Project(
      id: ProjectIds.portfolio,
      category: ProjectCategory.web,
      icon: Icons.web_outlined,
    ),
    Project(
      id: ProjectIds.connectedFarm,
      category: ProjectCategory.uiux,
      icon: Icons.agriculture_outlined,
    ),
    Project(
      id: ProjectIds.connect,
      category: ProjectCategory.backend,
      icon: Icons.connect_without_contact_outlined,
    ),
    Project(
      id: ProjectIds.sims,
      category: ProjectCategory.mobile,
      icon: Icons.inventory_outlined,
    ),
    Project(
      id: ProjectIds.gachonNoti,
      category: ProjectCategory.web,
      icon: Icons.notifications_outlined,
    ),
  ];

  // 카테고리별로 미리 그룹화된 맵 (성능 최적화)
  static final Map<ProjectCategory, List<Project>> _projectsByCategory = {
    for (var category in ProjectCategory.values)
      category:
          category == ProjectCategory.all
              ? projects
              : projects.where((p) => p.category == category).toList(),
  };

  static List<Project> getProjectsByCategory(ProjectCategory category) {
    return _projectsByCategory[category] ?? [];
  }
}
