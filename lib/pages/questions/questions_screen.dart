import 'dart:convert';
import 'dart:io';
import 'dart:math' show min, max;

import 'package:audioplayers/audioplayers.dart';
import 'package:english_learning_app/common/animation_button_common.dart';
import 'package:english_learning_app/helper/audio_helper.dart';
import 'package:english_learning_app/models/pronunciation_result.dart';
import 'package:english_learning_app/models/question_model.dart';
import 'package:english_learning_app/router/app_route_name.dart';
import 'package:english_learning_app/utils/app_style.dart';
import 'package:english_learning_app/utils/app_util.dart';
import 'package:english_learning_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../common/rive_animation.dart';
import '../../models/pronunciation_mistake.dart';
import '../../service/whisper_service.dart';
import '../../viewmodels/question_viewmodel.dart';

final _questionProvider = ChangeNotifierProvider((ref) => QuestionViewModel());

class QuestionScreen extends ConsumerWidget {
  final PageController _pageController = PageController();
  final int lessonId;
  final int level;
  QuestionScreen({super.key, required this.lessonId, required this.level});

  @override
  Widget build(BuildContext context, ref) {
    var vm = ref.read(_questionProvider);
    Future(
      () {
        vm.loadQuestions(lessonId: lessonId);
      },
    );

    return Consumer(builder: (context, ref, _) {
      ref.watch(_questionProvider);

      return Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: _buildAppbar(vm),
            body: (!vm.hasQuestions)
                ? const Center(child: Text('Không có câu hỏi nào'))
                : Column(
                    children: [
                      // PageView hiển thị câu hỏi
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            vm.currentIndex = index;
                            HapticFeedback.lightImpact();
                          },
                          itemCount: vm.totalQuestions,
                          itemBuilder: (context, index) {
                            final question = vm.questions![index]; // Đã thay đổi: không ép kiểu

                            // Thay đổi: dùng type thay vì is để kiểm tra loại câu hỏi
                            if (question.type == 'sort') {
                              return _buildSortQuestion(question, index, vm);
                            } else if (question.type == 'multiple_choice') {
                              return _buildMultiChoiceQuestion(question, index, vm);
                            } else if (question.type == 'text') {
                              return PronunciationQuestionWidget(
                                question: question,
                                index: index,
                                viewModel: vm,
                              );
                            }

                            return const Center(
                              child: Text('Loại câu hỏi không được hỗ trợ'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
          if (vm.isLoading)
            const Positioned.fill(
              child: Center(
                child: MyRiveAnimation(),
              ),
            ),
        ],
      );
    });
  }

  AppBar _buildAppbar(QuestionViewModel vm) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.close, color: Colors.black87),
        onPressed: () {
          // Hiển thị BottomSheet khi nhấn nút X
          _showExitConfirmationSheet(vm);
        },
      ),
      title: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
        height: 12, // Chiều cao của thanh tiến trình
        width: double.infinity, // Chiều rộng tối đa
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: vm.progressValue,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              AppStyle.color.primary,
            ),
          ),
        ),
      ),
      titleSpacing: 0, // Loại bỏ khoảng cách mặc định bên cạnh title
      leadingWidth: 40, // Giảm width của leading để tăng khoảng trống cho title
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Image.asset('images/heart.png', height: 25),
        ),
      ],
    );
  }

