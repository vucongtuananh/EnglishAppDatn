// import 'package:english_learning_app/viewmodels/login_viewmodel.dart';
// import 'package:english_learning_app/views/auth/login_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_color/flutter_color.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// final vmProvider = ChangeNotifierProvider((ref) => LoginViewModel());
//
//
// class ResetPasswordView extends ConsumerWidget {
//   static const String routeName = "/resetpassword";
//
//   const ResetPasswordView({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final vm = ref.read(vmProvider);
//     // final loginVM = ref.watch(authViewModelProvider);
//     // final emailError = ref.watch(resetEmailErrorProvider);
//     // final emailFocus = ref.watch(resetEmailFocusProvider);
//     // final isButtonEnabled = ref.watch(resetButtonEnabledProvider);
//
//     // Tạo controller email riêng cho màn hình reset password
//     final TextEditingController emailController = TextEditingController();
//     bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
//
//     return Scaffold(
//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: Consumer(
//           builder: (context, ref, _) {
//             final vm = ref.watch(authViewModelProvider);
//
//             return Stack(
//               children: [
//                 Positioned.fill(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey.withOpacity(0.1),
//                     ),
//                   ),
//                 ),
//                 Positioned.fill(
//                   child: SafeArea(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             'Đặt lại mật khẩu',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           const Text(
//                             'Nhập email của bạn để nhận link đặt lại mật khẩu',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black54,
//                             ),
//                           ),
//                           const SizedBox(height: 30),
//                           // Email field
//                           Focus(
//                             onFocusChange: (hasFocus) =>
//                             ref.read(resetEmailFocusProvider.notifier).state = hasFocus,
//                             child: TextField(
//                               controller: emailController,
//                               onChanged: validateEmail,
//                               style: TextStyle(
//                                 color: emailFocus ? Colors.blue : Colors.black,
//                               ),
//                               decoration: InputDecoration(
//                                 icon: const Icon(Icons.email),
//                                 iconColor: HexColor("#b7d7d3"),
//                                 labelText: 'Email',
//                                 labelStyle: TextStyle(
//                                   color: emailFocus ? Colors.blue : Colors.black,
//                                 ),
//                                 errorText: emailError,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                     color: Colors.blue,
//                                     width: 2.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           // Button xác nhận
//                           SizedBox(
//                             height: 50,
//                             width: double.infinity,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).primaryColor,
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(
//                                   color: Colors.grey,
//                                   width: 1,
//                                 ),
//                               ),
//                               child: ElevatedButton(
//                                 onPressed: isButtonEnabled && !vm.isLoading
//                                     ? handleResetPassword
//                                     : null,
//                                 style: ElevatedButton.styleFrom(
//                                   disabledBackgroundColor: Colors.grey,
//                                   disabledForegroundColor: Colors.black54,
//                                   foregroundColor: Colors.black,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                     side: const BorderSide(
//                                       color: Colors.grey,
//                                       width: 2,
//                                     ),
//                                   ),
//                                 ),
//                                 child: const Text("Xác nhận"),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           Visibility(
//                             visible: !isKeyboardOpen,
//                             child: Center(
//                               child: TextButton(
//                                 onPressed: () {
//                                   Navigator.pushReplacementNamed(context, '/loginview');
//                                 },
//                                 child: Text.rich(
//                                   TextSpan(
//                                     text: "Quay lại ",
//                                     style: const TextStyle(color: Colors.black, fontSize: 16),
//                                     children: [
//                                       TextSpan(
//                                         text: 'Đăng nhập',
//                                         style: TextStyle(color: Colors.blue, fontSize: 16),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Loading overlay
//                 if (vm.isLoading)
//                   Positioned.fill(
//                     child: Container(
//                       color: Colors.black54,
//                       child: const Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     ),
//                   ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   // void validateEmail(String value) {
//   //   String? error;
//   //   if (value.isEmpty) {
//   //     error = 'Email không được để trống';
//   //   } else if (!value.contains('@')) {
//   //     error = 'Email không hợp lệ';
//   //   }
//   //
//   //   ref.read(resetEmailErrorProvider.notifier).state = error;
//   //   // Cập nhật trạng thái của nút xác nhận
//   //   ref.read(resetButtonEnabledProvider.notifier).state =
//   //       error == null && value.isNotEmpty;
//   // }
//
//   void showMessage(String title, String message) {
//     showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(message),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Đồng ý'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void handleResetPassword() async {
//     if (emailController.text.isEmpty) {
//       showMessage('Lỗi', 'Email không được để trống');
//       return;
//     }
//
//     try {
//       // Đặt trạng thái loading
//       vm.loading();
//
//       // Gọi phương thức resetPassword từ LoginViewModel
//       // Nếu chưa có phương thức này trong LoginViewModel, bạn cần thêm vào
//       await loginVM.resetPassword(emailController.text);
//
//       // Xử lý kết quả
//       if (loginVM.errorMessage != null) {
//         showMessage('Lỗi', loginVM.errorMessage!);
//       } else {
//         showMessage('Thành công', 'Vui lòng kiểm tra email của bạn để lấy link đặt lại mật khẩu.');
//         // Có thể chuyển về trang đăng nhập sau khi đặt lại mật khẩu thành công
//         Future.delayed(Duration(seconds: 2), () {
//           Navigator.pushReplacementNamed(context, '/loginview');
//         });
//       }
//     } catch (e) {
//       showMessage('Lỗi', e.toString());
//     } finally {
//       // Đặt trạng thái không loading
//       loginVM.reloadByLogin();
//     }
//   }
// }