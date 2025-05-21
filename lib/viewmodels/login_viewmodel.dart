import 'dart:async';

import 'package:english_learning_app/router/app_route_name.dart';
import 'package:english_learning_app/service/core_api_client.dart';
import 'package:english_learning_app/utils/network_service.dart';
import 'package:english_learning_app/viewmodels/main_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/viewmodel_base.dart';
import '../utils/app_util.dart';

class LoginViewModel extends ViewModelBase {
  bool staffLogin = false;
  bool isHidePassword = true;
  bool isSuccess = false;

  // User object to track if the user is logged in
  dynamic user;
  String? errorMessage;

  bool passwordVisible = false;
  // Controllers
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  String? emailError;
  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError = 'Email không được để trống';
    } else if (!value.contains('@')) {
      emailError = 'Email không hợp lệ';
    } else {
      emailError = null;
    }
    notifyListeners();
  }

  String? passwordError;

  void validatePassword(String value) {
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{6,}$');

    if (value.isEmpty) {
      passwordError = 'Mật khẩu không được để trống';
    } else if (value.length <= 6) {
      passwordError = 'Mật khẩu phải có ít nhất 8 ký tự';
    } else if (!passwordRegex.hasMatch(value)) {
      passwordError = 'Mật khẩu cần có ít nhất 1 chữ hoa,1 chữ thường,1 số và 1 ký tự đặc biệt';
    } else {
      passwordError = null;
    }
    notifyListeners(); // cập nhật UI
  }

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void showMessageHomePage() {
    AppUtil.navigatorKey.currentContext!.go(AppRouteName.home);
  }

  Future login() async {
    validateEmail(email.text);
    validatePassword(password.text);

    if (emailError != null || passwordError != null) {
      AppUtil.showToastError('Vui lòng điền đầy đủ thông tin đăng nhập hợp lệ');
      return;
    }

    AppUtil.unfocus();
    isLoading = true;
    notifyListeners();
    bool isConnect = await NetworkService().isConnect();
    if (isConnect) {
      try {
        CoreApiClient.Login(
          username: email.text.trim(),
          password: password.text.trim(),
        ).then((value) {
          isLoading = false;
          if (!value) {
            password.text = "";
          } else {
            showMessageHomePage();
            notifyListeners();
          }
          notifyListeners();
        });
      } catch (e) {
        isLoading = false;
        AppUtil.showToastError(e.toString());
        notifyListeners();
      }
    } else {
      AppUtil.showToastError('Không có kết nối mạng');
      Future.delayed(Duration(seconds: 1)).then((value) {
        isLoading = false;
        notifyListeners();
      });
    }
  }

  // Google Sign-In method (placeholder)
  Future<bool> signInWithGoogle() async {
    isLoading = true;
    notifyListeners();

    // TODO: Implement Google Sign-In
    await Future.delayed(Duration(seconds: 2)); // Giả lập xử lý

    // Mã giả cho thành công
    user = {'username': 'google_user@example.com', 'provider': 'google'};
    isLoading = false;
    notifyListeners();
    return true;
  }

  cleanAccount() {
    if (MainViewModel().isLoadAccount) {
      password.text = "";
      email.text = "";
      isLoading = false;
    }
    MainViewModel().isLoadAccount = false;
  }

  void loading() {
    isLoading = true;
    notifyListeners();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
