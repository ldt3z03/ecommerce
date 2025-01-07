import 'package:ecommerce_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../controller/login_controller.dart';
import '../model/cart/cart.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    return GetBuilder<CartController>(
      builder: (cartCtrl) {
        // Kiểm tra user đã đăng nhập chưa
        if (loginController.getCurrentUser() == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Your Cart')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Please login to view your cart'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Điều hướng đến trang login
                      Get.toNamed('/login'); // Thay đổi route này theo route của bạn
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          );
        }

        List<Cart> cartItems = cartCtrl.cartShowInUI;

        // Kiểm tra nếu giỏ hàng rỗng
        if (cartItems.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Your Cart')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(HomePage());
                    },
                    child: const Text('Continue Shopping'),
                  ),
                ],
              ),
            ),
          );
        }

        double totalAmount = cartCtrl.calculateTotalPrice();

        return Scaffold(


          appBar: AppBar(
            title: const Text('Your Cart'),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await cartCtrl.fetchCarts();
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        Cart cartItem = cartItems[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Image with error handling
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Image.network(
                                    cartItem.image ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.image_not_supported);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartItem.name ?? 'No name',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "\$${(cartItem.totalPrice ?? 0).toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: cartItem.quantity! > 1
                                                ? () {
                                              cartCtrl.updateQuantity(
                                                cartItem.productId ?? '',
                                                (cartItem.quantity ?? 1) - 1,
                                              );
                                            }
                                                : null,
                                            icon: const Icon(Icons.remove),
                                          ),
                                          Text(
                                            '${cartItem.quantity ?? 1}',
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              cartCtrl.updateQuantity(
                                                cartItem.productId ?? '',
                                                (cartItem.quantity ?? 1) + 1,
                                              );
                                            },
                                            icon: const Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Thêm dialog xác nhận xóa
                                    Get.defaultDialog(
                                      title: 'Remove Item',
                                      content: const Text('Are you sure you want to remove this item?'),
                                      textConfirm: 'Remove',
                                      textCancel: 'Cancel',
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        Get.back();
                                        cartCtrl.removeFromCart(cartItem.productId ?? '');
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, -1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '\$${totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () {
                              Get.snackbar(
                                'Cart',
                                'Proceeding to checkout...',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            child: const Text(
                              'Checkout',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}