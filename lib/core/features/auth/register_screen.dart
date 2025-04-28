import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:savvysplit/data/providers/auth_provider.dart';
import 'package:savvysplit/core/constants/colors.dart';
import 'package:savvysplit/core/widgets/loading_indicator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'User';
  bool isLoading = false;
  bool obscurePassword = true; // For password visibility toggle
  double _opacity = 0.0; // For fade-in animation
  bool _isEmailValid = false; // For real-time email validation feedback
  late AnimationController _animationController; // For scale animation
  late Animation<double> _scaleAnimation; // For scale animation

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
  }

  @override
  void dispose() {
    fullNameController.dispose();
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
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.gradientStart,
      body: Container(
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
                        label: 'Create Account Title',
                        child: Text(
                          'Create an Account',
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
                        label: 'Sign up to get started subtitle',
                        child: Text(
                          'Sign up to get started',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 60),
                      Semantics(
                        label: 'Full Name input field',
                        child: TextFormField(
                          controller: fullNameController,
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          cursorColor: AppColors.secondary,
                          cursorWidth: 2.0,
                          cursorHeight: 20.0,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.surface.withValues(alpha: 0.4),
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
                            labelText: 'Full Name',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppColors.secondary,
                              size: 20,
                            ),
                            suffixIcon:
                                fullNameController.text.isNotEmpty
                                    ? IconButton(
                                      icon: Icon(
                                        size: 16,
                                        Icons.clear,
                                        color: AppColors.textSecondary,
                                      ),
                                      onPressed: () {
                                        fullNameController.clear();
                                        setState(() {});
                                      },
                                    )
                                    : null,
                          ),
                          keyboardType: TextInputType.name,
                          style: TextStyle(color: AppColors.textPrimary),
                          onChanged: (value) {
                            setState(() {});
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        label: 'Email input field',
                        child: TextFormField(
                          controller: emailController,
                          autofocus: false, // Don't auto-focus on email field
                          textInputAction: TextInputAction.next,
                          cursorColor: AppColors.secondary,
                          cursorWidth: 2.0,
                          cursorHeight: 20.0,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.surface.withValues(alpha: 0.4),
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
                            labelText: 'Email',
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
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                  ),
                                if (emailController.text.isNotEmpty)
                                  IconButton(
                                    icon: Icon(
                                      size: 20,
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
                          textInputAction: TextInputAction.done,
                          cursorColor: AppColors.secondary,
                          cursorWidth: 2.0,
                          cursorHeight: 20.0,
                          controller: passwordController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.surface.withValues(alpha: 0.4),
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
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: AppColors.secondary,
                              size: 20,
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
                      const SizedBox(height: 16),
                      Semantics(
                        label: 'Role selection dropdown',
                        child: DropdownButtonFormField<String>(
                          value: selectedRole,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.surface.withValues(alpha: 0.4),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppColors.borderPrimary,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppColors.borderPrimary,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppColors.secondary,
                                width: 2.0,
                              ),
                            ),
                            labelText: 'Role',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppColors.secondary,
                              size: 20,
                            ),
                          ),
                          style: TextStyle(color: AppColors.textPrimary),
                          dropdownColor: AppColors.gradientEnd,
                          items:
                              ['User', 'Admin']
                                  .map(
                                    (role) => DropdownMenuItem<String>(
                                      value: role,
                                      child: Text(role),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      Semantics(
                        label: 'Create Account button',
                        child: SizedBox(
                          width: double.infinity,
                          child:
                              isLoading
                                  ? const Center(child: LoadingIndicator())
                                  : GestureDetector(
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
                                          shadowColor: AppColors.secondary
                                              .withValues(alpha: 0.5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            try {
                                              await authProvider.registerUser(
                                                fullNameController
                                                        .text
                                                        .isNotEmpty
                                                    ? fullNameController.text
                                                    : selectedRole, // Use fullName if provided, else selectedRole as name
                                                emailController.text,
                                                passwordController.text,
                                              );
                                              setState(() {
                                                isLoading = false;
                                              });

                                              // Navigate if there's no error (AuthProvider sets errorMessage if failed)
                                              if (authProvider.errorMessage ==
                                                  null) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    content: Row(
                                                      children: const [
                                                        Icon(
                                                          Icons.check_circle,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(width: 12),
                                                        Expanded(
                                                          child: Text(
                                                            'Registration successful! Please log in.',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    duration: Duration(
                                                      seconds: 3,
                                                    ),
                                                  ),
                                                );
                                                context.go('/login');
                                              } else {
                                                print('Registration failed');
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        AppColors.error,
                                                    content: Row(
                                                      children: const [
                                                        Icon(
                                                          Icons.error,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(width: 12),
                                                        Expanded(
                                                          child: Text(
                                                            'Registration failed. Please try again.',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    duration: Duration(
                                                      seconds: 3,
                                                    ),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    e.toString().replaceFirst(
                                                      'Exception: ',
                                                      '',
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      AppColors.error,
                                                ),
                                              );
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors
                                                    .buttonGradientEnd
                                                    .withOpacity(0.4),
                                                blurRadius: 12,
                                                spreadRadius: 1,
                                                offset: const Offset(0, 4),
                                              ),
                                              BoxShadow(
                                                color: AppColors
                                                    .buttonGradientStart
                                                    .withOpacity(0.3),
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
                                            child: const Center(
                                              child: Text(
                                                'CREATE ACCOUNT',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 1.5,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 4.0,
                                                      color: Color(
                                                        0x4D000000,
                                                      ), // Colors.black with 0.3 opacity
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
                        ),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        label: 'Login link',
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              context.go('/login');
                            },
                            child: Text(
                              'Already have an account? Sign In',
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
    );
  }
}
