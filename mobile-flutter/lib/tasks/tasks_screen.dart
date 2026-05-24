import 'package:flutter/material.dart';

import '../theme/portal_theme.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PortalEmptyStateScreen(
      title: 'Tasks',
      body: 'Task list and task details will be implemented here.',
      icon: Icons.task_alt_rounded,
    );
  }
}
