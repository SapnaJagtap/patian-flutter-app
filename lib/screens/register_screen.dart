import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  int _currentStep = 1;
  String _selectedRole = 'patient'; // 'patient' or 'doctor'

  // Step 2 controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _medRegController = TextEditingController();

  // Step 3 controllers
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;

  // Password strength (0-4)
  int _passwordStrength = 0;
  String _strengthLabel = '';
  Color _strengthColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _medRegController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength() {
    final p = _passwordController.text;
    int strength = 0;
    if (p.length >= 6) strength++;
    if (p.length >= 10) strength++;
    if (p.contains(RegExp(r'[0-9]'))) strength++;
    if (p.contains(RegExp(r'[!@#\$%^&*]'))) strength++;

    String label = '';
    Color color = Colors.transparent;
    if (strength <= 1) {
      label = 'Weak';
      color = Colors.redAccent;
    } else if (strength == 2) {
      label = 'Medium — add numbers to strengthen';
      color = const Color(0xFFF59E0B);
    } else if (strength == 3) {
      label = 'Strong';
      color = const Color(0xFF1D9E75);
    } else {
      label = 'Very Strong';
      color = const Color(0xFF185FA5);
    }

    setState(() {
      _passwordStrength = strength;
      _strengthLabel = label;
      _strengthColor = color;
    });
  }

  void _nextStep() {
    if (_currentStep < 3) setState(() => _currentStep++);
  }

  void _prevStep() {
    if (_currentStep > 1) setState(() => _currentStep--);
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
                    const SizedBox(height: 36),
                    _buildHeader(),
                    const SizedBox(height: 14),
                    _buildStepIndicator(),
                    const SizedBox(height: 14),
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

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
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
          // Replace with your logo:
          // child: ClipOval(child: Padding(padding: EdgeInsets.all(10), child: Image.asset('assets/images/2.1.png', fit: BoxFit.contain))),
          child: ClipOval(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Image.asset('assets/images/2.1.png', fit: BoxFit.contain),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF185FA5), Color(0xFF1D9E75)],
          ).createShader(bounds),
          child: const Text(
            'AarogyKendra',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Create your account',
          style: TextStyle(fontSize: 12, color: Color(0xFF888780)),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final isActive = i < _currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: i + 1 == _currentStep ? 20 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFF185FA5), Color(0xFF1D9E75)],
                  )
                : null,
            color: isActive ? null : const Color(0xFF1D9E75).withOpacity(0.2),
          ),
        );
      }),
    );
  }

  Widget _buildCard() {
    final stepTitles = ['Who are you?', 'Personal Info', 'Set Password'];
    final stepSubs = [
      'Select your role to get started',
      'Fill in your details below',
      'Secure your account',
    ];

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
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step $_currentStep of 3 — ${stepTitles[_currentStep - 1]}',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stepSubs[_currentStep - 1],
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF888780)),
          ),
          const SizedBox(height: 20),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: KeyedSubtree(
              key: ValueKey(_currentStep),
              child: _currentStep == 1
                  ? _buildStep1()
                  : _currentStep == 2
                  ? _buildStep2()
                  : _buildStep3(),
            ),
          ),

          const SizedBox(height: 18),
          _buildDivider('Already have an account?'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Have an account? ',
                style: TextStyle(fontSize: 13, color: Color(0xFF555555)),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Sign In',
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

  // ── STEP 1: Role Selector ──────────────────────────────────────────────────
  Widget _buildStep1() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _roleCard(
                role: 'patient',
                emoji: '🧑‍⚕️',
                label: 'Patient',
                sub: 'General User',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _roleCard(
                role: 'doctor',
                emoji: '👨‍⚕️',
                label: 'Doctor',
                sub: 'Healthcare Provider',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _gradientButton(label: 'Continue →', onTap: _nextStep),
      ],
    );
  }

  Widget _roleCard({
    required String role,
    required String emoji,
    required String label,
    required String sub,
  }) {
    final isActive = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? const Color(0xFF1D9E75)
                : const Color(0xFF1D9E75).withOpacity(0.2),
            width: isActive ? 1.5 : 1.5,
          ),
          gradient: isActive
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0x14185FA5), Color(0x1E1D9E75)],
                )
              : null,
          color: isActive ? null : Colors.white.withOpacity(0.7),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF1D9E75).withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isActive
                    ? const Color(0xFF185FA5)
                    : const Color(0xFF555555),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sub,
              style: const TextStyle(fontSize: 10.5, color: Color(0xFF888780)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── STEP 2: Personal Info ──────────────────────────────────────────────────
  Widget _buildStep2() {
    return Column(
      children: [
        _inputField(
          controller: _nameController,
          hint: 'Full name',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 12),
        _inputField(
          controller: _emailController,
          hint: 'Email address',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            SizedBox(
              width: 64,
              child: _inputField(
                controller: TextEditingController(text: '+91'),
                hint: '',
                icon: null,
                textAlign: TextAlign.center,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 6,
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
        if (_selectedRole == 'doctor') ...[
          const SizedBox(height: 12),
          _inputField(
            controller: _medRegController,
            hint: 'Medical registration number',
            icon: Icons.badge_outlined,
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: _outlineButton(label: '← Back', onTap: _prevStep),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 6,
              child: _gradientButton(label: 'Continue →', onTap: _nextStep),
            ),
          ],
        ),
      ],
    );
  }

  // ── STEP 3: Password ───────────────────────────────────────────────────────
  Widget _buildStep3() {
    return Column(
      children: [
        _inputField(
          controller: _passwordController,
          hint: 'Create password',
          icon: Icons.lock_outline,
          obscure: _obscurePassword,
          suffix: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF888780),
              size: 18,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: 12),
        _inputField(
          controller: _confirmPasswordController,
          hint: 'Confirm password',
          icon: Icons.lock_outline,
          obscure: _obscureConfirm,
          suffix: IconButton(
            icon: Icon(
              _obscureConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF888780),
              size: 18,
            ),
            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
        ),
        if (_passwordController.text.isNotEmpty) ...[
          const SizedBox(height: 10),
          _buildPasswordStrength(),
        ],
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _agreedToTerms,
                onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                activeColor: const Color(0xFF1D9E75),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: BorderSide(
                  color: const Color(0xFF1D9E75).withOpacity(0.4),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF888780),
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(color: Color(0xFF1D9E75)),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(color: Color(0xFF1D9E75)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: _outlineButton(label: '← Back', onTap: _prevStep),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 6,
              child: _gradientButton(
                label: 'Create Account',
                onTap: () {
                  // TODO: Handle registration
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordStrength() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password strength',
          style: TextStyle(fontSize: 11, color: Color(0xFF888780)),
        ),
        const SizedBox(height: 5),
        Row(
          children: List.generate(4, (i) {
            final filled = i < _passwordStrength;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 3,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: filled
                      ? _strengthColor
                      : Colors.black.withOpacity(0.1),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          _strengthLabel,
          style: TextStyle(fontSize: 10.5, color: _strengthColor),
        ),
      ],
    );
  }

  // ── Shared Widgets ─────────────────────────────────────────────────────────
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
      style: const TextStyle(fontSize: 13.5, color: Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13.5),
        prefixIcon: icon != null
            ? Icon(icon, color: const Color(0xFF888780), size: 18)
            : null,
        suffixIcon: suffix,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
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
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _outlineButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF555555),
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
            style: const TextStyle(fontSize: 11.5, color: Color(0xFFAAAAAA)),
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
        text: const TextSpan(
          style: TextStyle(fontSize: 11, color: Color(0xFFAAAAAA), height: 1.6),
          children: [
            TextSpan(text: 'By registering you agree to our '),
            TextSpan(
              text: 'Terms of Service',
              style: TextStyle(color: Color(0xFF1D9E75)),
            ),
            TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(color: Color(0xFF1D9E75)),
            ),
          ],
        ),
      ),
    );
  }
}
