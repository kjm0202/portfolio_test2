import 'package:flutter/material.dart';
import 'package:portfolio_test2/core/app_localizations.dart';
import 'package:portfolio_test2/data/projects.dart';

class CategoryFilter extends StatelessWidget {
  final ProjectCategory selected;
  final ValueChanged<ProjectCategory> onChanged;

  const CategoryFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final categories = Projects.filterCategories;

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
                    Projects.getCategoryLabel(category, localizations),
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
