import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/user.dart';
import '../services/user_service.dart';
import '../widgets/custom_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = UserService().getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF5F7),
            Color(0xFFF8F4FF),
            Color(0xFFFFFFFF),
          ],
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<User>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: CustomText(
                    text: 'Unable to load profile: ${snapshot.error}',
                    fontSize: 14.sp,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final user = snapshot.data!;
            final ImageProvider? profileImage = user.image.isEmpty
                ? null
                : user.image.startsWith('assets/')
                    ? AssetImage(user.image)
                    : NetworkImage(user.image);

            return ListView(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 24.h),
              children: [
                // Enhancement 3: render saved user data from user_service
                // through a local user.dart model on the profile screen with
                // a custom social-style profile layout.
                Row(
                  children: [
                    CustomText(
                      text: 'Profile',
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: CustomText(
                        text: '@${user.username}',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                Container(
                  padding: EdgeInsets.all(22.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.88),
                    borderRadius: BorderRadius.circular(32.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEC407A).withOpacity(0.10),
                        blurRadius: 26,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.r),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF7043),
                              Color(0xFFEC407A),
                              Color(0xFF7C4DFF),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 42.r,
                          backgroundColor: Colors.white,
                          backgroundImage: profileImage,
                          child: user.image.isEmpty
                              ? CustomText(
                                  text: user.initials,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      CustomText(
                        text: user.fullName,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6.h),
                      CustomText(
                        text: user.email,
                        fontSize: 13.sp,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 18.h),
                      Row(
                        children: [
                          Expanded(
                            child: _StatChip(
                              label: 'User ID',
                              value: user.id.toString(),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _StatChip(
                              label: 'Gender',
                              value: user.gender.isEmpty ? 'N/A' : user.gender,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _StatChip(
                              label: 'Age',
                              value: user.age.isEmpty ? 'N/A' : user.age,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                _ProfilePanel(
                  title: 'Account Snapshot',
                  children: [
                    _ProfileRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Display Name',
                      value: user.fullName,
                    ),
                    _ProfileRow(
                      icon: Icons.alternate_email_rounded,
                      label: 'Username',
                      value: '@${user.username}',
                    ),
                    _ProfileRow(
                      icon: Icons.badge_outlined,
                      label: 'Member ID',
                      value: user.id.toString(),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                _ProfilePanel(
                  title: 'Contact and Identity',
                  children: [
                    _ProfileRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user.email,
                    ),
                    _ProfileRow(
                      icon: Icons.wc_outlined,
                      label: 'Gender',
                      value: user.gender.isEmpty ? 'Not set' : user.gender,
                    ),
                    _ProfileRow(
                      icon: Icons.cake_outlined,
                      label: 'Age',
                      value: user.age.isEmpty ? 'Not set' : user.age,
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
                SizedBox(
                  height: 56.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF7043),
                          Color(0xFFEC407A),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEC407A).withOpacity(0.22),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                      ),
                      onPressed: () async {
                        await UserService().logout();

                        if (!mounted) {
                          return;
                        }

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/signin',
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Log Out'),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2FF),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          CustomText(
            text: value,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: label,
            fontSize: 11.sp,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProfilePanel extends StatelessWidget {
  const _ProfilePanel({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 10.h),
          ...children,
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 9.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F2FF),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, size: 18.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: label,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 3.h),
                CustomText(
                  text: value,
                  fontSize: 14.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
