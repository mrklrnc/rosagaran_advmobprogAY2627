import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import 'cart_screen.dart';
import 'product_screen.dart';

import '../widgets/custom_text.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({
    super.key,
    this.username = '',
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _cartRefreshToken = 0;

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 2,
          title: _buildTitle(),
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                size: 24.sp,
              ),
              onPressed: () => Navigator.pushNamed(
                context,
                '/settings',
              ),
            ),
          ],
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              _selectedIndex = page;
            });
          },
          children: <Widget>[
            const ProductScreen(),
            CartScreen(
              userId: demoCartUserId,
              refreshToken: _cartRefreshToken,
            ),
            _buildProfilePlaceholder(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // Enhancement 2: the middle bottom action is presented as a
        // FloatingActionButton and hidden while the cart screen is active.
        floatingActionButton: _selectedIndex == 1
            ? null
            : FloatingActionButton(
                onPressed: () {
                  _openPage(1, refreshCart: true);
                },
                child: const Icon(Icons.shopping_cart),
              ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: SizedBox(
            height: 64.h,
            child: Row(
              children: [
                Expanded(
                  child: _NavButton(
                    icon: Icons.shop_2,
                    label: 'Shop',
                    isSelected: _selectedIndex == 0,
                    onTap: () => _openPage(0),
                  ),
                ),
                Expanded(
                  child: IgnorePointer(
                    ignoring: _selectedIndex != 1,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _selectedIndex == 1 ? 1 : 0,
                      child: _NavButton(
                        icon: Icons.shopping_cart,
                        label: 'Cart',
                        isSelected: _selectedIndex == 1,
                        onTap: () => _openPage(1, refreshCart: true),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _NavButton(
                    icon: Icons.person,
                    label: 'Profile',
                    isSelected: _selectedIndex == 2,
                    onTap: () => _openPage(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    if (_selectedIndex == 0) {
      return Image.asset(
        'assets/images/nubdexchange_logo.png',
        scale: 11.sp,
      );
    }

    return CustomText(
      text: _selectedIndex == 1 ? 'Cart' : 'Profile',
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
    );
  }

  Widget _buildProfilePlaceholder() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: CustomText(
          text: 'Profile screen placeholder',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _openPage(int value, {bool refreshCart = false}) {
    setState(() {
      _selectedIndex = value;
      if (refreshCart && value == 1) {
        _cartRefreshToken++;
      }
    });

    _pageController.jumpToPage(value);
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).iconTheme.color;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          SizedBox(height: 4.h),
          CustomText(
            text: label,
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
