import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Email/Password
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Phone/OTP
  final _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  bool _otpSent = false;
  int _resendSeconds = 30;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    for (final c in _otpControllers) c.dispose();
    for (final f in _otpFocusNodes) f.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendSeconds = 30;
      _otpSent = true;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds == 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            _blob(
              top: -60,
              right: -60,
              size: 220,
              color: const Color(0x1F1D9E75),
            ),
            _blob(
              bottom: 60,
              left: -80,
              size: 260,
              color: const Color(0x1A185FA5),
            ),
            _blob(
              top: 180,
              right: -40,
              size: 140,
              color: const Color(0x1A639922),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildLogoHeader(),
                    const SizedBox(height: 28),
                    _buildCard(),
                    const SizedBox(height: 20),
                    _buildFooterNote(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blob({
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

  Widget _buildLogoHeader() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1D9E75).withOpacity(0.18),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          // Replace with your actual logo:
          // child: ClipOval(child: Padding(padding: EdgeInsets.all(10), child: Image.asset('assets/images/2.1.png', fit: BoxFit.contain))),
          child: ClipOval(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Image.asset('assets/images/2.1.png', fit: BoxFit.contain),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF185FA5), Color(0xFF1D9E75)],
          ).createShader(bounds),
          child: const Text(
            'AarogyKendra',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Your trusted health companion',
          style: TextStyle(fontSize: 12, color: Color(0xFF888780)),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D9E75).withOpacity(0.08),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back 👋',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Sign in to continue',
            style: TextStyle(fontSize: 13, color: Color(0xFF888780)),
          ),
          const SizedBox(height: 20),

          // Tab switcher
          _buildTabSwitcher(),
          const SizedBox(height: 20),

          // Tab content
          SizedBox(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [_buildEmailPanel(), _buildPhonePanel()],
            ),
          ),

          const SizedBox(height: 18),
          _buildDivider('New to AarogyKendra?'),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account? ",
                style: TextStyle(fontSize: 13, color: Color(0xFF555555)),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to register
                },
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF185FA5),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF185FA5).withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: const Color(0xFF185FA5),
        unselectedLabelColor: const Color(0xFF888780),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Email'),
          Tab(text: 'Phone / OTP'),
        ],
      ),
    );
  }

  Widget _buildEmailPanel() {
    return Column(
      children: [
        _inputField(
          controller: _emailController,
          hint: 'Email address',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _inputField(
          controller: _passwordController,
          hint: 'Password',
          icon: Icons.lock_outline,
          obscure: _obscurePassword,
          suffix: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF888780),
              size: 20,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              // TODO: Forgot password
            },
            child: const Text(
              'Forgot password?',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF185FA5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _gradientButton(
          label: 'Sign In',
          onTap: () {
            // TODO: Handle email login
          },
        ),
      ],
    );
  }

  Widget _buildPhonePanel() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 72,
              child: _inputField(
                controller: TextEditingController(text: '+91'),
                hint: '',
                icon: null,
                textAlign: TextAlign.center,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 13,
                  horizontal: 8,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _inputField(
                controller: _phoneController,
                hint: 'Mobile number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _gradientButton(label: 'Send OTP', onTap: _startResendTimer),
        if (_otpSent) ...[
          const SizedBox(height: 18),
          _buildDivider('Enter OTP'),
          const SizedBox(height: 14),
          _buildOtpFields(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Resend OTP in ',
                style: TextStyle(fontSize: 12, color: Color(0xFF888780)),
              ),
              Text(
                '0:${_resendSeconds.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF1D9E75),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _gradientButton(
            label: 'Verify & Sign In',
            onTap: () {
              // TODO: Handle OTP verification
            },
          ),
        ],
      ],
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (i) {
        return Container(
          width: 42,
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: TextField(
            controller: _otpControllers[i],
            focusNode: _otpFocusNodes[i],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF185FA5),
            ),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: const Color(0xFF1D9E75).withOpacity(0.25),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF1D9E75),
                  width: 1.5,
                ),
              ),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (val) {
              if (val.isNotEmpty && i < 5) {
                _otpFocusNodes[i + 1].requestFocus();
              } else if (val.isEmpty && i > 0) {
                _otpFocusNodes[i - 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
    TextAlign textAlign = TextAlign.start,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textAlign: textAlign,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
        prefixIcon: icon != null
            ? Icon(icon, color: const Color(0xFF888780), size: 20)
            : null,
        suffixIcon: suffix,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
        filled: true,
        fillColor: Colors.white.withOpacity(0.75),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFF1D9E75).withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1D9E75), width: 1.5),
        ),
      ),
    );
  }

  Widget _gradientButton({required String label, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF185FA5), Color(0xFF1D9E75)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1D9E75).withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(String label) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.black.withOpacity(0.08))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
          ),
        ),
        Expanded(child: Divider(color: Colors.black.withOpacity(0.08))),
      ],
    );
  }

  Widget _buildFooterNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFFAAAAAA),
            height: 1.6,
          ),
          children: [
            const TextSpan(text: 'By continuing you agree to our '),
            TextSpan(
              text: 'Terms of Service',
              style: const TextStyle(color: Color(0xFF1D9E75)),
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: const TextStyle(color: Color(0xFF1D9E75)),
            ),
          ],
        ),
      ),
    );
  }
}
