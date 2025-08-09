import '../models/project.dart';
import '../data/projects_data.dart';
import '../app_localizations.dart';

class ProjectService {
  /// 카테고리 라벨을 가져옵니다 (자동화됨)
  static String getCategoryLabel(ProjectCategory category, AppLocalizations localizations) {
    return localizations.getCategoryLabel(category.name);
  }

  /// 프로젝트 제목을 가져옵니다 (자동화됨)
  static String getLocalizedProjectTitle(Project project, AppLocalizations localizations) {
    return localizations.getProjectTitle(project.id);
  }

  /// 프로젝트 설명을 가져옵니다 (자동화됨)
  static String getLocalizedProjectDescription(Project project, AppLocalizations localizations) {
    return localizations.getProjectDescription(project.id);
  }

  /// 필터링된 프로젝트 목록을 가져옵니다
  static List<Project> getFilteredProjects(ProjectCategory selectedCategory) {
    return ProjectsData.getProjectsByCategory(selectedCategory);
  }

  /// 필터 카테고리 목록을 가져옵니다
  static List<ProjectCategory> getFilterCategories() {
    return ProjectsData.filterCategories;
  }
}