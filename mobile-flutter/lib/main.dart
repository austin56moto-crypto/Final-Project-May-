// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'auth/auth_screen.dart';
import 'services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final view = WidgetsBinding.instance.platformDispatcher.implicitView ??
      WidgetsBinding.instance.platformDispatcher.views.first;
  runWidget(View(view: view, child: const InternTaskApp()));
}

class InternTaskApp extends StatelessWidget {
  const InternTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF14B8A6),
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF5EEAD4),
      secondary: const Color(0xFFF59E0B),
      tertiary: const Color(0xFF60A5FA),
      surface: const Color(0xFF0B1220),
      onSurface: Colors.white,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InternTask AI Cloud',
      theme: ThemeData(
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFF07111F),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF0A1426),
          indicatorColor: const Color(0xFF14B8A6).withAlpha(36),
          labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF0E1A2E),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(color: Colors.white.withAlpha(18)),
          ),
        ),
        textTheme: Typography.whiteMountainView.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const RoleGate(),
    );
  }
}

enum UserRole { admin, instructor, student }

extension UserRoleLabel on UserRole {
  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.instructor:
        return 'Instructor';
      case UserRole.student:
        return 'Student';
    }
  }
}

class PortalTask {
  final String id;
  final String title;
  final String detail;
  final String dueLabel;
  final UserRole assignee;
  final bool completed;
  final String? attachmentName;
  final DateTime? submittedAt;
  final DateTime createdAt;

  const PortalTask({
    required this.id,
    required this.title,
    required this.detail,
    required this.dueLabel,
    required this.assignee,
    required this.completed,
    this.attachmentName,
    this.submittedAt,
    required this.createdAt,
  });

  PortalTask copyWith({
    String? id,
    String? title,
    String? detail,
    String? dueLabel,
    UserRole? assignee,
    bool? completed,
    String? attachmentName,
    DateTime? submittedAt,
    DateTime? createdAt,
  }) {
    return PortalTask(
      id: id ?? this.id,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      dueLabel: dueLabel ?? this.dueLabel,
      assignee: assignee ?? this.assignee,
      completed: completed ?? this.completed,
      attachmentName: attachmentName ?? this.attachmentName,
      submittedAt: submittedAt ?? this.submittedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get statusLabel {
    if (completed && attachmentName != null) {
      return 'Submitted';
    }
    return completed ? 'Completed' : 'In progress';
  }
}

class TaskStore extends ChangeNotifier {
  final List<PortalTask> _tasks = [
    PortalTask(
      id: 'task-1',
      title: 'Configure project workspace',
      detail: 'Set up the Flutter project and verify the core portal layout.',
      dueLabel: 'Due today',
      assignee: UserRole.student,
      completed: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    PortalTask(
      id: 'task-2',
      title: 'Review AWS architecture draft',
      detail: 'Check the main services and confirm the assignment scope.',
      dueLabel: 'Due tomorrow',
      assignee: UserRole.student,
      completed: true,
      attachmentName: 'architecture-notes.pdf',
      submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    PortalTask(
      id: 'task-3',
      title: 'Prepare instructor feedback',
      detail: 'Summarize the last set of student submissions.',
      dueLabel: 'Due Friday',
      assignee: UserRole.instructor,
      completed: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 10)),
    ),
  ];

  List<PortalTask> tasksFor(UserRole role) {
    if (role == UserRole.admin) {
      return List.unmodifiable(_tasks);
    }
    return List.unmodifiable(
      _tasks.where((task) => task.assignee == role),
    );
  }

  void addTask(PortalTask task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) {
      return;
    }

    _tasks[index] = _tasks[index].copyWith(
      completed: !_tasks[index].completed,
    );
    notifyListeners();
  }

  void submitTask(String id, String attachmentName) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) {
      return;
    }

    _tasks[index] = _tasks[index].copyWith(
      completed: true,
      attachmentName: attachmentName,
      submittedAt: DateTime.now(),
    );
    notifyListeners();
  }
}

