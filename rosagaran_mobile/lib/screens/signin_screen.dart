import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/user_service.dart';
import '../widgets/custom_text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController(
    text: 'emilys',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: 'emilyspass',
  );

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() async {
    final UserService userService = UserService();
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      try {
        final response = await userService.loginUser(
          _usernameController.text,
          _passwordController.text,
        );

        await userService.saveUserData(response);

        if (!mounted) {
          return;
        }

        setState(() {
          _isLoading = false;
        });

        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: response,
        );
      } catch (e) {
        if (!mounted) {
          return;
        }

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFDF2F8),
              Color(0xFFEDE9FE),
              Color(0xFFE0F2FE),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -40.h,
                right: -20.w,
                child: _GlowBubble(
                  size: 170.w,
                  colors: const [
                    Color(0xFFFF8A65),
                    Color(0xFFFFC107),
                  ],
                ),
              ),
              Positioned(
                left: -30.w,
                bottom: 120.h,
                child: _GlowBubble(
                  size: 150.w,
                  colors: const [
                    Color(0xFF7C4DFF),
                    Color(0xFFEC407A),
                  ],
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.84),
                      borderRadius: BorderRadius.circular(34.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.72),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C4DFF).withOpacity(0.10),
                          blurRadius: 30,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Enhancement 2: custom sign-in UI with a more
                          // social-app visual style while keeping user_service
                          // authentication and persistent login behavior.
                          Row(
                            children: [
                              Container(
                                width: 54.w,
                                height: 54.w,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF7043),
                                      Color(0xFFEC407A),
                                      Color(0xFF7C4DFF),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(18.r),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/nubdexchange_logo.png',
                                    height: 28.h,
                                  ),
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: 'emilys.space',
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    SizedBox(height: 4.h),
                                    CustomText(
                                      text: 'Log back into your account',
                                      fontSize: 12.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 28.h),
                          CustomText(
                            text: 'Welcome back',
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 8.h),
                          CustomText(
                            text:
                                'Your shop, saved cart, and profile are waiting for you.',
                            fontSize: 14.sp,
                          ),
                          SizedBox(height: 24.h),
                          _InputLabel(text: 'Username'),
                          SizedBox(height: 8.h),
                          TextFormField(
                            controller: _usernameController,
                            style: TextStyle(fontSize: 15.sp),
                            decoration: _inputDecoration(
                              hintText: 'Enter username',
                              icon: Icons.alternate_email_rounded,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 18.h),
                          _InputLabel(text: 'Password'),
                          SizedBox(height: 8.h),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: TextStyle(fontSize: 15.sp),
                            decoration: _inputDecoration(
                              hintText: 'Enter password',
                              icon: Icons.lock_outline_rounded,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF6F0FF),
                                  borderRadius: BorderRadius.circular(999.r),
                                ),
                                child: CustomText(
                                  text: 'Saved session supported',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 26.h),
                          SizedBox(
                            width: double.infinity,
                            height: 56.h,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF7043),
                                    Color(0xFFEC407A),
                                    Color(0xFF7C4DFF),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFEC407A)
                                        .withOpacity(0.24),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                ),
                                onPressed: _isLoading ? null : login,
                                child: _isLoading
                                    ? SizedBox(
                                        width: 20.w,
                                        height: 20.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : CustomText(
                                        text: 'Continue as Emily',
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        textAlign: TextAlign.center,
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
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white.withOpacity(0.78),
      contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.r),
        borderSide: BorderSide(
          color: const Color(0xFFE8DDF9),
          width: 1.1.w,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.r),
        borderSide: BorderSide(
          color: const Color(0xFF7C4DFF),
          width: 1.4.w,
        ),
      ),
    );
  }
}

class _InputLabel extends StatelessWidget {
  const _InputLabel({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    );
  }
}

class _GlowBubble extends StatelessWidget {
  const _GlowBubble({
    required this.size,
    required this.colors,
  });

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
    );
  }
}
