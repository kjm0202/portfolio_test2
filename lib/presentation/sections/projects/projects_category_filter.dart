import 'package:flutter/material.dart';
import 'package:portfolio_test2/core/app_localizations.dart';
import 'package:portfolio_test2/domain/models/project.dart';
import 'package:portfolio_test2/domain/services/project_service.dart';

class ProjectsCategoryFilter extends StatelessWidget {
  final ProjectCategory selected;
  final ValueChanged<ProjectCategory> onChanged;

  const ProjectsCategoryFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final categories = ProjectService.getFilterCategories();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            categories.map((category) {
              final isSelected = selected == category;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ChoiceChip(
                  label: Text(
                    ProjectService.getCategoryLabel(category, localizations),
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
                    if (selected) onChanged(category);
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
