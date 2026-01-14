import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_planning_app/services/auth_service.dart';

class LoginController extends GetxController{
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _authService = AuthService();

  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<bool> login(GlobalKey<FormState> formKey) async {
    if(!formKey.currentState!.validate()) return false;

    isLoading.value = true;
    try{
      Get.dialog(
        Center(
          child: Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26)
            ),
            child: const CircularProgressIndicator(),
          ),
        )
      );

      final userCredential = await _authService.login(
        email: emailController.text, 
        password: passwordController.text
      );

      if(userCredential == null){
        if(Get.isDialogOpen ?? false){
          Get.back();
        }

        Get.snackbar(
          "Login failed", 
          "Please check your email and password", 
          backgroundColor: Colors.red, 
          colorText: Colors.white, 
          snackPosition: SnackPosition.BOTTOM
        );
        return false;
      }

      if(Get.isDialogOpen ?? false){
        Get.back();
      }
      
      return true;
    } catch(err){
      debugPrint("login error: $err");
      return false;
    } finally{
      isLoading.value = false;
    }
  }
}