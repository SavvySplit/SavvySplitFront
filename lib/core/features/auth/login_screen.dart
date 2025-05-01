import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/auth_provider.dart';
import '../../constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // Use AuthProvider's isLoading instead of local state
  // bool isLoading = false;
  bool rememberPassword = false;
  bool obscurePassword = true;
  double _opacity = 0.0;
  bool _isEmailValid = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Start the fade-in animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1.0;
      });
    });
    // Initialize scale animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');
    final remember = prefs.getBool('remember_me') ?? false;
    setState(() {
      rememberPassword = remember;
      if (remember && savedEmail != null && savedPassword != null) {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Real-time email validation
  void _validateEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      _isEmailValid = emailRegex.hasMatch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.gradientStart,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap:
            () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
              stops: const [0.0, 1.0],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 500),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Semantics(
                            label: 'Welcome Back Title',
                            child: Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Semantics(
                            label: 'Sign in to continue subtitle',
                            child: Text(
                              'Login to your account to manage your expenses and split bills with friends',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          Semantics(
                            label: 'Email input field',
                            child: TextFormField(
                              controller: emailController,
                              autofocus: true,
                              cursorColor: AppColors.secondary,
                              cursorWidth: 2.0,
                              cursorHeight: 20.0,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.surface.withValues(
                                  alpha: .4,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: AppColors.borderPrimary,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: AppColors.borderPrimary,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),

                                  // change the color of the blinking cursor
                                  borderSide: BorderSide(
                                    color: AppColors.secondary,
                                    width: 2.0,
                                  ),
                                ),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: AppColors.secondary,
                                  size: 20,
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (_isEmailValid)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 16,
                                        ),
                                      ),
                                    if (emailController.text.isNotEmpty)
                                      IconButton(
                                        icon: Icon(
                                          size: 16,
                                          Icons.clear,
                                          color: AppColors.textSecondary,
                                        ),
                                        onPressed: () {
                                          emailController.clear();
                                          _validateEmail('');
                                          setState(() {});
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: AppColors.textPrimary),
                              onChanged: (value) {
                                _validateEmail(value);
                                setState(() {});
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          Semantics(
                            label: 'Password input field',
                            child: TextFormField(
                              autofocus: false,
                              cursorColor: AppColors.secondary,
                              cursorWidth: 2.0,
                              cursorHeight: 20.0,
                              controller: passwordController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.surface.withValues(
                                  alpha: 0.4,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: AppColors.borderPrimary,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: AppColors.borderPrimary,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: AppColors.secondary,
                                    width: 2.0,
                                  ),
                                ),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: AppColors.secondary,
                                  size: 22,
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        size: 16,
                                        obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColors.textSecondary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          obscurePassword = !obscurePassword;
                                        });
                                      },
                                    ),
                                    if (passwordController.text.isNotEmpty)
                                      IconButton(
                                        icon: Icon(
                                          size: 16,
                                          Icons.clear,
                                          color: AppColors.textSecondary,
                                        ),
                                        onPressed: () {
                                          passwordController.clear();
                                          setState(() {});
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              obscureText: obscurePassword,
                              style: TextStyle(color: AppColors.textPrimary),
                              onChanged: (value) => setState(() {}),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Semantics(
                                label: 'Remember Password checkbox',
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: rememberPassword,

                                      onChanged: (value) async {
                                        setState(() {
                                          rememberPassword = value ?? false;
                                        });
                                        final prefs =
                                            await SharedPreferences.getInstance();
                                        if (rememberPassword) {
                                          await prefs.setBool(
                                            'remember_me',
                                            true,
                                          );
                                          await prefs.setString(
                                            'saved_email',
                                            emailController.text,
                                          );
                                          await prefs.setString(
                                            'saved_password',
                                            passwordController.text,
                                          );
                                        } else {
                                          await prefs.setBool(
                                            'remember_me',
                                            false,
                                          );
                                          await prefs.remove('saved_email');
                                          await prefs.remove('saved_password');
                                        }
                                      },
                                      activeColor:
                                          AppColors.accentGradientStart,
                                      checkColor: AppColors.success,
                                    ),
                                    Text(
                                      'Remember Me',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.go('/forgot-password');
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: AppColors.secondary, // Blue link
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTapDown: (_) {
                                _animationController.forward();
                              },
                              onTapUp: (_) {
                                _animationController.reverse();
                              },
                              onTapCancel: () {
                                _animationController.reverse();
                              },
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    elevation: 4,
                                    shadowColor: AppColors.secondary.withValues(
                                      alpha: .5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final authProvider =
                                        Provider.of<AuthProvider>(
                                          context,
                                          listen: false,
                                        );
                                    if (_formKey.currentState!.validate()) {
                                      await authProvider.loginUser(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );

                                      // Show feedback and redirect on success
                                      if (authProvider.errorMessage == null &&
                                          authProvider.userId != null) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Login successful!',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              margin: EdgeInsets.all(16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(6),
                                                ),
                                              ),
                                              backgroundColor: Colors.green,
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                          // Wait for the SnackBar to show before navigating
                                          await Future.delayed(
                                            const Duration(milliseconds: 1200),
                                          );
                                          context.go('/dashboard');
                                        }
                                      }
                                    }
                                  },
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.buttonGradientStart,
                                          AppColors.accentGradientMiddle
                                              .withOpacity(0.85),
                                          AppColors.buttonGradientEnd,
                                        ],
                                        stops: const [0.0, 0.55, 1.0],
                                      ),
                                      border: Border.all(
                                        color: AppColors.buttonGradientEnd
                                            .withOpacity(0.3),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.buttonGradientEnd
                                              .withValues(alpha: .4),
                                          blurRadius: 12,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 4),
                                        ),
                                        BoxShadow(
                                          color: AppColors.buttonGradientStart
                                              .withValues(alpha: .3),
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 0,
                                      ),
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'SIGN IN',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 4.0,
                                              color: Color(0x4D000000),
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Semantics(
                            label: 'Register link',
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  context.go('/register');
                                },
                                child: const Text(
                                  'Don\'t have an account? Sign Up',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
