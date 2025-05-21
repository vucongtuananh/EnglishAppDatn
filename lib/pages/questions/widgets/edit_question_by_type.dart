import 'dart:math';

import 'package:english_learning_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditQuestionByType extends ConsumerStatefulWidget {
  final bool add;
  final String mapId;
  final String topicId;
  final String lessonId;
  final dynamic question;
  final String title;
  final String type;
  final String typeOfQuestion;
  final int index;
  final String questionId;

  const EditQuestionByType({super.key, this.question, required this.title, required this.mapId, required this.topicId, required this.lessonId, required this.type, this.index = 0, required this.add, required this.questionId, required this.typeOfQuestion});

  @override
  ConsumerState<EditQuestionByType> createState() => _EditQuestionByTypeState();
}

class _EditQuestionByTypeState extends ConsumerState<EditQuestionByType> {
  final List<TextEditingController> textEditList = List.generate(10, (index) => TextEditingController());
  final List<dynamic> images = [null, null, null, null];
  final picker = ImagePicker();
  bool isLoading = false;
  String selectedValue = '';
  List<String> optionType = [];
  List<String> optionTypeCodeOfMatchingQuestion = [matchingPairSoundQuestion, matchingPairWordQuestion];
  Random random = Random();
  List<String> optionTypeCodeOfTranselationQuestion = [transerlationReadQueston, transerlationReadQueston];
  String typesection = '';

  // Rest of your methods remain the same

  @override
  void initState() {
    super.initState();
    typesection = widget.add ? widget.typeOfQuestion : widget.question.typeOfQuestion;
    // Rest of your initState code remains the same
  }

  @override
  Widget build(BuildContext context) {
    switch (typesection) {
      case completeConversationQuestion:
        // Your case implementations remain mostly the same
        // Just change the viewModel reference
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Your UI components remain the same
                  // ...
                  ElevatedButton(
                    onPressed: () async {
                      // Your logic remains the same
                      // Just use the ref.read(mapViewModelProvider.notifier) for viewModel
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      widget.add ? ' Thêm câu hỏi' : 'Lưu thay đổi',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      // Other cases remain the same with just the viewModel reference change

      default:
        return const Scaffold(
          body: Center(
            child: Text("Không có câu hỏi nào loại này "),
          ),
        );
    }
  }
}