// Hàm hiển thị BottomSheet xác nhận thoát
  _showExitConfirmationSheet(QuestionViewModel vm) {
    showModalBottomSheet(
      context: AppUtil.navigatorKey.currentContext!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/sad_dog.json',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),

              // Văn bản thông báo
              Text(
                "Đợi chút, bạn chỉ cần 1 phút để hoàn thành bài học này thôi!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              // Nút "Tiếp tục học" sử dụng AnimatedBtnCommon
              LayoutBuilder(builder: (context, constraints) {
                return AnimatedBtnCommon(
                  color: AppStyle.color.primary,
                  width: constraints.maxWidth * 0.8,
                  height: 50,
                  onPressed: () {
                    context.pop();
                  },
                  child: Center(
                    child: Text(
                      'Tiếp tục học',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 4),

              TextButton(
                onPressed: () {
                  vm.resetAllState();
                  context.pop();
                  context.pop();
                },
                child: Text(
                  'Thoát',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Xây dựng giao diện cho câu hỏi sắp xếp
  Widget _buildSortQuestion(Question question, int index, QuestionViewModel vm) {
    final bool isSubmitted = vm.sortQuestionSubmitted[index] ?? false;
    final bool isCorrect = vm.isSortCorrect(index);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          // Hiển thị loại câu hỏi
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Dịch câu này',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppStyle.dimen.fontSizeTitleConversation),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh Lottie ở bên trái
              Lottie.asset(
                'assets/animations/sad_dog.json',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),

              // Khung chat dạng bong bóng bên phải
              Expanded(
                child: Stack(
                  children: [
                    // Khung chat chính
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nội dung của khung chat
                          Text(
                            question.description ?? "Hãy sắp xếp các từ dưới đây thành một câu hoàn chỉnh.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Phần mũi tên nối từ khung chat đến hình ảnh
                    Positioned(
                      left: 2,
                      top: 20,
                      child: CustomPaint(
                        size: const Size(14, 12),
                        painter: ChatBubbleArrowPainter(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Phần hiển thị câu trả lời đã chọn - REDESIGNED với nút bấm thay vì text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12.0),
              color: isSubmitted ? (isCorrect ? Colors.green.shade50 : Colors.red.shade50) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(minHeight: 150),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double maxWidth = constraints.maxWidth - 30; // Để lại margin
                final List<String> words = vm.sortQuestionAnswers[index] ?? [];
                List<Widget> lineWidgets = [];

                if (words.isEmpty) {
                  // Nếu chưa có từ nào được chọna
                  for (int i = 0; i < 3; i++) {
                    lineWidgets.add(Column(
                      children: [
                        SizedBox(height: i == 0 ? 30 : 40),
                        Container(
                          height: 1,
                          color: Colors.grey.shade400,
                          width: double.infinity,
                        ),
                      ],
                    ));
                  }

                  // Thêm thông báo
                  lineWidgets.add(Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Nhấn vào từng từ bên dưới để sắp xếp câu',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ));
                } else {
                  // Nếu có từ được chọn, chia từ thành các dòng để hiển thị
                  double currentLineWidth = 0;
                  List<List<String>> lines = [[]];
                  int currentLine = 0;

                  // Phân chia từ vào các dòng
                  for (String word in words) {
                    // Ước tính độ rộng của từ (khoảng 12px mỗi ký tự + 32px padding)
                    double wordWidth = word.length * 12.0 + 16;

                    if (currentLineWidth + wordWidth > maxWidth && currentLineWidth > 0) {
                      // Nếu thêm từ này sẽ vượt quá chiều rộng, tạo dòng mới
                      currentLine++;
                      lines.add([]);
                      currentLineWidth = 0;
                    }

                    lines[currentLine].add(word);
                    currentLineWidth += wordWidth + 12; // Thêm khoảng cách giữa các từ
                  }

                  // Tạo widget cho mỗi dòng
                  for (int i = 0; i < max(3, lines.length); i++) {
                    if (i < lines.length) {
                      // Dòng có từ
                      lineWidgets.add(Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Wrap(
                              spacing: 2,
                              alignment: WrapAlignment.start,
                              children: lines[i].map((word) {
                                double buttonWidth = max(50.0, min(word.length * 10.0 + 24, 120.0));

                                return AnimatedBtnCommon(
                                  color: isSubmitted ? (isCorrect ? Colors.green.shade100 : Colors.red.shade100) : Colors.grey.shade50,
                                  disabledColor: isSubmitted ? (isCorrect ? Colors.green.shade200 : Colors.red.shade200) : Colors.grey.shade50,
                                  enabled: !isSubmitted,
                                  height: 32, // Nhỏ hơn các nút bên dưới một chút
                                  width: buttonWidth,
                                  borderRadius: 8,
                                  elevation: 3,
                                  shadowDegree: ShadowDegree.light,
                                  duration: 100,
                                  onPressed: () {
                                    if (!isSubmitted) {
                                      vm.removeWordFromAnswer(index, word);
                                    }
                                    vm.speakWord(word);
                                  },
                                  child: Center(
                                    child: Text(
                                      word,
                                      style: TextStyle(
                                        color: isSubmitted ? (isCorrect ? Colors.green.shade700 : Colors.red.shade700) : Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.shade400,
                            width: double.infinity,
                          ),
                          const SizedBox(height: 20), // Khoảng cách giữa các dòng
                        ],
                      ));
                    } else {
                      // Dòng trống
                      lineWidgets.add(Column(
                        children: [
                          const SizedBox(height: 30), // Khoảng trống cho chữ
                          Container(
                            height: 1,
                            color: Colors.grey.shade400,
                            width: double.infinity,
                          ),
                          SizedBox(height: i < 2 ? 20 : 0), // Khoảng cách giữa các dòng
                        ],
                      ));
                    }
                  }
                }

                return Column(children: lineWidgets);
              },
            ),
          ),

          const SizedBox(height: 16),

          // Hiển thị kết quả nếu đã nộp
          if (isSubmitted)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    isCorrect ? 'Chính xác!' : 'Chưa chính xác',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Đáp án đúng: ${question.title}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

          // const SizedBox(height: 8),

          // Các từ để lựa chọn
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12.0,
                  runSpacing: 16.0,
                  alignment: WrapAlignment.center,
                  children: (vm.sortQuestionWordMaps[index] ?? []).map((word) {
                    double buttonWidth = max(60.0, min(word.length * 12.0 + 24, 150.0));

                    // Kiểm tra xem từ này đã được chọn chưa
                    // final bool isSelected = vm.sortQuestionAnswers[index]?.contains(word) ?? false;

                    // Nếu từ chưa được chọn, hiển thị nút có thể nhấn
                    return AnimatedBtnCommon(
                      color: Colors.grey.shade50,
                      disabledColor: Colors.grey.shade200,
                      enabled: !isSubmitted,
                      height: 38,
                      width: buttonWidth,
                      borderRadius: 8,
                      elevation: 4,
                      shadowDegree: ShadowDegree.light,
                      duration: 100,
                      onPressed: () {
                        vm.speakWord(word);

                        if (!isSubmitted) {
                          vm.addWordToAnswer(index, word);
                        }
                      },
                      child: Center(
                        child: Text(
                          word,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Nút kiểm tra hoặc tiếp tục
          _buildCheckContinueButton(
            isSubmitted: isSubmitted,
            isEnabled: vm.sortQuestionAnswers[index]?.isNotEmpty ?? false,
            index: index,
            onSubmit: () => vm.submitSortAnswer(index),
            onProgress: vm.increaseProgressValue,
            onNextPage: (idx) {
              if (idx < vm.totalQuestions - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                // Tính toán các giá trị kết quả
                int score = 29; // tổng điểm
                int percent = 82; // phần trăm đúng
                String time = "2:31"; // thời gian hoàn thành

                AppUtil.navigatorKey.currentContext!.pushReplacement(
                  AppRouteName.result,
                  extra: {
                    'score': score,
                    'percent': percent,
                    'time': time,
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Xây dựng giao diện cho câu hỏi trắc nghiệm
  Widget _buildMultiChoiceQuestion(Question question, int index, QuestionViewModel vm) {
    final bool isSubmitted = vm.multiChoiceSubmitted[index] ?? false;
    final String? selectedChoice = vm.selectedChoices[index];
    final bool isCorrect = vm.isMultiChoiceCorrect(index);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hiển thị loại câu hỏi - UI code
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Chọn đáp án đúng',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppStyle.dimen.fontSizeTitleConversation),
            ),
          ),

          const SizedBox(height: 12),

          // Câu hỏi - UI code
          Text(
            question.questionText ?? '', // Thêm null safety
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          // Các lựa chọn - UI sử dụng data từ ViewModel
          Expanded(
            child: ListView.builder(
              itemCount: question.options?.length ?? 0, // Thêm null safety
              itemBuilder: (context, optionIndex) {
                if (question.options == null || question.options!.isEmpty) {
                  return const SizedBox(); // Trả về widget trống nếu không có options
                }

                final option = question.options!.entries.elementAt(optionIndex);
                final String key = option.key;
                final String value = option.value;

                final bool isSelected = key == selectedChoice;
                final bool isCorrectAnswer = key == question.correctAnswer;

                return _buildOptionItemInMultiOption(
                  key: key,
                  value: value,
                  isSelected: isSelected,
                  isSubmitted: isSubmitted,
                  isCorrectAnswer: isCorrectAnswer,
                  onTap: () => vm.selectChoice(index, key),
                );
              },
            ),
          ),

          if (isSubmitted)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCorrect ? Colors.green : Colors.red,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isCorrect ? 'Chính xác!' : 'Chưa chính xác',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Giải thích: ${question.explain}',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Nút kiểm tra hoặc tiếp tục
          _buildCheckContinueButton(
            isSubmitted: isSubmitted,
            isEnabled: selectedChoice != null,
            index: index,
            onSubmit: () => vm.submitMultiChoiceAnswer(index),
            onProgress: vm.increaseProgressValue,
            onNextPage: (idx) {
              if (idx < vm.totalQuestions - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                // Tính toán các giá trị kết quả
                int score = 29; // tổng điểm
                int percent = 82; // phần trăm đúng
                String time = "2:31"; // thời gian hoàn thành

                AppUtil.navigatorKey.currentContext!.pushReplacement(
                  AppRouteName.result,
                  extra: {
                    'score': score,
                    'percent': percent,
                    'time': time,
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Xây dựng giao diện cho câu hỏi phát âm
  Widget PronunciationQuestionWidget({
    required Question question,
    required int index,
    required QuestionViewModel viewModel,
  }) {
    final bool isRecording = viewModel.isRecording[index] ?? false;
    final bool hasRecorded = viewModel.hasRecorded[index] ?? false;
    final bool isPlaying = viewModel.isPlaying[index] ?? false;
    final bool isChecking = viewModel.isChecking[index] ?? false;
    final bool hasResult = viewModel.hasResult(index);
    final Duration duration = viewModel.recordDurations[index] ?? Duration.zero;
    final String formattedDuration = viewModel.formatDuration(duration);
    final PronunciationResult? pronunciationResult = viewModel.pronunciationResults[index];
    final String errorMessage = viewModel.errorMessages[index] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hiển thị loại câu hỏi
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Text(
            'Câu hỏi phát âm',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 24),

        // Hiển thị câu cần phát âm
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade50,
          ),
          child: Column(
            children: [
              Text(
                question.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                question.ipa ?? '',
                style: const TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 18,
                  color: Colors.blue,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Khu vực hiển thị kết quả đánh giá nếu có
        if (hasResult && pronunciationResult != null)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hiển thị tỷ lệ lỗi
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getScoreColor(pronunciationResult.mistakePercentage),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Kết quả đánh giá',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${(100 - pronunciationResult.mistakePercentage).toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: _getScoreColor(pronunciationResult.mistakePercentage),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                _getScoreFeedback(pronunciationResult.mistakePercentage),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Hiển thị văn bản phiên âm
                  Text(
                    'Phiên âm:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      pronunciationResult.text,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  // Hiển thị các lỗi cụ thể
                  if (pronunciationResult.mistakes.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Lỗi phát âm:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...pronunciationResult.mistakes.map((mistake) => _buildMistakeItem(mistake)),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        else if (isChecking)
          // Hiển thị loading khi đang đánh giá
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Đang đánh giá phát âm...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          )
        else if (errorMessage.isNotEmpty)
          // Hiển thị lỗi nếu có
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Đã xảy ra lỗi:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          // Hiển thị trạng thái ghi âm khi chưa có kết quả
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Đồng hồ ghi âm
                if (isRecording || hasRecorded)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isRecording ? Colors.red.shade50 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: isRecording ? Colors.red : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      formattedDuration,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isRecording ? Colors.red : Colors.black87,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Biểu tượng trạng thái
                Icon(
                  isRecording
                      ? Icons.mic
                      : hasRecorded
                          ? isPlaying
                              ? Icons.volume_up
                              : Icons.mic_none
                          : Icons.mic_none,
                  size: 80,
                  color: isRecording
                      ? Colors.red
                      : hasRecorded
                          ? isPlaying
                              ? Colors.blue
                              : Colors.green
                          : Colors.grey,
                ),

                const SizedBox(height: 16),

                // Thông báo trạng thái
                Text(
                  isRecording
                      ? 'Đang ghi âm...'
                      : hasRecorded && isPlaying
                          ? 'Đang phát...'
                          : hasRecorded
                              ? 'Đã ghi âm xong'
                              : 'Nhấn nút bên dưới để bắt đầu thu âm',
                  style: TextStyle(
                    fontSize: 16,
                    color: isRecording
                        ? Colors.red
                        : isPlaying
                            ? Colors.blue
                            : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Hiển thị visualizer khi đang ghi âm
                if (isRecording)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(10, (barIndex) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 4,
                          height: (20 + (barIndex % 5) * 4).toDouble(),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
          ),

        // Các nút điều khiển
        Column(
          children: [
            // Nút phát lại bản ghi
            if (hasRecorded && !hasResult)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      isPlaying ? Icons.stop : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    label: Text(
                      isPlaying ? 'Dừng phát' : 'Nghe lại',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () {
                      if (isPlaying) {
                        viewModel.stopPlayback();
                      } else {
                        viewModel.playRecording(index);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPlaying ? Colors.red : Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

            // Nút nghe từ mẫu
            if (hasResult && pronunciationResult?.mistakes.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.volume_up, color: Colors.white),
                    label: const Text(
                      'Nghe từ mẫu',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () {
                      viewModel.speakWord(question.title);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

            // Nút luyện tập từ sai
            if (hasResult && pronunciationResult?.mistakes.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.mic, color: Colors.white),
                    label: const Text(
                      'Luyện tập từ sai',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () {
                      // Hiển thị bottom sheet với danh sách từ sai
                      _showPracticeBottomSheet(question.title);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

            // Nút thu âm hoặc dừng thu âm
            if (!hasResult || errorMessage.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(
                    isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                  ),
                  label: Text(
                    isRecording
                        ? 'Dừng thu âm'
                        : hasRecorded
                            ? 'Thu âm lại'
                            : 'Bắt đầu thu âm',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: isChecking ? null : () => viewModel.toggleRecording(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRecording ? Colors.red : Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Thay đổi phần nút cuối cùng của _buildPronunciationQuestion
            _buildCheckContinueButton(
              isSubmitted: hasRecorded,
              isEnabled: hasRecorded && !isChecking,
              index: index,
              onSubmit: () {
                // Nếu đang phát, dừng lại
                if (isPlaying) {
                  viewModel.stopPlayback();
                }
              },
              onProgress: () {}, // Không tăng tiến trình cho câu hỏi phát âm
              onNextPage: (idx) {
                if (idx < viewModel.totalQuestions - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // Tính toán các giá trị kết quả
                  int score = 29; // tổng điểm
                  int percent = 82; // phần trăm đúng
                  String time = "2:31"; // thời gian hoàn thành

                  AppUtil.navigatorKey.currentContext!.pushReplacement(
                    AppRouteName.result,
                    extra: {
                      'score': score,
                      'percent': percent,
                      'time': time,
                    },
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

// Widget để hiển thị một lỗi phát âm
  Widget _buildMistakeItem(PronunciationMistake mistake) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Từ cần phát âm: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: mistake.expected,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Phát âm của bạn: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: mistake.transcribed,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vị trí: từ thứ ${mistake.position + 1}',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Nút nghe lại từ
              ElevatedButton.icon(
                onPressed: () {
                  AudioHelper.speak(mistake.expected);
                },
                icon: const Icon(Icons.volume_up, size: 20),
                label: const Text('Nghe lại'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                  foregroundColor: Colors.blue.shade900,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
              const SizedBox(width: 8),
              // Nút luyện tập lại
              ElevatedButton.icon(
                onPressed: () {
                  _showPracticeBottomSheet(mistake.expected);
                },
                icon: const Icon(Icons.mic, size: 20),
                label: const Text('Luyện tập'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade100,
                  foregroundColor: Colors.orange.shade900,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPracticeBottomSheet(String word) {
    showModalBottomSheet(
      context: AppUtil.navigatorKey.currentContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: PracticePronunciationSheet(
          word: word,
          onClose: () {
            Navigator.pop(context);
          },
          onPracticeComplete: (word) {
            // Không cần làm gì khi hoàn thành luyện tập
            // Trạng thái của câu hỏi chính sẽ được giữ nguyên
          },
        ),
      ),
    );
  }

// Hàm để lấy màu dựa trên tỷ lệ lỗi
  Color _getScoreColor(double mistakePercentage) {
    if (mistakePercentage <= 5) {
      return Colors.green;
    } else if (mistakePercentage <= 15) {
      return Colors.blue;
    } else if (mistakePercentage <= 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

// Hàm để lấy phản hồi dựa trên tỷ lệ lỗi
  String _getScoreFeedback(double mistakePercentage) {
    if (mistakePercentage <= 5) {
      return 'Tuyệt vời! Phát âm của bạn rất chính xác.';
    } else if (mistakePercentage <= 15) {
      return 'Khá tốt! Phát âm của bạn có một vài lỗi nhỏ.';
    } else if (mistakePercentage <= 30) {
      return 'Cần cải thiện! Phát âm của bạn còn một số lỗi.';
    } else {
      return 'Cần luyện tập nhiều hơn! Phát âm của bạn còn nhiều lỗi.';
    }
  }

  // Thêm hàm này vào bên trong class QuestionScreen
  Widget _buildCheckContinueButton({
    required bool isSubmitted,
    required bool isEnabled,
    required int index,
    required Function() onSubmit,
    required Function() onProgress,
    required Function(int) onNextPage,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBtnCommon(
          color: isEnabled ? AppStyle.color.primary : Colors.grey,
          disabledColor: Colors.grey,
          enabled: isEnabled,
          height: 48,
          width: constraints.maxWidth * 0.9,
          borderRadius: 12,
          elevation: 8,
          duration: 150,
          shadowDegree: ShadowDegree.light,
          onPressed: () {
            if (isSubmitted) {
              onNextPage(index);
            } else {
              onSubmit();
              onProgress();
            }
          },
          child: Center(
            child: Text(
              isSubmitted ? 'Tiếp tục' : 'Kiểm tra',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionItemInMultiOption({
    required String key,
    required String value,
    required bool isSelected,
    required bool isSubmitted,
    required bool isCorrectAnswer,
    required Function() onTap,
  }) {
    // Xác định màu nền cho lựa chọn
    Color backgroundColor;
    if (isSubmitted) {
      if (isCorrectAnswer) {
        backgroundColor = Colors.green.shade100;
      } else if (isSelected && !isCorrectAnswer) {
        backgroundColor = Colors.red.shade100;
      } else {
        backgroundColor = Colors.white;
      }
    } else {
      backgroundColor = isSelected ? Colors.blue.shade100 : Colors.white;
    }

    // Sử dụng Container bọc bên ngoài để có kích thước xác định và margin
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Đảm bảo width có giá trị xác định từ constraints
          return AnimatedBtnCommon(
            color: backgroundColor,
            disabledColor: backgroundColor,
            enabled: !isSubmitted,
            height: 64, // Chiều cao cố định cho mỗi item
            width: constraints.maxWidth, // Lấy chiều rộng từ parent container
            borderRadius: 8,
            elevation: isSelected ? 4 : 4, // Độ cao thấp hơn cho button
            shadowDegree: ShadowDegree.light,
            duration: 100,
            onPressed: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: isSelected ? Colors.blue : Colors.grey,
                    foregroundColor: Colors.white,
                    child: Text(key.toUpperCase()),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (isSubmitted && isCorrectAnswer) const Icon(Icons.check_circle, color: Colors.green),
                  if (isSubmitted && isSelected && !isCorrectAnswer) const Icon(Icons.cancel, color: Colors.red),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Thêm class này vào cùng file hoặc tạo file riêng
class ChatBubbleArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path()
      ..moveTo(size.width, 0) // Điểm bắt đầu ở góc phải trên
      ..lineTo(0, size.height / 2) // Điểm giữa bên trái (mũi tên)
      ..lineTo(size.width, size.height) // Điểm cuối ở góc phải dưới
      ..close();

    // Vẽ phần fill
    canvas.drawPath(path, paint);

    // Vẽ phần viền
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PracticePronunciationSheet extends StatefulWidget {
  final String word;
  final VoidCallback onClose;
  final Function(String) onPracticeComplete;

  const PracticePronunciationSheet({
    super.key,
    required this.word,
    required this.onClose,
    required this.onPracticeComplete,
  });

  @override
  State<PracticePronunciationSheet> createState() => _PracticePronunciationSheetState();
}

class _PracticePronunciationSheetState extends State<PracticePronunciationSheet> {
  bool isRecording = false;
  bool hasRecorded = false;
  bool isPlaying = false;
  bool isChecking = false;
  Duration recordDuration = Duration.zero;
  String? recordedFilePath;
  DateTime? recordingStartTime;
  String? errorMessage;
  PronunciationResult? result;

  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();
  final _whisperService = WhisperService();

  @override
  void initState() {
    super.initState();
    // Phát âm từ khi mở bottom sheet
    AudioHelper.speak(widget.word);
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/practice_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: filePath,
        );

        setState(() {
          isRecording = true;
          hasRecorded = false;
          isPlaying = false;
          errorMessage = null;
          result = null;
          recordedFilePath = filePath;
          recordingStartTime = DateTime.now();
        });

        _startDurationTimer();
      } else {
        setState(() {
          errorMessage = 'Không có quyền truy cập microphone';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi khi bắt đầu ghi âm: $e';
      });
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        isRecording = false;
        hasRecorded = true;
      });

      // Tự động kiểm tra phát âm sau khi dừng ghi âm
      await _checkPronunciation();
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi khi dừng ghi âm: $e';
      });
    }
  }

  Future<void> _playRecording() async {
    try {
      if (recordedFilePath != null && File(recordedFilePath!).existsSync()) {
        setState(() {
          isPlaying = true;
        });

        await _audioPlayer.play(DeviceFileSource(recordedFilePath!));

        // Lắng nghe sự kiện khi phát xong
        _audioPlayer.onPlayerComplete.listen((_) {
          setState(() {
            isPlaying = false;
          });
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi khi phát ghi âm: $e';
        isPlaying = false;
      });
    }
  }

  Future<void> _stopPlayback() async {
    try {
      await _audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi khi dừng phát: $e';
      });
    }
  }

  Future<void> _checkPronunciation() async {
    if (recordedFilePath == null) return;

    setState(() {
      isChecking = true;
      errorMessage = null;
    });

    try {
      final audioFile = File(recordedFilePath!);
      final response = await _whisperService.checkPronunciation(audioFile, widget.word);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          result = PronunciationResult.fromJson(data);
        });
        // Thông báo kết quả luyện tập
        widget.onPracticeComplete(widget.word);
      } else {
        setState(() {
          errorMessage = 'Lỗi từ server: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi khi đánh giá phát âm: $e';
      });
    } finally {
      setState(() {
        isChecking = false;
      });
    }
  }

  void _startDurationTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));

      if (!isRecording) {
        return false;
      }

      if (recordingStartTime != null) {
        final currentDuration = DateTime.now().difference(recordingStartTime!);
        setState(() {
          recordDuration = currentDuration;
        });
      }

      return isRecording;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header với nút đóng
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Luyện tập phát âm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    widget.onClose();
                  },
                ),
              ],
            ),
          ),

          // Nội dung chính
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Hiển thị từ cần phát âm
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.word,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          IconButton(
                            icon: const Icon(Icons.volume_up, size: 32),
                            onPressed: () => AudioHelper.speak(widget.word),
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Hiển thị lỗi nếu có
                    if (errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Hiển thị kết quả đánh giá nếu có
                    if (result != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: _getScoreColor(result!.mistakePercentage).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getScoreColor(result!.mistakePercentage),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Kết quả đánh giá',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _getScoreColor(result!.mistakePercentage),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: _getScoreColor(result!.mistakePercentage),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${(100 - result!.mistakePercentage).toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: _getScoreColor(result!.mistakePercentage),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    _getScoreFeedback(result!.mistakePercentage),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _getScoreColor(result!.mistakePercentage),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    // Hiển thị trạng thái ghi âm
                    if (isRecording || hasRecorded)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isRecording ? Colors.red.shade50 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: isRecording ? Colors.red : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          _formatDuration(recordDuration),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isRecording ? Colors.red : Colors.black87,
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Icon trạng thái
                    Icon(
                      isRecording
                          ? Icons.mic
                          : hasRecorded
                              ? isPlaying
                                  ? Icons.volume_up
                                  : Icons.mic_none
                              : Icons.mic_none,
                      size: 80,
                      color: isRecording
                          ? Colors.red
                          : hasRecorded
                              ? isPlaying
                                  ? Colors.blue
                                  : Colors.green
                              : Colors.grey,
                    ),

                    const SizedBox(height: 16),

                    // Thông báo trạng thái
                    Text(
                      isRecording
                          ? 'Đang ghi âm...'
                          : hasRecorded && isPlaying
                              ? 'Đang phát...'
                              : hasRecorded
                                  ? 'Đã ghi âm xong'
                                  : 'Nhấn nút bên dưới để bắt đầu thu âm',
                      style: TextStyle(
                        fontSize: 16,
                        color: isRecording
                            ? Colors.red
                            : isPlaying
                                ? Colors.blue
                                : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Hiển thị visualizer khi đang ghi âm
                    if (isRecording)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(10, (barIndex) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              width: 4,
                              height: (20 + (barIndex % 5) * 4).toDouble(),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            );
                          }),
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Các nút điều khiển
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Nút phát lại bản ghi
                        if (hasRecorded)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  isPlaying ? Icons.stop : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  isPlaying ? 'Dừng phát' : 'Nghe lại',
                                  style: const TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                onPressed: () {
                                  if (isPlaying) {
                                    _stopPlayback();
                                  } else {
                                    _playRecording();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isPlaying ? Colors.red : Colors.blue,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ),

                        // Nút thu âm hoặc dừng thu âm
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(
                              isRecording ? Icons.stop : Icons.mic,
                              color: Colors.white,
                            ),
                            label: Text(
                              isRecording
                                  ? 'Dừng thu âm'
                                  : hasRecorded
                                      ? 'Thu âm lại'
                                      : 'Bắt đầu thu âm',
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            onPressed: isChecking
                                ? null
                                : () {
                                    if (isRecording) {
                                      _stopRecording();
                                    } else {
                                      _startRecording();
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isRecording ? Colors.red : Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),

                        // Nút kiểm tra phát âm
                        if (hasRecorded && !isRecording && !isPlaying)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  isChecking ? Icons.hourglass_empty : Icons.check,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  isChecking ? 'Đang kiểm tra...' : 'Kiểm tra phát âm',
                                  style: const TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                onPressed: isChecking ? null : _checkPronunciation,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Color _getScoreColor(double mistakePercentage) {
    if (mistakePercentage <= 5) {
      return Colors.green;
    } else if (mistakePercentage <= 15) {
      return Colors.blue;
    } else if (mistakePercentage <= 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getScoreFeedback(double mistakePercentage) {
    if (mistakePercentage <= 5) {
      return 'Tuyệt vời! Phát âm của bạn rất chính xác.';
    } else if (mistakePercentage <= 15) {
      return 'Khá tốt! Phát âm của bạn có một vài lỗi nhỏ.';
    } else if (mistakePercentage <= 30) {
      return 'Cần cải thiện! Phát âm của bạn còn một số lỗi.';
    } else {
      return 'Cần luyện tập nhiều hơn! Phát âm của bạn còn nhiều lỗi.';
    }
  }
}
