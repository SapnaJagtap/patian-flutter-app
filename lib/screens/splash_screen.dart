import 'dart:math';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _progressController;
  late AnimationController _floatController;
  late AnimationController _dotController;

  late Animation<double> _ring1Scale;
  late Animation<double> _ring1Opacity;
  late Animation<double> _ring2Scale;
  late Animation<double> _ring2Opacity;
  late Animation<double> _fadeUp;
  late Animation<double> _progress;
  late Animation<double> _float;

  // Loading messages to cycle through
  final List<String> _loadingMessages = [
    'Initializing secure connection',
    'Loading health records',
    'Almost ready...',
  ];
  int _msgIndex = 0;

  @override
  void initState() {
    super.initState();

    // Pulse rings
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _ring1Scale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _ring1Opacity = Tween<double>(begin: 0.6, end: 0.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _ring2Scale = Tween<double>(begin: 0.85, end: 1.12).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );
    _ring2Opacity = Tween<double>(begin: 0.3, end: 0.08).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Fade + slide up for content
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _fadeUp = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    // Progress bar
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..forward();

    _progress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Dot pulse
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    // Cycle loading messages
    Future.delayed(const Duration(milliseconds: 1000), _cycleMessages);

    // Navigate after loading
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // TODO: Replace with your actual navigation
        // Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  void _cycleMessages() {
    if (!mounted) return;
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _msgIndex = (_msgIndex + 1) % _loadingMessages.length;
        });
        _cycleMessages();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _progressController.dispose();
    _floatController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF0FAF5),
              Color(0xFFE8F4FB),
              Color(0xFFEEF7F0),
              Color(0xFFF5F0FB),
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background blobs
            _buildBgBlob(
              top: -60,
              right: -60,
              size: 220,
              color: const Color(0x1F1D9E75),
            ),
            _buildBgBlob(
              bottom: 80,
              left: -80,
              size: 260,
              color: const Color(0x1A185FA5),
            ),
            _buildBgBlob(
              top: 200,
              right: -40,
              size: 140,
              color: const Color(0x1A639922),
            ),

            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeUp,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(_fadeUp),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLogoWithRings(),
                      const SizedBox(height: 28),
                      _buildAppName(),
                      const SizedBox(height: 10),
                      _buildTagline(),
                      const SizedBox(height: 18),
                      _buildDividerDots(),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom loading area
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeUp,
                child: Column(
                  children: [
                    _buildProgressBar(),
                    const SizedBox(height: 14),
                    _buildLoadingDots(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBgBlob({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }

  Widget _buildLogoWithRings() {
    return SizedBox(
      width: 190,
      height: 190,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              Transform.scale(
                scale: _ring2Scale.value,
                child: Opacity(
                  opacity: _ring2Opacity.value,
                  child: Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1D9E75),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              // Mid ring
              Transform.scale(
                scale: _ring1Scale.value,
                child: Opacity(
                  opacity: _ring1Opacity.value,
                  child: Container(
                    width: 155,
                    height: 155,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1D9E75),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              // Inner circle with logo
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Color(0xFFFAFFFD), Color(0xFFE5F7F0)],
                    stops: [0.6, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1D9E75).withOpacity(0.18),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: const Color(0xFF185FA5).withOpacity(0.10),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(child: _buildLogoSvg()),
              ),
            ],
          );
        },
      ),
    );
  }

  // Replace this with: Image.asset('assets/images/logo.png', width: 72, height: 72)
  // if you have your actual logo asset
  // In _buildLogoSvg() — make image bigger
  Widget _buildLogoSvg() {
    return Image.asset(
      'assets/images/2.1.png',
      width: 250,
      height: 250,
      fit: BoxFit.contain,
    );
  }

  Widget _buildAppName() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF185FA5), Color(0xFF1D9E75)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: const Text(
        'AarogyKendra',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Colors.white, // masked by shader
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return Column(
      children: const [
        Text(
          'आरोग्यकेंद्र',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF1D9E75),
            letterSpacing: 1.0,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Your trusted health companion',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF888780),
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }

  Widget _buildDividerDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(const Color(0xFF1D9E75)),
        const SizedBox(width: 6),
        _dot(const Color(0xFF185FA5)),
        const SizedBox(width: 6),
        _dot(const Color(0xFF1D9E75)),
      ],
    );
  }

  Widget _dot(Color color) => Container(
    width: 4,
    height: 4,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color.withOpacity(0.5),
    ),
  );

  Widget _buildProgressBar() {
    return Center(
      child: SizedBox(
        width: 180,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: AnimatedBuilder(
            animation: _progress,
            builder: (context, _) {
              return Stack(
                children: [
                  Container(
                    height: 3,
                    color: const Color(0xFF1D9E75).withOpacity(0.15),
                  ),
                  FractionallySizedBox(
                    widthFactor: _progress.value,
                    child: Container(
                      height: 3,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF185FA5), Color(0xFF1D9E75)],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(3, (i) {
            return AnimatedBuilder(
              animation: _dotController,
              builder: (context, _) {
                final offset = (i * 0.2);
                final t = (_dotController.value - offset).clamp(0.0, 1.0);
                final scale = sin(t * pi);
                final opacity = 0.2 + 0.8 * scale;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Transform.scale(
                    scale: 0.8 + 0.2 * scale,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1D9E75),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
        const SizedBox(width: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Text(
            _loadingMessages[_msgIndex],
            key: ValueKey(_msgIndex),
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF888780),
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}

// Custom painter for the logo (replace with Image.asset if you have the asset)
class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bluePaint = Paint()
      ..color = const Color(0xFF185FA5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final greenPaint = Paint()
      ..color = const Color(0xFF1D9E75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final darkGreenFill = Paint()
      ..color = const Color(0xFF0F6E56)
      ..style = PaintingStyle.fill;

    final blueFill = Paint()
      ..color = const Color(0xFF185FA5)
      ..style = PaintingStyle.fill;

    final leafFill = Paint()
      ..color = const Color(0xFF3B6D11)
      ..style = PaintingStyle.fill;

    // Arc top (heartbeat circle)
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.42),
        width: w * 0.54,
        height: h * 0.54,
      ),
      -pi,
      pi,
      false,
      bluePaint,
    );

    // Heartbeat line
    final hbPath = Path()
      ..moveTo(w * 0.29, h * 0.42)
      ..lineTo(w * 0.36, h * 0.42)
      ..lineTo(w * 0.41, h * 0.33)
      ..lineTo(w * 0.45, h * 0.50)
      ..lineTo(w * 0.49, h * 0.38)
      ..lineTo(w * 0.53, h * 0.46)
      ..lineTo(w * 0.57, h * 0.42)
      ..lineTo(w * 0.71, h * 0.42);
    canvas.drawPath(hbPath, bluePaint..style = PaintingStyle.stroke);

    // Medical cross
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.22),
          width: w * 0.16,
          height: h * 0.16,
        ),
        const Radius.circular(3),
      ),
      blueFill,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.22),
        width: w * 0.22,
        height: h * 0.04,
      ),
      blueFill,
    );

    // Family - center child
    canvas.drawCircle(Offset(w * 0.50, h * 0.56), w * 0.055, blueFill);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.50, h * 0.65),
          width: w * 0.09,
          height: h * 0.1,
        ),
        const Radius.circular(5),
      ),
      blueFill,
    );

    // Family - right adult
    canvas.drawCircle(Offset(w * 0.63, h * 0.54), w * 0.06, darkGreenFill);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.63, h * 0.64),
          width: w * 0.1,
          height: h * 0.12,
        ),
        const Radius.circular(6),
      ),
      darkGreenFill,
    );

    // Small heart on child
    final heartPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;
    final heartPath = Path()
      ..moveTo(w * 0.50, h * 0.64)
      ..cubicTo(w * 0.50, h * 0.61, w * 0.46, h * 0.60, w * 0.46, h * 0.62)
      ..cubicTo(w * 0.46, h * 0.65, w * 0.50, h * 0.67, w * 0.50, h * 0.67)
      ..cubicTo(w * 0.50, h * 0.67, w * 0.54, h * 0.65, w * 0.54, h * 0.62)
      ..cubicTo(w * 0.54, h * 0.60, w * 0.50, h * 0.61, w * 0.50, h * 0.64);
    canvas.drawPath(heartPath, heartPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
