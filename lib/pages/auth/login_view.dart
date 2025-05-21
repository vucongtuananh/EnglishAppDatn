import 'package:english_learning_app/common/rive_animation.dart';
import 'package:english_learning_app/router/app_route_name.dart';
import 'package:english_learning_app/utils/app_util.dart';
import 'package:english_learning_app/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_style.dart';

final authViewModelProvider = ChangeNotifierProvider((ref) => LoginViewModel());

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(authViewModelProvider);
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    vm.cleanAccount();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => AppUtil.unfocus(),
        child: Consumer(
          builder: (context, ref, _) {
            final authViewModel = ref.watch(authViewModelProvider);

            return Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          'Hello there!\nWelcome Back',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 140),

                        // Email field
                        TextField(
                          controller: vm.email,
                          onChanged: vm.validateEmail,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.email,
                              color: vm.emailError != null ? Colors.red : Colors.black,
                            ),
                            iconColor: Colors.black,
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: vm.emailError != null ? Colors.red : Colors.black,
                            ),
                            errorText: vm.emailError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: vm.emailError != null ? Colors.red : Colors.black,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Password field
                        TextField(
                          controller: vm.password,
                          obscureText: !vm.passwordVisible,
                          onChanged: (value) => vm.validatePassword(value),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.password,
                              color: vm.passwordError != null ? Colors.red : Colors.black,
                            ),
                            iconColor: Colors.black,
                            labelText: "Mật Khẩu",
                            labelStyle: TextStyle(
                              color: vm.passwordError != null ? Colors.red : Colors.black,
                            ),
                            errorText: vm.passwordError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: vm.passwordError != null ? Colors.red : Colors.black,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  vm.passwordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: vm.passwordError != null ? Colors.red : null,
                                ),
                                onPressed: () {
                                  vm.togglePasswordVisibility();
                                }),
                          ),
                        ),

                        // Forgot password link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Navigator.pushNamed(context, "/resetpassword");
                            },
                            child: const Text(
                              'Quên mật khẩu?',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => vm.login(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyle.color.primary,
                              padding: const EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Đăng nhập với email',
                              style: TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ),

                        // "Or" divider and Google sign-in
                        Visibility(
                          visible: !isKeyboardOpen,
                          child: Column(
                            children: [
                              const Row(
                                textBaseline: TextBaseline.alphabetic,
                                children: <Widget>[
                                  Expanded(
                                    child: Divider(
                                      thickness: 0.5,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      "Hoặc",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      thickness: 0.5,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              googleSignInButton(vm)
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Sign up link
                        Visibility(
                          visible: !isKeyboardOpen,
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                // Navigator.pushNamed(context, '/signup');
                                AppUtil.navigatorKey.currentContext!.push(AppRouteName.signup);
                              },
                              child: Text.rich(
                                TextSpan(
                                  text: "Bạn chưa có tài khoản? ",
                                  style: const TextStyle(color: Colors.black, fontSize: 16),
                                  children: [
                                    TextSpan(
                                      text: 'Đăng ký',
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

                // Loading animation overlay
                if (authViewModel.isLoading)
                  const Positioned.fill(
                    child: Center(
                      child: MyRiveAnimation(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget googleSignInButton(LoginViewModel vm) {
    return Center(
      child: SizedBox(
        height: 55,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(AppUtil.navigatorKey.currentContext!).primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton.icon(
            icon: Image.asset(
              'images/google_logo.png',
              height: 24,
              width: 24,
            ),
            label: const Text(
              "Đăng nhập với Google",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            onPressed: () async {
              // await vm.signInWithGoogle();
              // if (vm.errorMessage != null) {
              //   vm.showErrorDialog(vm.errorMessage!);
              // } else if (vm.isLoggedIn) {
              //   vm.showMessageHomePage();
              // }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.blue,
                  width: 3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
