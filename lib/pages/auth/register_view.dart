import 'package:english_learning_app/common/rive_animation.dart';
import 'package:english_learning_app/router/app_route_name.dart';
import 'package:english_learning_app/utils/app_style.dart';
import 'package:english_learning_app/utils/app_util.dart';
import 'package:english_learning_app/viewmodels/register_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final registerViewModelProvider = ChangeNotifierProvider((ref) => RegisterViewModel());

class RegisterView extends ConsumerWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(registerViewModelProvider);
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Consumer(
      builder: (context, ref, child) {
        ref.watch(registerViewModelProvider);
        return Scaffold(
          backgroundColor: Colors.white,
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                Positioned.fill(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Visibility(
                            visible: !isKeyboardOpen,
                            child: const Text(
                              'Welcome!\nCreate an Account',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Phone field
                          Focus(
                            onFocusChange: (hasFocus) => ref.read(registerViewModelProvider).setPhoneFocus(hasFocus),
                            child: TextField(
                              controller: vm.phoneController,
                              onChanged: (value) => ref.read(registerViewModelProvider).validatePhone(value),
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                icon: const Icon(
                                  Icons.phone,
                                  color: Colors.black,
                                ),
                                iconColor: HexColor("#b7d7d3"),
                                labelText: 'Số điện thoại',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                errorText: vm.phoneError,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Username field
                          Focus(
                            onFocusChange: (hasFocus) => ref.read(registerViewModelProvider).setUsernameFocus(hasFocus),
                            child: TextField(
                              controller: vm.usernameController,
                              onChanged: (value) => ref.read(registerViewModelProvider).validateUsername(value),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                icon: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                iconColor: HexColor("#b7d7d3"),
                                labelText: 'Tên tài khoản',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                errorText: vm.usernameError,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Email field
                          Focus(
                            onFocusChange: (hasFocus) => ref.read(registerViewModelProvider).setEmailFocus(hasFocus),
                            child: TextField(
                              controller: vm.emailController,
                              onChanged: (value) => ref.read(registerViewModelProvider).validateEmail(value),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                icon: const Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                iconColor: HexColor("#b7d7d3"),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                errorText: vm.emailError,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Password field
                          Focus(
                            onFocusChange: (hasFocus) => ref.read(registerViewModelProvider).setPasswordFocus(hasFocus),
                            child: TextField(
                              controller: vm.passwordController,
                              obscureText: !vm.passwordVisible,
                              onChanged: (value) => vm.validatePassword(value),
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                errorMaxLines: 3,
                                icon: const Icon(
                                  Icons.password,
                                  color: Colors.black,
                                ),
                                iconColor: HexColor("#b7d7d3"),
                                labelText: 'Mật khẩu',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                errorText: vm.passwordError,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    vm.passwordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.black,
                                  ),
                                  onPressed: () => ref.read(registerViewModelProvider).togglePasswordVisibility(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Confirm password field
                          Focus(
                            onFocusChange: (hasFocus) => ref.read(registerViewModelProvider).setPasswordConfirmFocus(hasFocus),
                            child: TextField(
                              controller: vm.passwordConfirmController,
                              obscureText: !vm.passwordConfirmVisible,
                              onChanged: (value) => ref.read(registerViewModelProvider).validatePasswordConfirm(value),
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                icon: const Icon(
                                  Icons.password,
                                  color: Colors.black,
                                ),
                                iconColor: HexColor("#b7d7d3"),
                                labelText: 'Nhập lại mật khẩu',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                errorText: vm.passwordConfirmError,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    vm.passwordConfirmVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.black,
                                  ),
                                  onPressed: () => ref.read(registerViewModelProvider).togglePasswordConfirmVisibility(),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(height: isKeyboardOpen ? 0 : 10),
                          // Register button
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                color: vm.isRegisterButtonEnabled ? Theme.of(context).primaryColor : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: vm.isRegisterButtonEnabled ? Colors.grey : Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: vm.isRegisterButtonEnabled ? () => vm.registerWithEmail() : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: vm.isRegisterButtonEnabled ? AppStyle.color.primary : Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  disabledBackgroundColor: Colors.grey[300],
                                  disabledForegroundColor: Colors.grey[600],
                                ),
                                child: Text(
                                  "Đăng ký",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: vm.isRegisterButtonEnabled ? Colors.white : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: !isKeyboardOpen,
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  GoRouter.of(AppUtil.navigatorKey.currentContext!).go(AppRouteName.login); // Replace '/login' with your actual login route
                                },
                                child: Text.rich(
                                  TextSpan(
                                    text: "Bạn đã có tài khoản? ",
                                    style: const TextStyle(color: Colors.black, fontSize: 16),
                                    children: [
                                      TextSpan(
                                        text: 'Đăng nhập',
                                        style: TextStyle(color: AppStyle.color.primary, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (vm.isLoading)
                  const Positioned.fill(
                    child: Center(
                      child: MyRiveAnimation(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi'),
          content: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.lightBlueAccent
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.5, size.width, size.height * 0.25)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
