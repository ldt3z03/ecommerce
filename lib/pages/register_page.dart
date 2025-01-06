import 'package:ecommerce_app/controller/login_controller.dart';
import 'package:ecommerce_app/pages/login_page.dart';
import 'package:ecommerce_app/widgets/otp_txt_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (ctrl) {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  const Text(
                    "Create Your Account !!",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.phone,
                    controller: ctrl.registerNameCtrl,
                    decoration: InputDecoration(
                          border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                          ),
                       prefixIcon: const Icon(Icons.phone_android),
                       labelText: "Your Name",
                       hintText: "Enter your Name",
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                      keyboardType: TextInputType.phone,
                      controller: ctrl.registerNumberCtrl,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                          ),
                        prefixIcon: const Icon(Icons.phone_android),
                        labelText: "Mobile Number",
                        hintText: "Enter your mobile number",
                      ),
                  ),
                  const SizedBox(height: 20),
                  OtpTextField(otpController: ctrl.otpController, visble: ctrl.otpFieldShow,
                    onComplete: (otp) {
                      ctrl.otpEntered = int.tryParse(otp ?? '0000');
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        if(ctrl.otpFieldShow){
                          ctrl.addUser();
                        }else{
                          ctrl.sendOtp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple,
                      ),
                    child: Text(ctrl.otpFieldShow ? "Register" : "Send OTP"),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(const LoginPage());
                      },
                    child: Text("Login"),
                  ),
              ],
            ),
          ),
        );
      }
    );
  }
}
