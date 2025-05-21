import 'package:english_learning_app/models/viewmodel_base.dart';
import 'package:english_learning_app/router/app_route_name.dart';
import 'package:english_learning_app/service/core_api_client.dart';
import 'package:english_learning_app/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterViewModel extends ViewModelBase {
  // Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Error states
  String? usernameError;
  String? emailError;
  String? passwordError;
  String? passwordConfirmError;
  String? phoneError;

  // Focus states
  bool usernameFocus = false;
  bool emailFocus = false;
  bool passwordFocus = false;
  bool passwordConfirmFocus = false;
  bool phoneFocus = false;

  // Password visibility
  bool passwordVisible = false;
  bool passwordConfirmVisible = false;

  // Button state
  bool isRegisterButtonEnabled = false;

  // User data and messages
  dynamic user;
  String? errorMessage;

  void setUsernameFocus(bool focus) {
    usernameFocus = focus;
    notifyListeners();
  }

  void setEmailFocus(bool focus) {
    emailFocus = focus;
    notifyListeners();
  }

  void setPasswordFocus(bool focus) {
    passwordFocus = focus;
    notifyListeners();
  }

  void setPasswordConfirmFocus(bool focus) {
    passwordConfirmFocus = focus;
    notifyListeners();
  }

  void setPhoneFocus(bool focus) {
    phoneFocus = focus;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void togglePasswordConfirmVisibility() {
    passwordConfirmVisible = !passwordConfirmVisible;
    notifyListeners();
  }

  void validateUsername(String value) {
    if (value.isEmpty) {
      usernameError = 'Tên tài khoản không được để trống';
    } else if (value.length < 3) {
      usernameError = 'Tên tài khoản phải có ít nhất 3 ký tự';
    } else {
      usernameError = null;
    }
    updateRegisterButtonState();
    notifyListeners();
  }

  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError = 'Email không được để trống';
    } else if (!value.contains('@')) {
      emailError = 'Email không hợp lệ';
    } else {
      emailError = null;
    }
    updateRegisterButtonState();
    notifyListeners();
  }

  void validatePassword(String value) {
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{6,}$');

    if (value.isEmpty) {
      passwordError = 'Mật khẩu không được để trống';
    } else if (value.length <= 8) {
      passwordError = 'Mật khẩu phải có ít nhất 8 ký tự';
    } else if (!passwordRegex.hasMatch(value)) {
      passwordError = 'Mật khẩu cần có ít nhất 1 chữ hoa,1 chữ thường,1 số và 1 ký tự đặc biệt';
    } else {
      passwordError = null;
    }

    validatePasswordConfirm(passwordConfirmController.text); // kiểm tra lại password confirm
    updateRegisterButtonState(); // kiểm tra enable/disable button
    notifyListeners(); // cập nhật UI
  }

  void validatePasswordConfirm(String value) {
    if (value.isEmpty) {
      passwordConfirmError = 'Vui lòng nhập lại mật khẩu';
    } else if (value != passwordController.text) {
      passwordConfirmError = 'Mật khẩu không khớp';
    } else {
      passwordConfirmError = null;
    }
    updateRegisterButtonState();
    notifyListeners();
  }

  void validatePhone(String value) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');

    if (value.isEmpty) {
      phoneError = 'Số điện thoại không được để trống';
    } else if (!phoneRegex.hasMatch(value)) {
      phoneError = 'Số điện thoại phải có 10 chữ số';
    } else {
      phoneError = null;
    }
    updateRegisterButtonState();
    notifyListeners();
  }

  void updateRegisterButtonState() {
    isRegisterButtonEnabled = usernameError == null &&
        emailError == null &&
        passwordError == null &&
        passwordConfirmError == null &&
        phoneError == null &&
        usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordConfirmController.text.isNotEmpty &&
        phoneController.text.isNotEmpty;
    notifyListeners();
  }

  Future<void> registerWithEmail() async {
    final email = emailController.text;
    final password = passwordController.text;
    final username = usernameController.text;
    final phone = phoneController.text;

    isLoading = true;
    notifyListeners();

    try {
      bool isSuccess = await CoreApiClient.register(email: email, password: password, username: username, phone: phone);
      print("object");
      if (isSuccess) {
        isLoading = false;
        // Navigate to login screen
        notifyListeners();
        AppUtil.navigatorKey.currentContext!.pop();
      } else {
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
