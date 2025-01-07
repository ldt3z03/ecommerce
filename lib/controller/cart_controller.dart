import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/cart/cart.dart';
import '../controller/login_controller.dart';

class CartController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference cartCollection;
  late LoginController loginController;

  RxList<Cart> carts = <Cart>[].obs;
  RxList<Cart> cartShowInUI = <Cart>[].obs;

  @override
  void onInit() {
    super.onInit();
    cartCollection = firestore.collection('cart');
    loginController = Get.find<LoginController>();
    fetchCarts();
  }

  String? getCurrentUserId() {
    return loginController.getCurrentUser()?.id;
  }

  fetchCarts() async {
    try {
      String? userId = getCurrentUserId();
      print("Fetching carts for userId: $userId");

      if (userId != null) {
        // Query chỉ lấy cart của user hiện tại
        QuerySnapshot cartSnapshot = await cartCollection
            .where('userId', isEqualTo: userId)
            .get();

        print("Found ${cartSnapshot.docs.length} cart items for user $userId");

        final List<Cart> retrievedCarts = cartSnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return Cart.fromJson(data);
        }).toList();

        carts.assignAll(retrievedCarts);
        cartShowInUI.assignAll(retrievedCarts); // Chỉ hiển thị cart của user hiện tại
        update();
        print("Successfully updated cart for user $userId");
      } else {
        print("Error: No user ID available for fetching carts");
        carts.clear();
        cartShowInUI.clear();
        update();
        Get.snackbar('Error', 'Please login to view your cart', colorText: Colors.red);
      }
    } catch (e) {
      print("Error fetching carts: $e");
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  addToCart(Cart cart) async {
    try {
      String? userId = getCurrentUserId();
      print("Current userId: $userId");
      print("Initial cart data: ${cart.toJson()}");

      if (userId != null) {
        // Chỉ tìm trong cart của user hiện tại
        Cart? existingCart = cartShowInUI.firstWhereOrNull(
                (item) => item.productId == cart.productId && item.userId == userId
        );
        print("Existing cart check: ${existingCart != null ? 'Found' : 'Not found'}");

        if (existingCart != null) {
          try {
            print("Updating existing cart with ID: ${existingCart.id}");
            existingCart.quantity = existingCart.quantity! + cart.quantity!;
            existingCart.updateTotalPrice();

            print("Update data: ${existingCart.toJson()}");
            await cartCollection.doc(existingCart.id).update(existingCart.toJson());

            cartShowInUI.refresh();
            print("Successfully updated existing cart");
            Get.snackbar(
                'Cart',
                'Updated ${cart.name} in cart',
                snackPosition: SnackPosition.BOTTOM
            );
          } catch (updateError) {
            print("Error updating existing cart: $updateError");
            throw updateError;
          }
        } else {
          try {
            cart.userId = userId; // Đảm bảo set userId cho cart mới
            print("Adding new cart with userId: $userId");
            print("Cart data to add: ${cart.toJson()}");

            DocumentReference docRef = await cartCollection.add(cart.toJson());
            print("Successfully added document with ID: ${docRef.id}");

            await fetchCarts(); // Fetch lại để cập nhật danh sách
            Get.snackbar(
                'Cart',
                'Added ${cart.name} to cart',
                snackPosition: SnackPosition.BOTTOM
            );
          } catch (addError) {
            print("Error adding new cart: $addError");
            throw addError;
          }
        }
      } else {
        print("Error: No user ID available");
        Get.snackbar('Error', 'Please login to add items to cart', colorText: Colors.red);
      }
    } catch (e) {
      print("Final error in addToCart: $e");
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  // Đảm bảo chỉ xóa được cart của user hiện tại
  removeFromCart(String productId) async {
    try {
      String? userId = getCurrentUserId();
      if (userId == null) {
        Get.snackbar('Error', 'Please login to remove items', colorText: Colors.red);
        return;
      }

      Cart? existingCart = cartShowInUI.firstWhereOrNull(
              (item) => item.productId == productId && item.userId == userId
      );

      if (existingCart != null) {
        print("Removing cart with ID: ${existingCart.id} for user $userId");
        await cartCollection.doc(existingCart.id).delete();
        cartShowInUI.remove(existingCart);
        print("Successfully removed cart item");
        Get.snackbar(
            'Cart',
            'Removed ${existingCart.name} from cart',
            snackPosition: SnackPosition.BOTTOM
        );
      }
    } catch (e) {
      print("Error removing from cart: $e");
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  // Đảm bảo chỉ cập nhật được cart của user hiện tại
  updateQuantity(String productId, int newQuantity) async {
    try {
      String? userId = getCurrentUserId();
      if (userId == null) {
        Get.snackbar('Error', 'Please login to update quantities', colorText: Colors.red);
        return;
      }

      Cart? existingCart = cartShowInUI.firstWhereOrNull(
              (item) => item.productId == productId && item.userId == userId
      );

      if (existingCart != null && newQuantity > 0) {
        print("Updating quantity for cart ID: ${existingCart.id}");
        existingCart.quantity = newQuantity;
        existingCart.updateTotalPrice();

        await cartCollection.doc(existingCart.id).update(existingCart.toJson());
        cartShowInUI.refresh();
        print("Successfully updated quantity");
        Get.snackbar(
            'Cart',
            'Updated quantity of ${existingCart.name}',
            snackPosition: SnackPosition.BOTTOM
        );
      }
    } catch (e) {
      print("Error updating quantity: $e");
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  double calculateTotalPrice() {
    String? userId = getCurrentUserId();
    if (userId == null) return 0.0;

    return cartShowInUI
        .where((cart) => cart.userId == userId)
        .fold(0.0, (sum, cart) => sum + (cart.totalPrice ?? 0));
  }
}