class RoleGate extends StatefulWidget {
  const RoleGate({super.key});

  @override
  State<RoleGate> createState() => _RoleGateState();
}

class _RoleGateState extends State<RoleGate> {
  final AuthService _authService = const AuthService();
  final TaskStore _store = TaskStore();
  AuthSession? _session;

  Future<AuthSession> _handleSignIn({
    required String email,
    required String password,
    required String role,
  }) async {
    final session = await _authService.signIn(
      email: email,
      password: password,
      role: role,
    );
    if (!mounted) {
      return session;
    }
    setState(() => _session = session);
    return session;
  }

  void _handleSignOut() {
    setState(() => _session = null);
  }

  UserRole _roleFromSession(AuthSession session) {
    switch (session.role) {
      case 'Admin':
        return UserRole.admin;
      case 'Instructor':
        return UserRole.instructor;
      default:
        return UserRole.student;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    if (session == null) {
      return AuthScreen(
        onSignIn: _handleSignIn,
      );
    }

    return Shell(
      store: _store,
      role: _roleFromSession(session),
      session: session,
      onSignOut: _handleSignOut,
    );
  }
}

class Shell extends StatefulWidget {
  final TaskStore store;
  final UserRole role;
  final AuthSession session;
  final VoidCallback onSignOut;

  const Shell({
    super.key,
    required this.store,
    required this.role,
    required this.session,
    required this.onSignOut,
  });

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  static const _pages = <UserRole, _ModePage>{
    UserRole.admin: _ModePage(
      key: ValueKey('admin'),
      title: 'Admin',
      subtitle:
          'Manage users, monitor system health, and keep everything aligned.',
      accent: Color(0xFFF59E0B),
      stats: [
        _Stat(label: 'Users', value: '128'),
        _Stat(label: 'Tasks', value: '42'),
        _Stat(label: 'Alerts', value: '7'),
      ],
      actions: [
        _Action(
            title: 'User management',
            detail: 'Invite, approve, or disable accounts.'),
        _Action(
            title: 'Role control',
            detail: 'Assign instructor and student access.'),
        _Action(
            title: 'Audit trail',
            detail: 'Review recent changes and activity logs.'),
      ],
      progress: [
        _Progress(label: 'Onboarding completed', value: 0.86),
        _Progress(label: 'Open approvals', value: 0.73),
        _Progress(label: 'Backup coverage', value: 0.99),
      ],
      activity: [
        _Activity(
          time: '10 min ago',
          title: '2 student accounts approved',
          detail: 'New users now have access to the dashboard.',
        ),
        _Activity(
          time: 'Today',
          title: 'Backup verification passed',
          detail: 'The latest automation run completed without errors.',
        ),
        _Activity(
          time: 'Yesterday',
          title: 'Instructor role audit reviewed',
          detail: 'Permissions were matched against the current policy set.',
        ),
      ],
    ),
    UserRole.instructor: _ModePage(
      key: ValueKey('instructor'),
      title: 'Instructor',
      subtitle:
          'Create tasks, generate AI drafts, and review submissions quickly.',
      accent: Color(0xFF14B8A6),
      stats: [
        _Stat(label: 'Open tasks', value: '18'),
        _Stat(label: 'Submissions', value: '11'),
        _Stat(label: 'AI drafts', value: '5'),
      ],
      actions: [
        _Action(
            title: 'Create tasks',
            detail: 'Build manual or AI-generated assignments.'),
        _Action(
            title: 'Review proof',
            detail: 'Approve or request changes on submissions.'),
        _Action(
            title: 'Notify interns',
            detail: 'Send updates and reminders in one tap.'),
      ],
      progress: [
        _Progress(label: 'Tasks complete', value: 0.62),
        _Progress(label: 'Proof reviewed', value: 0.41),
        _Progress(label: 'AI draft quality', value: 0.78),
      ],
      activity: [
        _Activity(
          time: '5 min ago',
          title: 'New S3 task draft created',
          detail: 'A beginner-friendly assignment is ready for review.',
        ),
        _Activity(
          time: '1 hour ago',
          title: 'Submission flagged for revision',
          detail: 'One upload needs a clearer screenshot from the student.',
        ),
        _Activity(
          time: 'Today',
          title: 'Reminder scheduled',
          detail: 'Deadline alerts will send automatically at 5:00 PM.',
        ),
      ],
    ),
    UserRole.student: _ModePage(
      key: ValueKey('student'),
      title: 'Student',
      subtitle:
          'See assigned work, upload proof, and track progress from one place.',
      accent: Color(0xFF60A5FA),
      stats: [
        _Stat(label: 'Assigned', value: '6'),
        _Stat(label: 'Done', value: '4'),
        _Stat(label: 'Pending', value: '2'),
      ],
      actions: [
        _Action(
            title: 'My tasks',
            detail: 'View what’s assigned and what’s due next.'),
        _Action(
            title: 'Upload proof',
            detail: 'Attach files and screenshots for review.'),
        _Action(
            title: 'Track status',
            detail: 'Monitor progress without leaving the app.'),
      ],
      progress: [
        _Progress(label: 'Assigned tasks', value: 0.68),
        _Progress(label: 'Completed tasks', value: 0.54),
        _Progress(label: 'Feedback received', value: 0.33),
      ],
      activity: [
        _Activity(
          time: '8 min ago',
          title: 'Proof upload accepted',
          detail: 'The latest screenshot is attached to the task history.',
        ),
        _Activity(
          time: 'Today',
          title: 'New comment from instructor',
          detail: 'There is one small update request on your submission.',
        ),
        _Activity(
          time: 'Tomorrow',
          title: 'One task due soon',
          detail: 'Finish the IAM role task before the deadline hits.',
        ),
      ],
    ),
  };

