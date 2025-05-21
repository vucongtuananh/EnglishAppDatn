import 'package:english_learning_app/common/animation_button_common.dart';
import 'package:english_learning_app/common/rive_animation.dart';
import 'package:english_learning_app/models/mapmodel.dart';
import 'package:english_learning_app/service/data_client_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../models/lessonmodel.dart';
import '../../utils/app_style.dart';
import '../../utils/constants.dart';
import '../../utils/enum_category.dart';
import '../../viewmodels/map_viewmodel.dart';

// Tạo provider cho ViewModel
final mapViewModelProvider = ChangeNotifierProvider((ref) => MapViewModel());

class MapScreen extends ConsumerWidget {
  final String mapId;

  const MapScreen({Key? key, required this.mapId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(mapViewModelProvider);

    vm.loadMap(mapId);

    return Consumer(
      builder: (context, ref, child) {
        ref.watch(mapViewModelProvider);
        if (vm.isLoading) {
          return Center(
            child: MyRiveAnimation(),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: _buildAppBar(vm),
            body: Column(
              children: [
                _buildHeaderWidget(vm),

                const SizedBox(height: 4),

                // Phần lessons có thể cuộn (Expanded để chiếm toàn bộ không gian còn lại)
                Expanded(
                  child: _buildLessons(
                    listLesson: vm.map!.lessons,
                    onLessonTap: (lessonId, level) => vm.onLessonTapped(
                      lessonId,
                      level,
                    ),
                    map: vm.map!,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  // AppBar widget
  AppBar _buildAppBar(MapViewModel viewModel) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            'images/flag_Viet_Nam.png',
            height: 35,
          ),
          _buildAppBarItem('images/fire.png', DataClient.user.currentUser!.streak.toString()),
          _buildAppBarItem('images/gem.png', viewModel.gemPoints.toString()),
          _buildAppBarItem('images/heart.png', viewModel.heartPoints.toString())
        ],
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      elevation: 0,
    );
  }

  // AppBar item widget
  Widget _buildAppBarItem(String image, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(image, height: 25),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Widget _buildHeaderWidget(MapViewModel vm) {
    // Handle color parsing
    Color mapColor;
    try {
      if (vm.map!.color != null && vm.map!.color!.startsWith('#')) {
        mapColor = HexColor(vm.map!.color!);
      } else {
        int? colorValue = int.tryParse(vm.map!.color!);
        if (colorValue != null) {
          mapColor = Color(colorValue);
        } else {
          mapColor = Colors.blue;
        }
      }
    } catch (e) {
      mapColor = Colors.blue;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 6, 0),
      child: LayoutBuilder(builder: (context, constraints) {
        return AnimatedBtnCommon(
          onPressed: () {
            context.pop();
          },
          color: mapColor,
          enabled: true,
          disabledColor: Colors.grey,
          shadowDegree: ShadowDegree.light,
          borderRadius: 16,
          width: constraints.maxWidth,
          height: 80,
          duration: 70,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phần ${vm.map!.id}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  CategoryType.fromCategoryName(vm.map!.categoryName)!.vietnameseName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Main lessons widget builder
  Widget _buildLessons({
    required List<LessonModel> listLesson,
    required Function(int, int) onLessonTap, // Keep Function(int) to pass lessonId
    required MapModel map,
  }) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 500),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        children: _customListLesson(_createLessonWidgets(listLesson, onLessonTap, map)),
      ),
    );
  }

  // Create individual lesson widgets
  List<Widget> _createLessonWidgets(List<LessonModel> lessons, Function(int, int) onLessonTap, MapModel map) {
    return lessons.map((lesson) {
      Color lessonColor = lesson.progress.isOpen ? AppStyle.fromHex(map.color ?? '#4CAF50') : Colors.grey;

      return _buildLesson(
        lessonId: lesson.id, // Use the actual lesson ID from model
        color: lessonColor,
        level: lesson.level,
        title: lesson.name,
        enable: lesson.progress.isOpen,
        onLessonTap: onLessonTap,
      );
    }).toList();
  }

  // Individual lesson widget
// Individual lesson widget with centered Lottie animation and additional side animation
  Widget _buildLesson({
    required int lessonId,
    required Color color,
    required String title,
    required bool enable,
    required int level,
    required Function(int, int) onLessonTap, // Changed to Function(int)
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Main lesson button with animation
        Column(
          children: [
            AnimatedBtnCommon(
              onPressed: () => onLessonTap(lessonId, level),
              color: color,
              enabled: enable,
              disabledColor: Colors.grey,
              shadowDegree: ShadowDegree.light,
              borderRadius: 90,
              width: 100,
              height: 100,
              duration: 70,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Circle background
                    CircleAvatar(
                      backgroundColor: enable ? color : Colors.grey,
                      radius: 45,
                    ),
                    // Centered Lottie animation
                    Lottie.asset(
                      'assets/animations/lego.json',
                      width: 75,
                      height: 75,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Lesson title
            SizedBox(
              width: 120,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: enable ? Colors.black87 : Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Column layout for lessons - Không thay đổi logic
  Widget _buildLessonColumn(List<Widget> list) {
    return IntrinsicHeight(
      // Thêm IntrinsicHeight để tránh overflow
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: list,
      ),
    );
  }

  // Create custom layout for lessons - Không thay đổi logic
  List<Widget> _customListLesson(List<Widget> lessons) {
    int countLeft = 0;
    int countRight = 0;
    int progress = -1;
    int count = 3;
    List<Widget> customList = [];

    // Giới hạn số lượng bài học để tránh overflow
    int maxLessons = lessons.length > 10 ? 10 : lessons.length;
    lessons = lessons.sublist(0, maxLessons);

    for (int index = 0; index < lessons.length; index++) {
      List<Widget> listLeft = [];
      List<Widget> listRight = [];

      if (index == 0 || index % 4 == 0) {
        customList.add(lessons[index]);
      } else {
        if (countLeft <= count && progress == -1) {
          listLeft.add(lessons[index]);
          countLeft++;
          for (int i = 0; i < countLeft; i++) {
            listLeft.add(const SizedBox(width: 60, height: 1));
          }
          if (countLeft == count) {
            countLeft = 0;
            // Xử lý an toàn trước khi xóa phần tử
            if (listLeft.length > count) {
              listLeft.removeAt(count);
            }
            if (listLeft.length > count - 1) {
              listLeft.removeAt(count - 1);
            }

            customList.add(_buildLessonColumn(listLeft));
            progress = 1;
            continue;
          }
          customList.add(_buildLessonColumn(listLeft));
        }
        if (countRight <= count && progress == 1) {
          for (int i = 0; i < countRight + 1; i++) {
            listRight.add(const SizedBox(width: 60, height: 1));
          }
          listRight.add(lessons[index]);
          countRight++;

          if (countRight == count) {
            countRight = 0;
            // Xử lý an toàn trước khi xóa phần tử
            if (listRight.isNotEmpty) {
              listRight.removeAt(0);
            }
            if (listRight.isNotEmpty) {
              listRight.removeAt(0);
            }
            progress = -1;
          }
          customList.add(_buildLessonColumn(listRight));
        }
      }
    }

    return customList;
  }
}
