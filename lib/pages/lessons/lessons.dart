// import 'package:english_learning_app/models/lessonmodel.dart';
// import 'package:english_learning_app/router/app_route_name.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';

// import '../../common/animation_button_common.dart';
// import '../../utils/app_style.dart';
// import '../../utils/constants.dart';

// class Lessons extends StatefulWidget {
//   final List<LessonModel> listLesson;
//   const Lessons({
//     super.key,
//     required this.listLesson,
//   });

//   @override
//   State<Lessons> createState() => _LessonsState();
// }

// class _LessonsState extends State<Lessons> {
//   List<Widget> listLesson = [];
//   List<String> completedLesson = [];

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     listLesson = customListLesson(getListLesson(widget.listLesson));

//     return Column(children: listLesson);
//   }

//   static Widget columnLesson(List<Widget> list) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: list,
//     );
//   }

//   Widget lesson({required int lessonId, required String imageUrl, required Color color, required String title, required bool enable}) {
//     return Column(
//       children: [
//         AnimatedBtnCommon(
//           onPressed: () {
//             context.push(AppRouteName.question);
//           },
//           color: color,
//           enabled: enable,
//           disabledColor: Colors.grey,
//           shadowDegree: ShadowDegree.light,
//           borderRadius: 90,
//           width: 100,
//           height: 100,
//           duration: 0,
//           child: CircleAvatar(
//             backgroundColor: enable ? color : Colors.grey,
//             radius: 80,
//             child: Lottie.asset(
//               'assets/animations/lego.json',
//               width: 200,
//               height: 200,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }

//   List<Widget> getListLesson(List<LessonModel> listLesson) {
//     List<Widget> listLessonWidget = [];

//     for (int i = 0; i < listLesson.length; i++) {
//       Color lessonColor = listLesson[i].progress.isOpen ? AppStyle.fromHex(.color) : Colors.grey;
//       listLessonWidget.add(lesson(
//         imageUrl: "",
//         lessonId: i,
//         color: lessonColor,
//         title: listLesson[i].name,
//         enable: listLesson[i].progress.isOpen,
//       ));
//     }

//     return listLessonWidget;
//   }

//   static List<Widget> customListLesson(List<Widget> lessons) {
//     int countLeft = 0;
//     int countRight = 0;
//     int progress = -1;
//     int count = 3;
//     List<Widget> customList = [];
//     for (int index = 0; index < lessons.length; index++) {
//       List<Widget> listLeft = [];
//       List<Widget> listRight = [];
//       if (index == 0 || index % 4 == 0) {
//         customList.add(lessons[index]);
//       } else {
//         if (countLeft <= count && progress == -1) {
//           listLeft.add(lessons[index]);
//           countLeft++;
//           for (int i = 0; i < countLeft; i++) {
//             listLeft.add(Container());
//           }
//           if (countLeft == count) {
//             countLeft = 0;
//             listLeft.removeAt(count);
//             listLeft.removeAt(count - 1);

//             customList.add(columnLesson(listLeft));
//             progress = 1;
//             continue;
//           }
//           customList.add(columnLesson(listLeft));
//         }
//         if (countRight <= count && progress == 1) {
//           for (int i = 0; i < countRight + 1; i++) {
//             listRight.add(Container());
//           }
//           listRight.add(lessons[index]);
//           countRight++;

//           if (countRight == count) {
//             countRight = 0;
//             listRight.removeAt(0);
//             listRight.removeAt(0);
//             progress = -1;
//           }
//           customList.add(columnLesson(listRight));
//         }
//       }
//     }

//     return customList;
//   }
// }
