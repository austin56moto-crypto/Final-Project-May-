import 'package:flutter/material.dart';

import '../theme/portal_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PortalEmptyStateScreen(
      title: 'Notifications',
      body: 'Notifications and alerts will be shown here.',
      icon: Icons.notifications_active_rounded,
    );
  }
}
