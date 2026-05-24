import 'package:flutter/material.dart';

import '../theme/portal_theme.dart';

class SubmissionsScreen extends StatelessWidget {
  const SubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PortalEmptyStateScreen(
      title: 'Submissions',
      body: 'Proof upload and submission tracking will live here.',
      icon: Icons.cloud_upload_rounded,
    );
  }
}
