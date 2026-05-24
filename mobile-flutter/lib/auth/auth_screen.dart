import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/portal_theme.dart';

class AuthScreen extends StatefulWidget {
  final Future<AuthSession> Function({
    required String email,
    required String password,
    required String role,
  }) onSignIn;

  const AuthScreen({super.key, required this.onSignIn});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController(text: 'admin@interntask.edu');
  final _passwordController = TextEditingController(text: 'Admin123!');
  final _formKey = GlobalKey<FormState>();
  String _role = 'Admin';
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await widget.onSignIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: _role,
      );
    } on AuthException catch (error) {
      setState(() => _error = error.message);
    } catch (_) {
      setState(() => _error = 'Sign in failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          const PortalBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 900;
                      final left = _IntroPanel(textTheme: textTheme);
                      final right = _SignInCard(
                        textTheme: textTheme,
                        formKey: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        currentRole: _role,
                        error: _error,
                        isLoading: _isLoading,
                        onRoleChanged: (role) => setState(() {
                          _role = role;
                          _emailController.text = switch (role) {
                            'Admin' => 'admin@interntask.edu',
                            'Instructor' => 'instructor@interntask.edu',
                            _ => 'student@interntask.edu',
                          };
                          _passwordController.text = switch (role) {
                            'Admin' => 'Admin123!',
                            'Instructor' => 'Instructor123!',
                            _ => 'Student123!',
                          };
                        }),
                        onSubmit: _submit,
                      );

                      if (!wide) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            left,
                            const SizedBox(height: 16),
                            right,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(flex: 6, child: left),
                          const SizedBox(width: 18),
                          Expanded(flex: 5, child: right),
                        ],
                      );
                    },
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

class _IntroPanel extends StatelessWidget {
  final TextTheme textTheme;

  const _IntroPanel({required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            PortalTokens.backgroundElevated,
            PortalTokens.backgroundBase,
            PortalTokens.backgroundDeep,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: PortalTokens.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: PortalTokens.accent.withAlpha(28),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'InternTask AI Cloud',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Sign in to your portal',
            style: textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'A clean school-style login for admins, instructors, and students. Pick your role, enter your portal credentials, and land in the right workspace.',
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.white.withAlpha(190),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          const _DemoCredentials(),
          Text(
            'Designed for a polished classroom demo with a real portal feel.',
            style: textTheme.labelMedium?.copyWith(
              color: Colors.white.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoCredentials extends StatelessWidget {
  const _DemoCredentials();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: PortalTokens.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: PortalTokens.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Demo logins',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          const _CredentialLine(
            role: 'Admin',
            email: 'admin@interntask.edu',
            password: 'Admin123!',
          ),
          const SizedBox(height: 8),
          const _CredentialLine(
            role: 'Instructor',
            email: 'instructor@interntask.edu',
            password: 'Instructor123!',
          ),
          const SizedBox(height: 8),
          const _CredentialLine(
            role: 'Student',
            email: 'student@interntask.edu',
            password: 'Student123!',
          ),
        ],
      ),
    );
  }
}

class _CredentialLine extends StatelessWidget {
  final String role;
  final String email;
  final String password;

  const _CredentialLine({
    required this.role,
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$role: $email / $password',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withAlpha(180),
            height: 1.45,
          ),
    );
  }
}

class _SignInCard extends StatelessWidget {
  final TextTheme textTheme;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String currentRole;
  final bool isLoading;
  final String? error;
  final ValueChanged<String> onRoleChanged;
  final VoidCallback onSubmit;

  const _SignInCard({
    required this.textTheme,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.currentRole,
    required this.isLoading,
    required this.error,
    required this.onRoleChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: PortalTokens.backgroundElevated,
        border: Border.all(color: Colors.white.withAlpha(16)),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign in',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Use the portal account that matches your role.',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white.withAlpha(180),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Role',
              style:
                  textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ['Admin', 'Instructor', 'Student']
                  .map(
                    (role) => ChoiceChip(
                      label: Text(role),
                      selected: currentRole == role,
                      onSelected: (_) => onRoleChanged(role),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'name@interntask.edu',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter your email';
                }
                if (!value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your password';
                }
                return null;
              },
            ),
            if (error != null) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF7F1D1D).withAlpha(120),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: const Color(0xFFFCA5A5).withAlpha(80)),
                ),
                child: Text(
                  error!,
                  style: textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFFECACA),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isLoading ? null : onSubmit,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.login_rounded),
                label: Text(isLoading ? 'Signing in...' : 'Enter portal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
