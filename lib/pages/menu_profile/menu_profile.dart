import 'package:english_learning_app/common/animation_button_common.dart';
import 'package:english_learning_app/pages/menu_profile/menu_profile_viewmodel.dart';
import 'package:english_learning_app/service/data_client_service.dart';
import 'package:english_learning_app/utils/app_style.dart';
import 'package:english_learning_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vmProvider = ChangeNotifierProvider((ref) => MenuProfileViewmodel());

class MenuProfilePage extends ConsumerWidget {
  const MenuProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(vmProvider);
    final authState = ref.watch(vmProvider);

    // Move the helper methods to the beginning before they're used

    // Enhanced stat card with better visual appearance
    Widget _buildEnhancedStatCard({
      required String icon,
      required String value,
      required String label,
      required Color color,
    }) {
      return Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.5), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Image.asset(icon, width: 30, height: 30),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    // Achievement item for displaying user stats
    Widget _buildAchievementItem({
      required Widget leading,
      required String title,
      required String value,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Build text field for profile edit
    Widget buildTextField(String label, TextEditingController controller, bool readonly) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              readOnly: readonly,
              controller: controller,
              decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Profile page content
    Widget buildProfilePage() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppStyle.color.primary,
          elevation: 0,
          title: const Text(
            "Hồ sơ cá nhân",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () => vm.setCurrentIndex(1),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header with gradient background
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppStyle.color.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0, top: 10),
                  child: Column(
                    children: [
                      // Avatar with border
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: vm.imageUrl.isNotEmpty ? NetworkImage(vm.imageUrl) : null,
                          child: vm.imageUrl.isEmpty ? const Icon(Icons.person, size: 60, color: Colors.grey) : null,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // User name with larger font
                      Text(
                        DataClient.user.currentUser!.username!,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Email with slightly transparent text
                      Text(
                        DataClient.user.currentUser!.email ?? "",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Flag with better alignment
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('images/flag_Viet_Nam.png', width: 20),
                            const SizedBox(width: 5),
                            const Text("Tiếng Việt", style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Stats with card style
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Thống kê",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildEnhancedStatCard(
                              icon: 'images/fire.png',
                              value: DataClient.user.currentUser!.streak.toString(),
                              label: 'Ngày streak',
                              color: Colors.orangeAccent,
                            ),
                            _buildEnhancedStatCard(
                              icon: 'images/score_icon.png',
                              value: DataClient.user.currentUser!.xp.toString(),
                              label: 'Tổng KN',
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Additional stats or achievements section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Thành tích học tập",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildAchievementItem(
                          leading: const Icon(Icons.grade, color: Colors.amber, size: 30),
                          title: "Hoàn thành bài học",
                          value: "${DataClient.user.currentUser!.completedLessons?.length ?? 0} bài",
                        ),
                        const Divider(),
                        _buildAchievementItem(
                          leading: const Icon(Icons.favorite, color: Colors.redAccent, size: 30),
                          title: "Tim hiện có",
                          value: "${DataClient.user.currentUser!.heart ?? 5}",
                        ),
                        const Divider(),
                        _buildAchievementItem(
                          leading: const Icon(Icons.diamond, color: Colors.purpleAccent, size: 30),
                          title: "Đá quý",
                          value: "${DataClient.user.currentUser!.gem ?? 0}",
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      );
    }

    // Profile edit page content - redesigned
    Widget buildProfileEditPage() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppStyle.color.primary,
          title: const Text(
            'Tài khoản',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => vm.setCurrentIndex(0),
          ),
          actions: [
            TextButton(
              onPressed: vm.isLoading
                  ? null
                  : () async {
                      // if (user != null) {
                      //   await vm.saveProfile(context, user);
                      // }
                    },
              child: const Text(
                'LƯU LẠI',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        body: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    // Avatar edit section
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppStyle.color.primary.withOpacity(0.5), width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: vm.imageFile != null ? FileImage(vm.imageFile!) : (vm.imageUrl.isNotEmpty ? NetworkImage(vm.imageUrl) as ImageProvider : null),
                                  child: (vm.imageFile == null && vm.imageUrl.isEmpty) ? const Icon(Icons.person, size: 60, color: Colors.grey) : null,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => vm.getImage(),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppStyle.color.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Thay đổi ảnh đại diện",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // User info fields
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Thông tin cá nhân",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            buildTextField('Tên', vm.textEditingController[0], false),
                            buildTextField('Email', vm.textEditingController[1], true),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Mật khẩu',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextField(
                                    obscureText: true,
                                    readOnly: true,
                                    controller: vm.textEditingController[2],
                                    decoration: InputDecoration(
                                      suffixIcon: Container(
                                        margin: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () => vm.setCurrentIndex(2),
                                          tooltip: "Đổi mật khẩu",
                                        ),
                                      ),
                                      hintStyle: const TextStyle(color: Colors.grey),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Logout button
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Đăng xuất"),
                            content: const Text("Bạn có chắc chắn muốn đăng xuất?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Hủy"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  vm.logout();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text("Đăng xuất"),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Đăng xuất',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
      );
    }

    Widget buildChangePasswordPage() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppStyle.color.primary,
          title: const Text(
            'Mật khẩu',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => vm.setCurrentIndex(1),
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: vm.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Password change form header
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: const Text(
                          "Thay đổi mật khẩu",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      if (vm.isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        ),

                      const SizedBox(height: 10),

                      // Password fields with improved styling
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: vm.currentPasswordController,
                                obscureText: vm.obscureCurrentPassword,
                                decoration: InputDecoration(
                                  labelText: 'Mật khẩu cũ',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      vm.obscureCurrentPassword ? Icons.visibility : Icons.visibility_off,
                                    ),
                                    onPressed: () => vm.togglePasswordVisibility('current'),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập mật khẩu cũ';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: vm.newPasswordController,
                                obscureText: vm.obscureNewPassword,
                                decoration: InputDecoration(
                                  labelText: 'Mật khẩu mới',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      vm.obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                                    ),
                                    onPressed: () => vm.togglePasswordVisibility('new'),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập mật khẩu mới';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: vm.confirmPasswordController,
                                obscureText: vm.obscureConfirmPassword,
                                decoration: InputDecoration(
                                  labelText: 'Xác nhận mật khẩu',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  prefixIcon: const Icon(Icons.lock_reset),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      vm.obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                    ),
                                    onPressed: () => vm.togglePasswordVisibility('confirm'),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng xác nhận mật khẩu mới';
                                  }
                                  if (value != vm.newPasswordController.text) {
                                    return 'Mật khẩu không khớp';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Submit button with AnimatedBtnCommon
                      AnimatedBtnCommon(
                        height: 50,
                        width: constraints.maxWidth * 0.8,
                        color: AppStyle.color.primary,
                        enabled: !(vm.isLoading || authState.isLoading),
                        disabledColor: Colors.grey,
                        shadowDegree: ShadowDegree.light,
                        borderRadius: 10,
                        duration: 70,
                        onPressed: () {
                          if (vm.formKey.currentState!.validate()) {
                            vm.changePassword(
                              context,
                              vm.currentPasswordController.text,
                              vm.newPasswordController.text,
                            );
                          }
                        },
                        child: Center(
                          child: const Text(
                            'Đổi mật khẩu',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    // Render appropriate page based on current index
    switch (vm.currentIndex) {
      case 0:
        return buildProfilePage();
      case 1:
        return buildProfileEditPage();
      case 2:
        return buildChangePasswordPage();
      default:
        return buildProfilePage();
    }
  }
}
