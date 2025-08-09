import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String label;
  final String title;
  final String? description;
  final double descriptionMaxWidth;

  const SectionHeader({
    super.key,
    required this.label,
    required this.title,
    this.description,
    this.descriptionMaxWidth = 600,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              label,
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
        Text(title, style: theme.textTheme.titleLarge),
        if (description != null) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: descriptionMaxWidth,
            child: Text(description!, style: theme.textTheme.bodyLarge),
          ),
        ],
      ],
    );
  }
}
