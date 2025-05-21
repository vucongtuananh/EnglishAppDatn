import 'package:english_learning_app/models/mapmodel.dart';
import 'package:english_learning_app/models/viewmodel_base.dart';
import 'package:english_learning_app/router/app_route_name.dart';
import 'package:english_learning_app/service/map_service.dart';
import 'package:english_learning_app/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MapViewModel extends ViewModelBase {
  // Thay đổi từ List<TopicModel> thành một TopicModel duy nhất
  MapModel _map = MapModel(id: 0, categoryName: '', lessons: [], createdAt: '', updatedAt: '', deletedAt: '');
  int currentPage = 1;
  int? mapIdInternal;

  // Phone number related fields
  final TextEditingController phoneController = TextEditingController();
  String? phoneError;
  bool phoneFocus = false;

  // Getter cho map
  MapModel? get map => _map;

  // // Thêm các biến quản lý trạng thái
  // String? _currentTopicId;
  // String? _currentMapId;
  // bool _isTopicUnlocked = false;
  // Map<String, bool> _unlockedMaps = {};
  //
  // Điểm số cho người dùng
  int firePoints = 100;
  int gemPoints = 50;
  int heartPoints = 5;

  void setPhoneFocus(bool focus) {
    phoneFocus = focus;
    notifyListeners();
  }

  void validatePhone(String value) {
    if (value.isEmpty) {
      phoneError = 'Số điện thoại không được để trống';
    } else {
      // Format phone number
      String formattedPhone = AppUtil.updatePhone(value);

      // Validate phone number format
      if (!RegExp(r'^0[0-9]{9}$').hasMatch(formattedPhone)) {
        phoneError = 'Số điện thoại không hợp lệ';
      } else {
        phoneError = null;
      }

      // Update controller with formatted value
      if (formattedPhone != value) {
        phoneController.text = formattedPhone;
        phoneController.selection = TextSelection.fromPosition(
          TextPosition(offset: formattedPhone.length),
        );
      }
    }
    notifyListeners();
  }

  // Phương thức để tải map dựa vào mapId sử dụng dữ liệu giả
  Future<void> loadMap(String mapId) async {
    mapIdInternal = int.tryParse(mapId);
    currentPage = 1;

    try {
      isLoading = true;
      notifyListeners();
      _map = await MapService.getListMap(categoryId: mapIdInternal);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error loading map: $e");
      // Handle error appropriately
      isLoading = false;
      notifyListeners();
    }
  }

  // Thay đổi phương thức load để sử dụng dữ liệu giả
  void load() {
    // Không gọi API mà sử dụng dữ liệu giả
    // loadTopics(_currentMapId ?? "1");
  }

  // Kiểm tra xem topic đã được mở khóa hoàn toàn chưa
  // bool isTopicFullyUnlocked(String topicId) {
  //   return _isTopicUnlocked;
  // }

  // Xử lý sự kiện khi người dùng nhấn vào một bài học
  void onLessonTapped(int lessonId, int level) {
    AppUtil.navigatorKey.currentContext!.push(AppRouteName.question, extra: {
      'lessonId': lessonId.toString(),
      'level': level.toString(),
    });
  }

  // // Xử lý khi hoàn thành một bài học
  // void completeLesson(String lessonId) {
  //   if (_topic != null) {
  //     final lessonIndex = _topic!.lessons.indexWhere((lesson) => lesson.id == lessonId);
  //     if (lessonIndex != -1 && lessonIndex < _topic!.lessons.length - 1) {
  //       // Mở khóa bài học tiếp theo
  //       _topic!.lessons[lessonIndex + 1].isEnable = true;
  //     }
  //
  //     // Thưởng điểm
  //     _firePoints += 10;
  //     _gemPoints += 5;
  //     notifyListeners();
  //   }
  // }

  // // Tiêu thụ tài nguyên (điểm) khi người dùng sử dụng
  // bool spendResources({int fire = 0, int gems = 0, int hearts = 0}) {
  //   // Kiểm tra xem có đủ tài nguyên không
  //   if (_firePoints < fire || _gemPoints < gems || _heartPoints < hearts) {
  //     return false; // Không đủ tài nguyên
  //   }
  //
  //   // Trừ tài nguyên
  //   _firePoints -= fire;
  //   _gemPoints -= gems;
  //   _heartPoints -= hearts;
  //
  //   notifyListeners();
  //   return true; // Đã chi tiêu thành công
  // }

  // Reset trạng thái (khi cần)
  // void resetState() {
  //   _currentTopicId = null;
  //   _currentMapId = null;
  //   _isTopicUnlocked = false;
  //   _unlockedMaps.clear();
  //   _topic = null;
  //   currentPage = 1;
  //
  //   notifyListeners();
  // }

  Future<void> fetchMap() async {
    if (mapIdInternal != null) {
      await loadMap(mapIdInternal.toString());
    }
  }

  Future<void> updateMap(MapModel updatedMap) async {
    _map = updatedMap;
    notifyListeners();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