  @override
  Widget build(BuildContext context) {
    final page = _pages[widget.role]!;

    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final visibleTasks = widget.store.tasksFor(widget.role);

        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: const Text(
              'InternTask AI Cloud',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.2),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: _HealthChip(),
              ),
            ],
          ),
          body: Stack(
            children: [
              const _Background(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _ModeDashboard(
                  key: page.key,
                  page: page,
                  role: widget.role,
                  tasks: visibleTasks,
                  onCreateTask: widget.role == UserRole.admin
                      ? () => _openTaskComposer(context)
                      : null,
                  onToggleTask: (task) => widget.store.toggleTask(task.id),
                  onSubmitTask: widget.role == UserRole.student
                      ? (task) => _openSubmissionComposer(context, task)
                      : null,
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _RoleSwitchBar(
              currentRole: widget.role,
              session: widget.session,
              onSignOut: widget.onSignOut,
            ),
          ),
        );
      },
    );
  }

  void _openTaskComposer(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0B1220),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _TaskComposer(
        onCreate: (title, detail, dueLabel) {
          widget.store.addTask(
            PortalTask(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              title: title,
              detail: detail,
              dueLabel: dueLabel,
              assignee: UserRole.student,
              completed: false,
              createdAt: DateTime.now(),
            ),
          );
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _openSubmissionComposer(BuildContext context, PortalTask task) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0B1220),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _SubmissionComposer(
        task: task,
        onSubmit: (attachmentName) {
          widget.store.submitTask(task.id, attachmentName);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  final ValueChanged<UserRole> onSelect;

  const _RoleSelector({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _Background(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 940),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose your access',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pick one workspace to continue. Only the selected role will be shown after you enter.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withAlpha(180),
                              height: 1.45,
                            ),
                      ),
                      const SizedBox(height: 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final columns = width >= 760 ? 3 : 1;
                          return GridView.count(
                            crossAxisCount: columns,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: width >= 760 ? 1.02 : 1.85,
                            children: [
                              _RoleChoiceCard(
                                role: UserRole.admin,
                                accent: const Color(0xFFF59E0B),
                                description:
                                    'Manage users, permissions, and system health.',
                                onTap: () => onSelect(UserRole.admin),
                              ),
                              _RoleChoiceCard(
                                role: UserRole.instructor,
                                accent: const Color(0xFF14B8A6),
                                description:
                                    'Create tasks, review submissions, and send updates.',
                                onTap: () => onSelect(UserRole.instructor),
                              ),
                              _RoleChoiceCard(
                                role: UserRole.student,
                                accent: const Color(0xFF60A5FA),
                                description:
                                    'View assignments, upload proof, and track progress.',
                                onTap: () => onSelect(UserRole.student),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleChoiceCard extends StatelessWidget {
  final UserRole role;
  final Color accent;
  final String description;
  final VoidCallback onTap;

  const _RoleChoiceCard({
    required this.role,
    required this.accent,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF101B33),
              const Color(0xFF0E1A2E),
              accent.withAlpha(34),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withAlpha(16)),
          boxShadow: [
            BoxShadow(
              color: accent.withAlpha(28),
              blurRadius: 20,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: accent.withAlpha(36),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: accent.withAlpha(72)),
                ),
                child: Text(
                  role.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        fontSize: 12.5,
                      ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withAlpha(190),
                      height: 1.45,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Enter workspace',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_rounded, color: accent, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleSwitchBar extends StatelessWidget {
  final UserRole currentRole;
  final AuthSession session;
  final VoidCallback onSignOut;

  const _RoleSwitchBar({
    required this.currentRole,
    required this.session,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 420;

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A1426),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(14)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: compact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${session.displayName} · ${currentRole.label}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: onSignOut,
                          icon: const Icon(Icons.logout_rounded),
                          label: const Text('Sign out'),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${session.displayName} · ${currentRole.label}',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: onSignOut,
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text('Sign out'),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _ModePage {
  final Key key;
  final String title;
  final String subtitle;
  final Color accent;
  final List<_Stat> stats;
  final List<_Action> actions;
  final List<_Progress> progress;
  final List<_Activity> activity;

  const _ModePage({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.stats,
    required this.actions,
    required this.progress,
    required this.activity,
  });
}

class _Stat {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});
}

class _Action {
  final String title;
  final String detail;

  const _Action({required this.title, required this.detail});
}

class _Progress {
  final String label;
  final double value;

  const _Progress({required this.label, required this.value});
}

class _Activity {
  final String time;
  final String title;
  final String detail;

  const _Activity({
    required this.time,
    required this.title,
    required this.detail,
  });
}

class _ModeDashboard extends StatelessWidget {
  final _ModePage page;
  final UserRole role;
  final List<PortalTask> tasks;
  final VoidCallback? onCreateTask;
  final ValueChanged<PortalTask> onToggleTask;
  final ValueChanged<PortalTask>? onSubmitTask;

  const _ModeDashboard({
    super.key,
    required this.page,
    required this.role,
    required this.tasks,
    required this.onToggleTask,
    this.onCreateTask,
    this.onSubmitTask,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate =
        '${_weekday(now.weekday)}, ${_month(now.month)} ${now.day}';
    final taskCount = tasks.length;
    final openTasks = tasks.where((task) => !task.completed).length;
    final completedTasks = taskCount - openTasks;
    final canCreateTasks = onCreateTask != null;
    final canSubmitTasks = onSubmitTask != null;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 1040;
            final leftColumn = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderCard(
                  page: page,
                  formattedDate: formattedDate,
                ),
                const SizedBox(height: 18),
                const _SectionTitle(
                  title: 'Quick Stats',
                  subtitle: 'A compact overview of what matters right now.',
                ),
                const SizedBox(height: 12),
                _StatGrid(page: page),
                const SizedBox(height: 20),
                const _SectionTitle(
                  title: 'Core Actions',
                  subtitle: 'The main tools for the selected mode.',
                ),
                const SizedBox(height: 12),
                _ActionGrid(page: page),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: _SectionTitle(
                        title: 'Live Tasks',
                        subtitle:
                            'Assignments are shared here so the selected role sees the right work.',
                      ),
                    ),
                    if (canCreateTasks)
                      FilledButton.icon(
                        onPressed: onCreateTask,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('New task'),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                if (tasks.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: const Color(0xFF0E1A2E),
                      border: Border.all(color: Colors.white.withAlpha(14)),
                    ),
                    child: Text(
                      canCreateTasks
                          ? 'No tasks yet. Create the first student assignment to populate the portal.'
                          : 'No tasks have been assigned to this workspace yet.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withAlpha(180),
                            height: 1.45,
                          ),
                    ),
                  )
                else
                  ...tasks.map(
                    (task) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PortalTaskRow(
                        task: task,
                        accent: page.accent,
                        role: role,
                        canSubmitTask:
                            canSubmitTasks && role == UserRole.student,
                        onToggle: () => onToggleTask(task),
                        onSubmit: onSubmitTask == null
                            ? null
                            : () => onSubmitTask!(task),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                _FooterCallout(
                  title: '${page.title} mode is ready',
                  body:
                      'This workspace stays focused, professional, and functional while keeping the interface polished for class presentation.',
                  accent: page.accent,
                ),
              ],
            );

            if (!isWide) {
              return leftColumn;
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: leftColumn),
                const SizedBox(width: 18),
                SizedBox(
                  width: 320,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SidePanel(
                        page: page,
                        tasks: tasks,
                        openTasks: openTasks,
                        completedTasks: completedTasks,
                      ),
                      const SizedBox(height: 16),
                      _ProgressCard(page: page),
                      const SizedBox(height: 16),
                      _ActivityCard(page: page),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final _ModePage page;
  final String formattedDate;

  const _HeaderCard({required this.page, required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF101B33),
            const Color(0xFF0D1729),
            page.accent.withAlpha(34),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withAlpha(18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RolePill(title: page.title, accent: page.accent),
          const SizedBox(height: 14),
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            page.subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withAlpha(206),
                  height: 1.45,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Updated $formattedDate',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withAlpha(150),
                ),
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _MetaPill(label: 'Cognito', value: 'Auth'),
              _MetaPill(label: 'Lambda', value: 'Backend'),
              _MetaPill(label: 'DynamoDB', value: 'Data'),
              _MetaPill(label: 'S3', value: 'Files'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  final _ModePage page;

  const _StatGrid({required this.page});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 800
            ? 3
            : width >= 520
                ? 3
                : 1;
        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.2,
          children: page.stats
              .map((stat) => _StatCard(
                    stat: stat,
                    accent: page.accent,
                  ))
              .toList(),
        );
      },
    );
  }
}

class _ActionGrid extends StatelessWidget {
  final _ModePage page;

  const _ActionGrid({required this.page});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 800
            ? 3
            : width >= 520
                ? 2
                : 1;
        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.55,
          children: page.actions
              .map((action) => _ActionCard(
                    action: action,
                    accent: page.accent,
                  ))
              .toList(),
        );
      },
    );
  }
}

class _SidePanel extends StatelessWidget {
  final _ModePage page;
  final List<PortalTask> tasks;
  final int openTasks;
  final int completedTasks;

  const _SidePanel({
    required this.page,
    required this.tasks,
    required this.openTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF0E1A2E),
        border: Border.all(color: Colors.white.withAlpha(14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Snapshot',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'A quick read on the selected workspace.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withAlpha(160),
                ),
          ),
          const SizedBox(height: 16),
          _SnapshotRow(label: 'Mode', value: page.title),
          _SnapshotRow(
            label: 'Tasks',
            value: tasks.isEmpty ? 'None yet' : '$openTasks open',
          ),
          _SnapshotRow(
            label: 'Done',
            value: '$completedTasks completed',
          ),
          _SnapshotRow(
            label: 'Focus',
            value: page.actions.first.title,
          ),
        ],
      ),
    );
  }
}

