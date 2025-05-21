import 'package:english_learning_app/common/rive_animation.dart';
import 'package:english_learning_app/models/topicmodel.dart';
import 'package:english_learning_app/router/app_route_name.dart';
import 'package:english_learning_app/utils/app_style.dart';
import 'package:english_learning_app/utils/enum_category.dart';
import 'package:english_learning_app/viewmodels/topic_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final topicProvider = ChangeNotifierProvider(
  (ref) => TopicViewModel(),
);

class TopicScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final vm = ref.read(topicProvider);
    Future(() => vm.load());
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(topicProvider);
        return Stack(children: [
          Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  "Tiếng Anh",
                  style: TextStyle(fontSize: AppStyle.dimen.fontSizeHeadline),
                ),
                centerTitle: true,
              ),
              body: ListView.builder(
                itemCount: vm.topics.length,
                itemBuilder: (context, index) {
                  final topic = vm.topics[index];

                  return StatisticsCard(
                    title: topic.category_name,
                    topic: topic,
                    index: index,
                    onEdit: (TopicModel result) {},
                    isMapUnlocked: true,
                    isCurrentMap: true,
                    progress: vm.getTopicProgress(topic.id!),
                  );
                },
              )),
          if (vm.isLoading)
            const Positioned.fill(
              child: Center(
                child: MyRiveAnimation(),
              ),
            ),
        ]);
      },
    );
  }

  Widget itemAppBar(String image, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(image, height: 25),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class StatisticsCard extends StatelessWidget {
  final String title;
  final TopicModel topic;
  final int index;
  final Function onEdit;
  final bool isMapUnlocked;
  final bool isCurrentMap;
  final int progress;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.topic,
    required this.index,
    required this.onEdit,
    required this.isMapUnlocked,
    required this.progress,
    required this.isCurrentMap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isMapUnlocked || isCurrentMap) {
          context.push(AppRouteName.map, extra: topic.id.toString());
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: isMapUnlocked || isCurrentMap ? Colors.white : Colors.grey,
          shadowColor: Colors.grey,
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                        child: Text(
                          "Phần ${index + 1}: ${CategoryType.fromId(topic.id!)!.vietnameseName}",
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Visibility(
                        // visible: isUser,
                        visible: true,
                        child: isMapUnlocked || isCurrentMap
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: ProgressIndicatorCustom(
                                  progress: progress,
                                  size: 20,
                                  displayText: '%',
                                ),
                              )
                            : Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), child: Text("Hoàn thành phần $index để mở khóa")),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ProgressIndicatorCustom({int? progress, double size = 5, String displayText = ''}) {
    {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: FAProgressBar(
          currentValue: progress!.toDouble(),
          progressColor: Colors.green,
          size: size,
          displayText: displayText,
          displayTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
          //  backgroundColor: Colors.transparent, // Xóa nền của thanh tiến trình
          borderRadius: BorderRadius.circular(6),
          // Làm tròn góc của progress bar bên trong
        ),
      );
    }
  }
}
