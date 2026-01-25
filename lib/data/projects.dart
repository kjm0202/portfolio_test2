import 'package:flutter/material.dart';
import 'package:portfolio_test2/core/app_localizations.dart';

// ============================================================================
// Model
// ============================================================================

enum ProjectCategory { all, web, mobile, uiux, backend }

class Project {
  final String id;
  final ProjectCategory category;
  final IconData icon;

  const Project({required this.id, required this.category, required this.icon});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Project && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// ============================================================================
// Project IDs
// ============================================================================

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

// ============================================================================
// Data & Service (통합)
// ============================================================================

class Projects {
  static const List<ProjectCategory> filterCategories = [
    ProjectCategory.all,
    ProjectCategory.web,
    ProjectCategory.mobile,
    ProjectCategory.uiux,
    // ProjectCategory.backend,
  ];

  static const List<Project> all = [
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
  static final Map<ProjectCategory, List<Project>> _byCategory = {
    for (var category in ProjectCategory.values)
      category:
          category == ProjectCategory.all
              ? all
              : all.where((p) => p.category == category).toList(),
  };

  /// 카테고리별 프로젝트 목록
  static List<Project> getByCategory(ProjectCategory category) {
    return _byCategory[category] ?? [];
  }

  /// 카테고리 라벨
  static String getCategoryLabel(
    ProjectCategory category,
    AppLocalizations localizations,
  ) {
    return localizations.getCategoryLabel(category.name);
  }

  /// 프로젝트 제목
  static String getTitle(Project project, AppLocalizations localizations) {
    return localizations.getProjectTitle(project.id);
  }

  /// 프로젝트 설명
  static String getDescription(
    Project project,
    AppLocalizations localizations,
  ) {
    return localizations.getProjectDescription(project.id);
  }
}
