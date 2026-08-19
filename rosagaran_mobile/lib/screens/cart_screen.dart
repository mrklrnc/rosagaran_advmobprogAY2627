import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/cart.dart';
import '../services/cart_service.dart';
import '../widgets/custom_text.dart';
import 'detail_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
    required this.userId,
    this.refreshToken = 0,
  });

  final int userId;
  final int refreshToken;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<Cart?> _cartFuture;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  void didUpdateWidget(covariant CartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshToken != widget.refreshToken ||
        oldWidget.userId != widget.userId) {
      _loadCart();
    }
  }

  void _loadCart() {
    _cartFuture = CartService().getUserCart(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<Cart?>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: CustomText(
                  text: 'Error: ${snapshot.error}',
                  fontSize: 14.sp,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final cart = snapshot.data;

          if (cart == null || cart.products.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: CustomText(
                  text: 'No cart items found for user ${widget.userId}.',
                  fontSize: 15.sp,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _loadCart();
              });

              await _cartFuture;
            },
            child: ListView(
              padding: EdgeInsets.all(16.r),
              children: [
                CustomText(
                  // Enhancement 3: render only one user's cart using the
                  // DummyJSON /carts/user/{id} endpoint.
                  text: 'User ${cart.userId} Cart',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 6.h),
                CustomText(
                  text:
                      '${cart.totalProducts} products - ${cart.totalQuantity} total quantity',
                  fontSize: 13.sp,
                ),
                SizedBox(height: 16.h),
                ...cart.products.map(
                  (product) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _CartProductCard(product: product),
                  ),
                ),
                SizedBox(height: 8.h),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _summaryRow(
                          'Subtotal',
                          '\$${cart.total.toStringAsFixed(2)}',
                        ),
                        SizedBox(height: 8.h),
                        _summaryRow(
                          'Discounted Total',
                          '\$${cart.discountedTotal.toStringAsFixed(2)}',
                        ),
                        SizedBox(height: 8.h),
                        _summaryRow(
                          'Items',
                          '${cart.totalQuantity}',
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'DummyJSON cart loaded successfully.',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Confirm Order'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      children: [
        CustomText(
          text: label,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        const Spacer(),
        CustomText(
          text: value,
          fontSize: 14.sp,
        ),
      ],
    );
  }
}

class _CartProductCard extends StatelessWidget {
  const _CartProductCard({
    required this.product,
  });

  final CartProduct product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      // Enhancement 1: cart items open the shared detail_screen when tapped.
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              productId: product.id,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  product.thumbnail,
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 80.w,
                    height: 80.w,
                    color: Colors.black12,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: product.title,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    CustomText(
                      text: '\$${product.price.toStringAsFixed(2)}',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 6.h),
                    CustomText(
                      text:
                          'Qty: ${product.quantity} - Discounted: \$${product.discountedTotal.toStringAsFixed(2)}',
                      fontSize: 12.sp,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: 'Tap to view details',
                      fontSize: 12.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
