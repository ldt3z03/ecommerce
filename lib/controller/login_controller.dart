import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/user/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import '../pages/home_page.dart';

class LoginController extends GetxController {
  final GetStorage box = GetStorage();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late CollectionReference userCollection;
  final TextEditingController registerNameCtrl = TextEditingController();
  final TextEditingController registerNumberCtrl = TextEditingController();
  final TextEditingController loginNumberCtrl = TextEditingController();
  final OtpFieldControllerV2 otpController = OtpFieldControllerV2();

  Rx<User?> loginUser = Rx<User?>(null); // Quản lý trạng thái người dùng
  bool otpFieldShow = false;
  int? otpSend;
  int? otpEntered;

  @override
  void onReady() {
    super.onReady();

    // Lấy dữ liệu người dùng từ GetStorage
    Map<String, dynamic>? storedUser = box.read('loginUser');
    if (storedUser != null) {
      loginUser.value = User.fromJson(storedUser);
      Get.to(const HomePage());
    }
  }

  @override
  void onInit() {
    super.onInit();
    userCollection = firestore.collection('users');
  }

  /// Gửi OTP ngẫu nhiên
  void sendOtp() {
    if (registerNameCtrl.text.isEmpty || registerNumberCtrl.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields', colorText: Colors.red);
      return;
    }

    try {
      otpSend = 1000 + Random().nextInt(9000); // Tạo OTP ngẫu nhiên
      otpFieldShow = true;

      print("Generated OTP: $otpSend"); // Debug: In OTP ra console
      Get.snackbar('Success', 'OTP sent successfully', colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Error', 'Failed to send OTP', colorText: Colors.red);
      print(e);
    } finally {
      update(); // Cập nhật giao diện
    }
  }

  /// Xác minh và thêm người dùng mới
  Future<void> addUser() async {
    if (otpSend != otpEntered) {
      Get.snackbar('Error', 'OTP is incorrect', colorText: Colors.red);
      return;
    }

    try {
      DocumentReference doc = userCollection.doc(); // Tạo document mới trong Firestore
      User user = User(
        id: doc.id,
        name: registerNameCtrl.text,
        phonenumber: int.parse(registerNumberCtrl.text),
      );

      await doc.set(user.toJson()); // Lưu vào Firestore
      box.write('loginUser', user.toJson()); // Lưu thông tin người dùng vào GetStorage
      loginUser.value = user; // Cập nhật trạng thái người dùng

      Get.snackbar('Success', 'User registered successfully', colorText: Colors.green);
      registerNameCtrl.clear();
      registerNumberCtrl.clear();
      otpController.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to register user', colorText: Colors.red);
      print("AddUser Error: $e");
    } finally {
      update();
    }
  }

  /// Đăng nhập với số điện thoại
  Future<void> loginWithPhone() async {
    if (loginNumberCtrl.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number', colorText: Colors.red);
      return;
    }

    try {
      String phoneNumber = loginNumberCtrl.text;

      var querySnapshot = await userCollection
          .where('phonenumber', isEqualTo: int.tryParse(phoneNumber))
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first;
        var userData = userDoc.data() as Map<String, dynamic>;

        loginUser.value = User.fromJson(userData); // Cập nhật trạng thái người dùng
        box.write('loginUser', userData); // Lưu thông tin vào GetStorage

        loginNumberCtrl.clear();
        Get.to(HomePage());
        Get.snackbar('Success', 'Login successful', colorText: Colors.green);
      } else {
        Get.snackbar('Error', 'User not found, please register', colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to login', colorText: Colors.red);
      print("Login Error: $e");
    }
  }

  /// Lấy thông tin người dùng hiện tại
  User? getCurrentUser() {
    return loginUser.value;
  }

  /// Đăng xuất người dùng
  void logout() {
    loginUser.value = null;
    box.remove('loginUser'); // Xóa dữ liệu từ GetStorage
    Get.offAll(() => const HomePage()); // Điều hướng về trang chủ
  }
}
