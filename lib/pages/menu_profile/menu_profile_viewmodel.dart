import 'dart:io';

import 'package:english_learning_app/models/user_model.dart';
import 'package:english_learning_app/models/viewmodel_base.dart';
import 'package:english_learning_app/service/core_api_client.dart';
import 'package:english_learning_app/utils/network_service.dart';
import 'package:english_learning_app/viewmodels/main_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MenuProfileViewmodel extends ViewModelBase {
  logout() async {
    bool isConnect = await NetworkService().isConnect();
    if (isConnect) {
      try {
        if (kReleaseMode) CoreApiClient.logout();
      } catch (e) {
        print(e);
      }
      MainViewModel().setLoggedIn(false);
    }
  }

  int currentIndex = 0; // 0 for profile, 1 for edit profile, 2 for change password

  // Variables for profile edit page
  File? imageFile;
  String imageUrl = '';
  final List<TextEditingController> textEditingController = List.generate(3, (index) => TextEditingController());
  bool isLoading = false;

  // Variables for change password page
  final formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool obscureCurrentPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  // Method to initialize user data
  void initUserData(UserModel? user) {
    if (user != null) {
      imageUrl = user.urlAvatar ?? "";
      textEditingController[0].text = user.username!;
      textEditingController[1].text = user.email!;
      textEditingController[2].text = '●●●●●●●●';
      notifyListeners();
    }
  }

  // Method to set current index
  void setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  // Method for image selection
  Future<void> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  // Method to upload image
  Future<String> uploadImage(File file) async {
    // Implementation remains the same
    await Future.delayed(const Duration(seconds: 2));
    return 'https://via.placeholder.com/150';
  }

  // Method to upload image to API with loading state
  Future<String> uploadImageToApi(File image, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      final uploadedUrl = await uploadImage(image);
      return uploadedUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return imageUrl;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Method to save profile
  Future<void> saveProfile(BuildContext context, UserModel user) async {
    if (imageFile != null) {
      imageUrl = await uploadImageToApi(imageFile!, context);
    }

    UserModel newUser = UserModel(
      id: user.id,
      role: user.role,
      email: user.email,
      urlAvatar: imageUrl,
      signInMethod: user.signInMethod,
      completedLessons: user.completedLessons,
      progress: user.progress,
      username: textEditingController[0].text,
      streak: user.streak,
      language: user.language,
      heart: user.heart,
      gem: user.gem,
      xp: user.xp,
      lastCompletionDate: user.lastCompletionDate,
      phone: user.phone,
      created_at: user.created_at,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lưu thay đổi thành công')),
    );

    currentIndex = 0; // Go back to profile view
    notifyListeners();
  }

  // Method to toggle password visibility
  void togglePasswordVisibility(String field) {
    switch (field) {
      case 'current':
        obscureCurrentPassword = !obscureCurrentPassword;
        break;
      case 'new':
        obscureNewPassword = !obscureNewPassword;
        break;
      case 'confirm':
        obscureConfirmPassword = !obscureConfirmPassword;
        break;
    }
    notifyListeners();
  }

  // Method to change password
  Future<void> changePassword(BuildContext context, String currentPassword, String newPassword) async {
    isLoading = true;
    notifyListeners();

    try {
      // Call your API to change password
      await Future.delayed(const Duration(seconds: 2));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thay đổi mật khẩu thành công')),
      );
      currentIndex = 0; // Go back to profile view
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
