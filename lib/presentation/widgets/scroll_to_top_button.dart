import 'package:flutter/material.dart';

class ScrollToTopButton extends StatelessWidget {
  final ScrollController scrollController;
  final ThemeData theme;
  final bool mounted;

  const ScrollToTopButton({
    super.key,
    required this.scrollController,
    required this.theme,
    required this.mounted,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      right: 32,
      child: FloatingActionButton(
        onPressed: () {
          if (mounted) {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.arrow_upward, color: theme.colorScheme.onPrimary),
      ),
    );
  }
}
