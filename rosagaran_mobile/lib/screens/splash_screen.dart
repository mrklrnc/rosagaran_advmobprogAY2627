import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/user_service.dart';
import '../widgets/custom_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final UserService _userService = UserService();
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _checkAuthentication();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final loggedIn = await _userService.isLoggedIn();

    if (!mounted) {
      return;
    }

    if (loggedIn) {
      final userData = await _userService.getUserData();
      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: userData,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/signin');
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
              Color(0xFFFFF1F2),
              Color(0xFFF4E8FF),
              Color(0xFFE8F2FF),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -60.h,
              right: -20.w,
              child: _Orb(
                size: 180.w,
                colors: const [
                  Color(0xFFFF7043),
                  Color(0xFFEC407A),
                ],
              ),
            ),
            Positioned(
              bottom: -50.h,
              left: -10.w,
              child: _Orb(
                size: 160.w,
                colors: const [
                  Color(0xFF42A5F5),
                  Color(0xFF7C4DFF),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Enhancement 1: custom splash UI that performs persistent
                  // authentication before routing to sign-in or home.
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final scale = 1 + (_pulseController.value * 0.06);
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 124.w,
                      height: 124.w,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFF7043),
                            Color(0xFFEC407A),
                            Color(0xFF7C4DFF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(34.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEC407A).withOpacity(0.22),
                            blurRadius: 30,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        padding: EdgeInsets.all(18.r),
                        child: Image.asset(
                          'assets/images/nubdexchange_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  CustomText(
                    text: 'NUBD Exchange',
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: 'Loading your feed, cart, and profile space',
                    fontSize: 14.sp,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 26.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.78),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.2,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        CustomText(
                          text: 'Persistent sign-in check in progress',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({
    required this.size,
    required this.colors,
  });

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: colors),
        ),
      ),
    );
  }
}
