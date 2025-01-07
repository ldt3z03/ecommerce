import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../controller/cart_controller.dart';
import '../controller/login_controller.dart';
import '../model/product/product.dart';
import '../model/cart/cart.dart';
import 'home_page.dart';


class ProductDescriptionPage extends StatefulWidget {
  @override
  State<ProductDescriptionPage> createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final String productId = Get.arguments ?? "";

    return GetBuilder<HomeController>(builder: (ctrl) {
      final Product? product = ctrl.getProductById(productId);

      if (product == null) {
        return Scaffold(
          appBar: AppBar(title: const Text("Product Details")),
          body: const Center(child: Text("Product not found")),
        );
      }

      // Lấy userId từ LoginController
      final LoginController loginController = Get.find<LoginController>();
      final userId = loginController.getCurrentUser()?.id;

      // Kiểm tra xem userId có hợp lệ không
      if (userId == null) {
        return Scaffold(
          appBar: AppBar(title: const Text("Product Details")),
          body: const Center(child: Text("Please log in to add products to the cart.")),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(product.name ?? "Product Details"),
          backgroundColor: Colors.teal, // Màu nền app bar mới
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.off(HomePage()), // Điều hướng đến HomePage khi nhấn nút quay lại
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  product.image ?? "",
                  height: 250, // Kích thước hình ảnh lớn hơn
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  product.name ?? "No Name",
                  style: const TextStyle(
                    fontSize: 26, // Tiêu đề lớn hơn
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // Màu sắc hợp với nền
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "\$${product.price?.toStringAsFixed(2) ?? "0.00"}",
                  style: const TextStyle(
                    fontSize: 22, // Kích thước giá lớn hơn
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      "Category: ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      ctrl.getCategoryNameById(product.category ?? "Unknown"),
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Brand: ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      product.brand ?? "Unknown",
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Product Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // Màu chữ hợp với giao diện
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description ?? "No description available.",
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87, // Màu văn bản hợp lý
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text(
                      "Quantity:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                      icon: const Icon(Icons.remove),
                      color: Colors.teal, // Màu sắc cho icon
                    ),
                    Text(
                      "$quantity",
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      icon: const Icon(Icons.add),
                      color: Colors.teal, // Màu sắc cho icon
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Tạo cart với userId từ LoginController
                      Cart cart = Cart(
                        productId: product.id,
                        name: product.name,
                        price: product.price,
                        quantity: quantity,
                        totalPrice: (product.price ?? 0) * quantity,
                        image: product.image,
                        productCategory: product.category,
                        isOffer: product.offer,
                        userId: userId, // Lấy userId từ model User
                      );

                      // Thực hiện thêm vào giỏ hàng
                      Get.find<CartController>().addToCart(cart);
                      Get.snackbar(
                        "Cart",
                        "Added $quantity item(s) to cart.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.teal, // Màu sắc cho snackbar
                        colorText: Colors.white,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Màu nền nút
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Màu chữ trắng trên nút
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
