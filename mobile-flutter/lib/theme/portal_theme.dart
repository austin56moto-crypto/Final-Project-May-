import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class PortalTokens {
  static const backgroundDeep = Color(0xFF020203);
  static const backgroundBase = Color(0xFF050506);
  static const backgroundElevated = Color(0xFF0A0A0C);
  static const surface = Color(0x0DFFFFFF);
  static const surfaceHover = Color(0x14FFFFFF);
  static const foreground = Color(0xFFEDEDEF);
  static const foregroundMuted = Color(0xFF8A8F98);
  static const foregroundSubtle = Color(0x99FFFFFF);
  static const accent = Color(0xFF5E6AD2);
  static const accentBright = Color(0xFF6872D9);
  static const accentGlow = Color(0x4D5E6AD2);
  static const borderDefault = Color(0x0FFFFFFF);
  static const borderHover = Color(0x19FFFFFF);
  static const borderAccent = Color(0x4D5E6AD2);
}

ThemeData buildPortalTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: PortalTokens.accent,
    brightness: Brightness.dark,
  ).copyWith(
    primary: PortalTokens.accent,
    onPrimary: PortalTokens.foreground,
    secondary: const Color(0xFF7C83FF),
    tertiary: const Color(0xFF8B5CF6),
    surface: PortalTokens.backgroundElevated,
    onSurface: PortalTokens.foreground,
  );

  final baseTextTheme = Typography.whiteMountainView.apply(
    bodyColor: PortalTokens.foreground,
    displayColor: PortalTokens.foreground,
  );

  return ThemeData(
    colorScheme: scheme,
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: PortalTokens.backgroundBase,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: PortalTokens.foreground,
      elevation: 0,
      centerTitle: false,
    ),
    iconTheme: const IconThemeData(color: PortalTokens.foreground),
    dividerTheme: const DividerThemeData(color: PortalTokens.borderDefault),
    chipTheme: ChipThemeData(
      backgroundColor: PortalTokens.surface,
      side: const BorderSide(color: PortalTokens.borderDefault),
      labelStyle: const TextStyle(
        color: PortalTokens.foreground,
        fontWeight: FontWeight.w700,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: PortalTokens.backgroundElevated,
      indicatorColor: PortalTokens.accent.withAlpha(45),
      labelTextStyle: const WidgetStatePropertyAll(
        TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    cardTheme: CardThemeData(
      color: PortalTokens.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: PortalTokens.borderDefault),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: PortalTokens.accent,
        foregroundColor: PortalTokens.foreground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        elevation: 0,
      ).copyWith(
        overlayColor: WidgetStatePropertyAll(
          PortalTokens.accentBright.withAlpha(30),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: PortalTokens.foreground,
        side: const BorderSide(color: PortalTokens.borderDefault),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: PortalTokens.foreground,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: PortalTokens.backgroundElevated,
      labelStyle: const TextStyle(color: PortalTokens.foregroundMuted),
      hintStyle: const TextStyle(color: PortalTokens.foregroundMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: PortalTokens.borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: PortalTokens.borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: PortalTokens.borderAccent, width: 1.2),
      ),
    ),
    textTheme: baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -1.4,
        height: 1.0,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        height: 1.05,
      ),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        color: PortalTokens.foreground,
        height: 1.55,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        color: PortalTokens.foreground,
        height: 1.45,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        color: PortalTokens.foregroundMuted,
        height: 1.35,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        color: PortalTokens.foreground,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        color: PortalTokens.foregroundMuted,
        letterSpacing: 0.2,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        color: PortalTokens.foregroundMuted,
      ),
    ),
  );
}

class PortalBackground extends StatefulWidget {
  const PortalBackground({super.key});

  @override
  State<PortalBackground> createState() => _PortalBackgroundState();
}

class _PortalBackgroundState extends State<PortalBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value * math.pi * 2;
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.3,
                    colors: [
                      Color(0xFF0A0A0F),
                      PortalTokens.backgroundBase,
                      PortalTokens.backgroundDeep,
                    ],
                    stops: [0.0, 0.52, 1.0],
                  ),
                ),
              ),
              const _GridOverlay(),
              Positioned(
                top: -120,
                left: -80 + math.sin(t) * 24,
                child: _GlowBlob(
                  size: 1100,
                  color: PortalTokens.accent.withAlpha(42),
                  blur: 170,
                ),
              ),
              Positioned(
                top: 180 + math.sin(t + 1.7) * 18,
                right: -220,
                child: _GlowBlob(
                  size: 820,
                  color: const Color(0xFF7C83FF).withAlpha(24),
                  blur: 140,
                ),
              ),
              Positioned(
                bottom: -260,
                left: 80 + math.sin(t + 0.8) * 18,
                child: _GlowBlob(
                  size: 900,
                  color: const Color(0xFF8B5CF6).withAlpha(18),
                  blur: 160,
                ),
              ),
              Positioned(
                bottom: -80,
                right: 140 + math.sin(t + 2.1) * 12,
                child: _GlowBlob(
                  size: 460,
                  color: PortalTokens.accent.withAlpha(22),
                  blur: 100,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final double size;
  final Color color;
  final double blur;

  const _GlowBlob({
    required this.size,
    required this.color,
    required this.blur,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class _GridOverlay extends StatelessWidget {
  const _GridOverlay();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _GridPainter(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(5)
      ..strokeWidth = 1;

    const step = 64.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}

class PortalEmptyStateScreen extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;

  const PortalEmptyStateScreen({
    super.key,
    required this.title,
    required this.body,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const PortalBackground(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: PortalTokens.backgroundElevated,
                      border: Border.all(color: PortalTokens.borderDefault),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(130),
                          blurRadius: 30,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: PortalTokens.accent.withAlpha(30),
                            border: Border.all(
                              color: PortalTokens.borderAccent,
                            ),
                          ),
                          child: Icon(icon, color: PortalTokens.foreground),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          body,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: PortalTokens.foregroundMuted,
                                  ),
                        ),
                      ],
                    ),
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
