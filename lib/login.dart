import 'package:flutter/material.dart';
import 'package:maa_tara/colors.dart';
import 'package:maa_tara/main.dart';
import 'package:maa_tara/staff_list.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Login Page (Unified Admin & Staff Authentication)
// ─────────────────────────────────────────────────────────────────────────────
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // Login Role: 'admin' or 'staff'
  String _selectedRole = 'admin';

  final _identifierController = TextEditingController(text: 'admin@maara.com');
  final _passwordController = TextEditingController(text: 'admin123');

  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _switchRole(String role) {
    setState(() {
      _selectedRole = role;
      if (role == 'admin') {
        _identifierController.text = 'admin@maara.com';
        _passwordController.text = 'admin123';
      } else {
        _identifierController.text = 'vikram.singh@maara.com';
        _passwordController.text = 'staff123';
      }
    });
  }

  void _applyQuickDemo(String identifier, String password, String role) {
    setState(() {
      _selectedRole = role;
      _identifierController.text = identifier;
      _passwordController.text = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = _selectedRole == 'admin';

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),

                  // ── Brand Logo & Header ────────────────────────────────────
                  _buildBrandHeader(),
                  const SizedBox(height: 24),

                  // ── Dual Role Switcher (Admin vs Staff) ─────────────────────
                  _buildRoleSwitcher(isAdmin),
                  const SizedBox(height: 18),

                  // ── Quick Demo Login Chips ─────────────────────────────────
                  _buildQuickDemoChips(),
                  const SizedBox(height: 20),

                  // ── Login Card Form ────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAdmin
                              ? 'Admin Portal Access'
                              : 'Staff & Technician Login',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isAdmin ? 'Enter your administrator credentials' : 'Enter your registered email, phone or staff ID',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Username / Email / Phone Input
                        _buildInputField(
                          label: isAdmin
                              ? 'Admin Email / Username'
                              : 'Staff Email / Phone / ID',
                          hint: isAdmin
                              ? 'admin@maara.com'
                              : 'e.g. 9876549870 or STF-001',
                          icon: isAdmin
                              ? Icons.admin_panel_settings_outlined
                              : Icons.badge_outlined,
                          controller: _identifierController,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter your login identifier';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Password Input
                        _buildPasswordField(),
                        const SizedBox(height: 12),

                        // Remember Me & Forgot Password Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    activeColor: AppColors.accent,
                                    checkColor: Colors.black,
                                    side: const BorderSide(
                                      color: AppColors.muted,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (val) {
                                      setState(() => _rememberMe = val ?? true);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Remember me',
                                  style: TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () => _showForgotPasswordModal(),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        // Sign In Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        isAdmin
                                            ? 'Sign In as Admin'
                                            : 'Sign In as Staff',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Biometric & Fingerprint Login ──────────────────────────
                  Center(
                    child: InkWell(
                      onTap: () => _handleBiometricLogin(),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.fingerprint_rounded,
                              color: AppColors.accent,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Quick Biometric Login',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Security Footer ────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.lock_outline,
                        color: AppColors.muted,
                        size: 13,
                      ),
                      SizedBox(width: 6),
                      Text(
                        '256-Bit Encrypted Workshop Session • v2.4.0',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Brand Header Widget ─────────────────────────────────────────────────────
  Widget _buildBrandHeader() {
    return Column(
      children: [
        // Glowing brand logo container
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.card,
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.6),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.2),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.directions_car_filled_rounded,
              color: AppColors.accent,
              size: 38,
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Brand Name
        const Text(
          'MAARA AUTOMOBILES',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Workshop Management & Service ERP',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ── Role Switcher Tabs (Admin / Staff) ──────────────────────────────────────
  Widget _buildRoleSwitcher(bool isAdmin) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Row(
        children: [
          // Admin Tab
          Expanded(
            child: InkWell(
              onTap: () => _switchRole('admin'),
              borderRadius: BorderRadius.circular(9),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isAdmin ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 16,
                      color: isAdmin ? Colors.black : AppColors.muted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Admin Login',
                      style: TextStyle(
                        color: isAdmin ? Colors.black : AppColors.muted,
                        fontSize: 13,
                        fontWeight: isAdmin ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Staff Tab
          Expanded(
            child: InkWell(
              onTap: () => _switchRole('staff'),
              borderRadius: BorderRadius.circular(9),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: !isAdmin ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.engineering_outlined,
                      size: 16,
                      color: !isAdmin ? Colors.black : AppColors.muted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Staff Login',
                      style: TextStyle(
                        color: !isAdmin ? Colors.black : AppColors.muted,
                        fontSize: 13,
                        fontWeight: !isAdmin
                            ? FontWeight.w800
                            : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Demo Login Chips ──────────────────────────────────────────────────
  Widget _buildQuickDemoChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.bolt, color: AppColors.accent, size: 14),
            SizedBox(width: 4),
            Text(
              'Quick Demo Credentials (Tap to fill):',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _demoChip(
                label: '👑 Admin (Owner)',
                onTap: () =>
                    _applyQuickDemo('admin@maara.com', 'admin123', 'admin'),
                isSelected: _selectedRole == 'admin',
              ),
              const SizedBox(width: 8),
              _demoChip(
                label: '👨‍🔧 Vikram (Technician)',
                onTap: () => _applyQuickDemo(
                  'vikram.singh@maara.com',
                  'staff123',
                  'staff',
                ),
                isSelected:
                    _selectedRole == 'staff' &&
                    _identifierController.text.contains('vikram'),
              ),
              const SizedBox(width: 8),
              _demoChip(
                label: '🔧 Arjun (Mechanic)',
                onTap: () => _applyQuickDemo(
                  'arjun.mehta@maara.com',
                  'staff123',
                  'staff',
                ),
                isSelected:
                    _selectedRole == 'staff' &&
                    _identifierController.text.contains('arjun'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _demoChip({
    required String label,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.15)
              : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.divider,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.accent : AppColors.muted,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ── Input Field Helper ──────────────────────────────────────────────────────
  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          style: const TextStyle(color: AppColors.white, fontSize: 13),
          cursorColor: AppColors.accent,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.muted.withValues(alpha: 0.45),
              fontSize: 12,
            ),
            prefixIcon: Icon(icon, color: AppColors.accent, size: 18),
            filled: true,
            fillColor: AppColors.inputFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.divider, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.red, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  // ── Password Field Helper ───────────────────────────────────────────────────
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
          style: const TextStyle(color: AppColors.white, fontSize: 13),
          cursorColor: AppColors.accent,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: TextStyle(
              color: AppColors.muted.withValues(alpha: 0.45),
              fontSize: 12,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.accent,
              size: 18,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.muted,
                size: 18,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
            filled: true,
            fillColor: AppColors.inputFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.divider, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.red, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  // ── Login Handler ───────────────────────────────────────────────────────────
  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() => _isLoading = false);

    final identifier = _identifierController.text.trim();
    final isAdmin = _selectedRole == 'admin';

    // Find staff if in staff mode
    StaffModel? matchedStaff;
    if (!isAdmin) {
      matchedStaff = StaffRepository.staffList.firstWhere(
        (s) =>
            s.email.toLowerCase() == identifier.toLowerCase() ||
            s.phone == identifier ||
            s.id.toLowerCase() == identifier.toLowerCase() ||
            s.name.toLowerCase().contains(identifier.toLowerCase()),
        orElse: () => StaffRepository.staffList.first,
      );
    }

    final userName = isAdmin ? 'Admin' : (matchedStaff?.name ?? 'Vikram Singh');
    final userRole = isAdmin
        ? 'Administrator'
        : (matchedStaff?.role ?? 'Technician');

    _showLoginSuccessDialog(
      userName: userName,
      userRole: userRole,
      isAdmin: isAdmin,
    );
  }

  void _handleBiometricLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fingerprint verified! Logging in...'),
        backgroundColor: AppColors.card,
        duration: Duration(milliseconds: 1000),
      ),
    );
    Future.delayed(const Duration(milliseconds: 600), () {
      _handleLogin();
    });
  }

  // ── Success Dialog ──────────────────────────────────────────────────────────
  void _showLoginSuccessDialog({
    required String userName,
    required String userRole,
    required bool isAdmin,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.divider),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.green.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.green,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Welcome, $userName!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    userRole,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isAdmin
                      ? 'Full workshop control and management access granted.'
                      : 'Assigned jobs and today\'s schedule loaded successfully.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12.5,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to HomePage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Go to Dashboard',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Forgot Password Modal ───────────────────────────────────────────────────
  void _showForgotPasswordModal() {
    final emailPhoneController = TextEditingController(
      text: _identifierController.text,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 18,
            right: 18,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.muted.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Reset Password',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Enter your email or phone to receive OTP reset instructions.',
                style: TextStyle(color: AppColors.muted, fontSize: 12.5),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailPhoneController,
                style: const TextStyle(color: AppColors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Enter email or phone number',
                  hintStyle: TextStyle(
                    color: AppColors.muted.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                  prefixIcon: const Icon(
                    Icons.mail_outline,
                    color: AppColors.accent,
                    size: 18,
                  ),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('OTP sent to registered mobile/email!'),
                        backgroundColor: AppColors.card,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Send OTP Code',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
