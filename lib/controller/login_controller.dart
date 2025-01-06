import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/user/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import '../pages/home_page.dart';

class LoginController extends GetxController{

    GetStorage box = GetStorage();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    late CollectionReference userCollection;
    TextEditingController registerNameCtrl = TextEditingController();
    TextEditingController registerNumberCtrl = TextEditingController();

    TextEditingController loginNumberCtrl = TextEditingController();


    OtpFieldControllerV2 otpController = OtpFieldControllerV2();
    bool otpFieldShow = false;
    int? otpSend;
    int? otpEntered;

    User? loginUser;

    @override
  void onReady() {
    Map<String,dynamic>? user = box.read('loginUser');
    if(user != null) {
      loginUser = User.fromJson(user);
      Get.to(const HomePage());
    }
    super.onReady();
  }

    @override
    void onInit() {
      userCollection = firestore.collection('users');
      super.onInit();
    }

    addUser(){
      try {
        if(otpSend == otpEntered){
          DocumentReference doc = userCollection.doc();
          User user = User(
            id: doc.id,
            name: registerNameCtrl.text,
            phonenumber: int.parse(registerNumberCtrl.text),
          );
          final userJson = user.toJson();
          doc.set(userJson);
          Get.snackbar('Success' , 'User added successfully', colorText: Colors.green);
          registerNameCtrl.clear();
          registerNumberCtrl.clear();
          otpController.clear();
        }else{
          Get.snackbar('Error' , 'OTP is incorrect', colorText: Colors.red);
        }

      } catch (e) {
        Get.snackbar('Error' ,e.toString(), colorText: Colors.red);
        print(e);
      }
    }

    sendOtp(){
      try {
        if(registerNameCtrl.text.isEmpty || registerNumberCtrl.text.isEmpty){
          Get.snackbar('Error' , 'Please fill the fields', colorText: Colors.red);
          return;
        }

        final random  = Random();
        int otp = 1000 + random.nextInt(9000);
        print(otp);
        if(otp != null){
                otpFieldShow = true;
                otpSend = otp;
                Get.snackbar('Success', 'OTP send successfully',colorText: Colors.green);
              }else{
                Get.snackbar('Error', 'OTP not send!',colorText: Colors.red);
              }
      } catch (e) {
        print(e);
      }finally{
        update();
      }
    }

    Future<void> loginWithPhone() async {
        try{
            String phoneNumber = loginNumberCtrl.text;
            if(phoneNumber.isNotEmpty){
              var querySnapshot = await userCollection.where('phonenumber',isEqualTo: int.tryParse(phoneNumber)).limit(1).get();
              if(querySnapshot.docs.isNotEmpty){
                var userDoc = querySnapshot.docs.first;
                var userData = userDoc.data() as Map <String,dynamic>;
                box.write('loginUser', userData);
                loginNumberCtrl.clear();
                Get.to(HomePage());
                Get.snackbar('Success', 'Login Successfully',colorText: Colors.green);
              }else{
                Get.snackbar('Error', 'User not found, please register',colorText: Colors.green);
              }
            }


        }catch(error){
            print("Failed to login: $error");
            Get.snackbar("Error", "Failed to login",colorText: Colors.red);
        }
    }
}