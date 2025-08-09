import 'package:flutter/material.dart';

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
