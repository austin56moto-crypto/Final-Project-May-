class AuthSession {
  final String email;
  final String role;
  final String displayName;

  const AuthSession({
    required this.email,
    required this.role,
    required this.displayName,
  });
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  const AuthService();

  static const _accounts =
      <String, ({String password, String role, String displayName})>{
    'admin@interntask.edu': (
      password: 'Admin123!',
      role: 'Admin',
      displayName: 'Administrator',
    ),
    'instructor@interntask.edu': (
      password: 'Instructor123!',
      role: 'Instructor',
      displayName: 'Instructor',
    ),
    'student@interntask.edu': (
      password: 'Student123!',
      role: 'Student',
      displayName: 'Student',
    ),
  };

  Future<AuthSession> signIn({
    required String email,
    required String password,
    required String role,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final account = _accounts[normalizedEmail];

    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (account == null) {
      throw const AuthException('No portal account matches that email.');
    }
    if (account.role != role) {
      throw const AuthException('That email is not assigned to this role.');
    }
    if (account.password != password) {
      throw const AuthException('The password is incorrect.');
    }

    return AuthSession(
      email: normalizedEmail,
      role: account.role,
      displayName: account.displayName,
    );
  }
}
