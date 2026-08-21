import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';
import '../services/product_service.dart';
import '../services/user_service.dart';
import '../widgets/custom_text.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    this.product,
    this.productId,
  }) : assert(product != null || productId != null);

  final Product? product;
  final int? productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final Future<Product> _productFuture;
  int _quantity = 1;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _productFuture = widget.product != null
        ? Future.value(widget.product!)
        : ProductService().getProductById(widget.productId!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Product Details'),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: CustomText(
                  text: 'Error: ${snapshot.error}',
                  fontSize: 14.sp,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final product = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: CustomText(
              text: product.title,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.network(
                    product.thumbnail,
                    height: 260.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      height: 260.h,
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image, size: 48),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                CustomText(
                  text: product.title,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: '\$${product.price.toStringAsFixed(2)}',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 16.h),
                CustomText(
                  text: product.description,
                  fontSize: 14.sp,
                ),
                SizedBox(height: 20.h),
                _detailRow('Category', product.category),
                _detailRow('Brand', product.brand),
                _detailRow('Rating', product.rating.toStringAsFixed(1)),
                _detailRow('Stock', product.stock.toString()),
                _detailRow('Availability', product.availabilityStatus),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    CustomText(
                      text: 'Quantity',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _quantity > 1
                          ? () {
                              setState(() {
                                _quantity--;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    CustomText(
                      text: '$_quantity',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isAddingToCart
                        ? null
                        : () => _addToCart(product),
                    icon: _isAddingToCart
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.shopping_cart_checkout),
                    label: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      // Enhancement 3: add to cart by posting the selected
                      // product id and quantity to DummyJSON's /carts/add API.
                      child: Text(
                        _isAddingToCart ? 'Adding...' : 'Add to Cart',
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

  Future<void> _addToCart(Product product) async {
    setState(() {
      _isAddingToCart = true;
    });

    try {
      final userData = await UserService().getUserData();
      final userId = (userData['id'] as int?) ?? fallbackCartUserId;

      await CartService().addToCart(
        userId: userId > 0 ? userId : fallbackCartUserId,
        productId: product.id,
        quantity: _quantity,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${product.title} added to user ${userId > 0 ? userId : fallbackCartUserId} cart.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to add product to cart: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.w,
            child: CustomText(
              text: '$label:',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: CustomText(
              text: value,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