class _SnapshotRow extends StatelessWidget {
  final String label;
  final String value;

  const _SnapshotRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 78,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white.withAlpha(160),
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final _ModePage page;

  const _ProgressCard({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF0E1A2E),
        border: Border.all(color: Colors.white.withAlpha(14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 14),
          ...page.progress.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ProgressItem(
                item: item,
                accent: page.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final _Progress item;
  final Color accent;

  const _ProgressItem({required this.item, required this.accent});

  @override
  Widget build(BuildContext context) {
    final percentage = (item.value * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white.withAlpha(170),
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: item.value,
            minHeight: 8,
            backgroundColor: Colors.white.withAlpha(16),
            valueColor: AlwaysStoppedAnimation<Color>(accent),
          ),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final _ModePage page;

  const _ActivityCard({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF0E1A2E),
        border: Border.all(color: Colors.white.withAlpha(14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 14),
          ...page.activity.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ActivityItem(entry: entry),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final _Activity entry;

  const _ActivityItem({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF5EEAD4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  Text(
                    entry.time,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withAlpha(140),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                entry.detail,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withAlpha(170),
                      height: 1.35,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RolePill extends StatelessWidget {
  final String title;
  final Color accent;

  const _RolePill({required this.title, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: accent.withAlpha(36),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withAlpha(76)),
      ),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final String label;
  final String value;

  const _MetaPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withAlpha(160),
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final _Stat stat;
  final Color accent;

  const _StatCard({required this.stat, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accent.withAlpha(120),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              stat.value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              stat.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(170),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final _Action action;
  final Color accent;

  const _ActionCard({required this.action, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.auto_awesome_rounded, color: accent),
            const SizedBox(height: 12),
            Text(
              action.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              action.detail,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withAlpha(170),
                    height: 1.35,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PortalTaskRow extends StatelessWidget {
  final PortalTask task;
  final Color accent;
  final UserRole role;
  final bool canSubmitTask;
  final VoidCallback onToggle;
  final VoidCallback? onSubmit;

  const _PortalTaskRow({
    required this.task,
    required this.accent,
    required this.role,
    required this.canSubmitTask,
    required this.onToggle,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 560;
            final actionButton = role == UserRole.student && canSubmitTask
                ? FilledButton.tonalIcon(
                    onPressed: onSubmit,
                    icon: Icon(task.completed
                        ? Icons.refresh_rounded
                        : Icons.upload_file_rounded),
                    label: Text(task.completed ? 'Resubmit' : 'Attach file'),
                  )
                : TextButton(
                    onPressed: onToggle,
                    child: Text(task.completed ? 'Reopen' : 'Complete'),
                  );

            final details = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${task.dueLabel} • ${task.statusLabel}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withAlpha(160),
                      ),
                ),
                if (task.attachmentName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Attachment: ${task.attachmentName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withAlpha(140),
                        ),
                  ),
                ],
              ],
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              task.completed ? accent.withAlpha(140) : accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: details),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: actionButton,
                  ),
                ],
              );
            }

            return Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.completed ? accent.withAlpha(140) : accent,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(child: details),
                actionButton,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TaskComposer extends StatefulWidget {
  final void Function(String title, String detail, String dueLabel) onCreate;

  const _TaskComposer({required this.onCreate});

  @override
  State<_TaskComposer> createState() => _TaskComposerState();
}

class _TaskComposerState extends State<_TaskComposer> {
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  final _dueController = TextEditingController(text: 'Due soon');

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    _dueController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final detail = _detailController.text.trim();
    final dueLabel = _dueController.text.trim();
    if (title.isEmpty || detail.isEmpty || dueLabel.isEmpty) {
      return;
    }

    widget.onCreate(title, detail, dueLabel);
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + inset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Create task',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'This task will be assigned to students automatically.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(180),
                    height: 1.45,
                  ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Task title',
                hintText: 'e.g. Submit chapter 2 screenshots',
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _detailController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Details',
                hintText: 'Explain what the student should do and submit.',
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _dueController,
              decoration: const InputDecoration(
                labelText: 'Due label',
                hintText: 'e.g. Due Friday',
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.send_rounded),
                label: const Text('Assign to students'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmissionComposer extends StatefulWidget {
  final PortalTask task;
  final ValueChanged<String> onSubmit;

  const _SubmissionComposer({
    required this.task,
    required this.onSubmit,
  });

  @override
  State<_SubmissionComposer> createState() => _SubmissionComposerState();
}

class _SubmissionComposerState extends State<_SubmissionComposer> {
  PlatformFile? _selectedFile;
  bool _isPicking = false;

  Future<void> _pickFile() async {
    setState(() => _isPicking = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
        type: FileType.any,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedFile = result?.files.single;
      });
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  void _submit() {
    final file = _selectedFile;
    if (file == null) {
      return;
    }
    widget.onSubmit(file.name);
  }

  String _sizeLabel(int? bytes) {
    if (bytes == null || bytes <= 0) {
      return 'Unknown size';
    }
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;
    final file = _selectedFile;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + inset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Submit work',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              widget.task.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.task.dueLabel} • ${widget.task.detail}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(180),
                    height: 1.45,
                  ),
            ),
            const SizedBox(height: 18),
            InkWell(
              onTap: _isPicking ? null : _pickFile,
              borderRadius: BorderRadius.circular(22),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: const Color(0xFF0E1A2E),
                  border: Border.all(color: Colors.white.withAlpha(14)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF14B8A6).withAlpha(28),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        file == null
                            ? Icons.upload_file_rounded
                            : Icons.description_rounded,
                        color: const Color(0xFF5EEAD4),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file?.name ?? 'Choose a file to attach',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            file == null
                                ? 'PDF, image, screenshot, or document'
                                : _sizeLabel(file.size),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withAlpha(160),
                                    ),
                          ),
                        ],
                      ),
                    ),
                    if (_isPicking)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white.withAlpha(120),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: file == null ? null : _submit,
                icon: const Icon(Icons.check_circle_rounded),
                label: Text(
                  widget.task.completed ? 'Update submission' : 'Submit task',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterCallout extends StatelessWidget {
  final String title;
  final String body;
  final Color accent;

  const _FooterCallout({
    required this.title,
    required this.body,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            accent.withAlpha(40),
            const Color(0xFF0F172A),
          ],
        ),
        border: Border.all(color: Colors.white.withAlpha(14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(180),
                  height: 1.45,
                ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withAlpha(160),
              ),
        ),
      ],
    );
  }
}

class _HealthChip extends StatelessWidget {
  const _HealthChip();

  @override
  Widget build(BuildContext context) {
    return Chip(
      side: BorderSide(color: Colors.white.withAlpha(14)),
      backgroundColor: const Color(0xFF0E1A2E),
      label: Text(
        'System healthy',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
      avatar: Icon(
        Icons.verified_rounded,
        size: 18,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF050B15),
                  Color(0xFF081223),
                  Color(0xFF0B1021)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: -30,
            right: -30,
            child:
                _Orb(color: const Color(0xFF14B8A6).withAlpha(28), size: 220),
          ),
          Positioned(
            top: 120,
            left: -60,
            child:
                _Orb(color: const Color(0xFFF59E0B).withAlpha(20), size: 180),
          ),
          Positioned(
            bottom: -40,
            right: 30,
            child:
                _Orb(color: const Color(0xFF60A5FA).withAlpha(20), size: 200),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final Color color;
  final double size;

  const _Orb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}

String _weekday(int value) {
  switch (value) {
    case DateTime.monday:
      return 'Monday';
    case DateTime.tuesday:
      return 'Tuesday';
    case DateTime.wednesday:
      return 'Wednesday';
    case DateTime.thursday:
      return 'Thursday';
    case DateTime.friday:
      return 'Friday';
    case DateTime.saturday:
      return 'Saturday';
    case DateTime.sunday:
      return 'Sunday';
    default:
      return 'Today';
  }
}

String _month(int value) {
  switch (value) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return 'Month';
  }
}
