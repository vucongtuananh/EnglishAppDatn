import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:english_learning_app/models/pronunciation_result.dart';
import 'package:english_learning_app/models/question_model.dart';
import 'package:english_learning_app/service/question_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../service/whisper_service.dart';

// Model cho kết quả đánh giá phát âm

class QuestionViewModel extends ChangeNotifier {
  final WhisperService whisperService = WhisperService();
  final QuestionService questionService = QuestionService();

  // Audio recorder và player
  late final AudioRecorder audioRecorder;
  final AudioPlayer audioPlayer = AudioPlayer();

  // Biến theo dõi thời gian ghi âm thủ công
  final Map<int, DateTime> recordingStartTimes = {};
  final FlutterTts flutterTts = FlutterTts();

  List<Question>? questions;
  Map<String, List<Question>>? categorizedQuestions; // Phân loại theo type

  bool isLoading = true;
  int currentIndex = 0;
  int currentLevel = 1;

  // Thêm các trạng thái cho đánh giá phát âm
  final Map<int, bool> isChecking = {};
  final Map<int, PronunciationResult?> pronunciationResults = {};
  final Map<int, String> errorMessages = {};

  // Tính toán trực tiếp thay vì getter
  int get totalQuestions => questions?.length ?? 0;
  bool get hasQuestions => questions != null && questions!.isNotEmpty;
  double get progressValue => hasQuestions ? (currentIndex / totalQuestions) : 0.0;

  // Tab hiện tại (cho TabBar)
  int _currentTab = 0;
  int get currentTab => _currentTab;

  final Map<int, List<String>> sortQuestionWordMaps = {};
  final Map<int, List<String>> sortQuestionAnswers = {};
  final Map<int, bool> sortQuestionSubmitted = {};

  // MultiChoice state
  final Map<int, String?> selectedChoices = {};
  final Map<int, bool> multiChoiceSubmitted = {};

  // Pronunciation state
  final Map<int, bool> isRecording = {};
  final Map<int, bool> hasRecorded = {};
  final Map<int, String> audioFilePaths = {};
  final Map<int, bool> isPlaying = {};
  final Map<int, Duration> recordDurations = {};

  // Constructor
  QuestionViewModel() {
    audioRecorder = AudioRecorder();
    _initAudioPlayer();
    _initTts(); // Khởi tạo Text-to-Speech
  }

  // Khởi tạo sự kiện cho AudioPlayer
  void _initAudioPlayer() {
    audioPlayer.onPlayerComplete.listen((event) {
      for (var i in isPlaying.keys) {
        if (isPlaying[i] == true) {
          isPlaying[i] = false;
          notifyListeners();
        }
      }
    });
  }

  // Khởi tạo cấu hình TTS
  void _initTts() async {
    await flutterTts.setLanguage("en-US"); // Tiếng Anh
    await flutterTts.setSpeechRate(0.55); // Tốc độ đọc (0.5 = hơi chậm)
    await flutterTts.setVolume(1.0); // Âm lượng tối đa
    await flutterTts.setPitch(0.8); // Cao độ giọng nói bình thường
  }

  // Phương thức để phát âm một từ
  Future<void> speakWord(String word) async {
    await flutterTts.speak(word);
  }

  @override
  void dispose() {
    audioRecorder.dispose();
    audioPlayer.dispose();
    flutterTts.stop();
    super.dispose();
  }

  bool isSortCorrect(int index) {
    if (!hasQuestions || index >= questions!.length) return false;
    final question = questions![index];
    if (question.type != 'sort') return false;
    return sortQuestionAnswers[index]?.join(' ') == question.title;
  }

  bool isMultiChoiceCorrect(int index) {
    if (!hasQuestions || index >= questions!.length) return false;
    final question = questions![index];
    if (question.type != 'multiple_choice') return false;
    return selectedChoices[index] == question.correctAnswer;
  }

  // Phương thức tiện ích cho đánh giá phát âm
  bool hasResult(int index) => pronunciationResults[index] != null;

  Future<void> loadQuestions({required int lessonId}) async {
    isLoading = true;
    notifyListeners();

    try {
      lessonId = lessonId + 1;
      questions = await questionService.getQuestionsByLevel(lessonId);

      if (questions != null && questions!.isNotEmpty) {
        // Phân loại câu hỏi theo type
        categorizedQuestions = _categorizeQuestionsByType(questions!);

        // Khởi tạo dữ liệu cho từng câu hỏi
        for (int i = 0; i < questions!.length; i++) {
          final question = questions![i];

          if (question.type == 'sort') {
            // Xử lý câu hỏi sắp xếp
            final words = question.title.split(' ');
            final shuffledWords = [...words]..shuffle();

            sortQuestionWordMaps[i] = shuffledWords;
            sortQuestionAnswers[i] = [];
            sortQuestionSubmitted[i] = false;
          } else if (question.type == 'multiple_choice') {
            // Xử lý câu hỏi trắc nghiệm
            selectedChoices[i] = null;
            multiChoiceSubmitted[i] = false;
          } else if (question.type == 'text') {
            // Xử lý câu hỏi phát âm
            isRecording[i] = false;
            hasRecorded[i] = false;
            isPlaying[i] = false;
            recordDurations[i] = Duration.zero;
            isChecking[i] = false;
            pronunciationResults[i] = null;
            errorMessages[i] = '';
          }
        }
      }
    } catch (e) {
      print("Lỗi khi tải câu hỏi: $e");
      // Khởi tạo danh sách trống nếu có lỗi
      questions = [];
      categorizedQuestions = {
        'sort': [],
        'multiple_choice': [],
        'text': [],
      };
    }

    isLoading = false;
    notifyListeners();
  }

  // Phân loại câu hỏi theo type
  Map<String, List<Question>> _categorizeQuestionsByType(List<Question> questions) {
    final Map<String, List<Question>> categorized = {
      'sort': [],
      'multiple_choice': [],
      'text': [],
    };

    for (var question in questions) {
      if (categorized.containsKey(question.type)) {
        categorized[question.type]!.add(question);
      } else {
        // Nếu có type mới không nằm trong danh sách đã biết
        categorized[question.type] = [question];
      }
    }

    return categorized;
  }

  // // Phương thức để thay đổi level và tải lại câu hỏi
  // Future<void> changeLevel(int level) async {
  //   currentLevel = level;
  //   resetAllState();
  //   await loadQuestions(lessonId: level);
  // }

  // Phương thức để thay đổi tab hiện tại
  void changeTab(int tabIndex) {
    _currentTab = tabIndex;
    notifyListeners();
  }

  // Điều hướng
  void goToNextQuestion() {
    if (currentIndex < totalQuestions - 1) {
      currentIndex++;
      notifyListeners();
    }
  }

  void goToPreviousQuestion() {
    if (currentIndex > 0) {
      currentIndex--;
      notifyListeners();
    }
  }

  // Phương thức cho SortQuestion
  void addWordToAnswer(int index, String word) {
    if (sortQuestionSubmitted[index] == true) return;

    sortQuestionWordMaps[index]?.remove(word);
    sortQuestionAnswers[index] ??= [];
    sortQuestionAnswers[index]?.add(word);
    notifyListeners();
  }

  void removeWordFromAnswer(int index, String word) {
    if (sortQuestionSubmitted[index] == true) return;

    sortQuestionAnswers[index]?.remove(word);
    sortQuestionWordMaps[index] ??= [];
    sortQuestionWordMaps[index]?.add(word);
    notifyListeners();
  }

  void submitSortAnswer(int index) {
    sortQuestionSubmitted[index] = true;
    // Kiểm tra đáp án và phát âm thanh tương ứng
    if (isSortCorrect(index)) {
      playCorrectSound();
    } else {
      playWrongSound();
    }
    notifyListeners();
  }

  // Phương thức cho MultiChoiceQuestion
  void selectChoice(int index, String choice) {
    if (multiChoiceSubmitted[index] == true) return;

    selectedChoices[index] = choice;
    notifyListeners();
  }

  void submitMultiChoiceAnswer(int index) {
    multiChoiceSubmitted[index] = true;
    // Kiểm tra đáp án và phát âm thanh tương ứng
    if (isMultiChoiceCorrect(index)) {
      playCorrectSound();
    } else {
      playWrongSound();
    }
    notifyListeners();
  }

  // Phương thức cho PronunciationQuestion
  Future<void> startRecording(int index) async {
    try {
      if (await audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/audio_question_$index.m4a';

        await audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: filePath,
        );

        recordingStartTimes[index] = DateTime.now();
        recordDurations[index] = Duration.zero;
        isRecording[index] = true;
        audioFilePaths[index] = filePath;

        // Xóa kết quả cũ khi ghi âm lại
        pronunciationResults[index] = null;
        errorMessages[index] = '';

        notifyListeners();
        _startDurationTimer(index);
      } else {
        throw Exception('Vui lòng cấp quyền truy cập microphone');
      }
    } catch (e) {
      throw Exception('Lỗi khi ghi âm: $e');
    }
  }

  // Dừng ghi âm và gửi đến server để đánh giá
  Future<void> stopRecordingAndCheck(int index) async {
    try {
      final path = await audioRecorder.stop();

      isRecording[index] = false;
      hasRecorded[index] = true;

      if (path != null) {
        audioFilePaths[index] = path;

        if (hasQuestions && index < questions!.length && questions![index].type == 'text') {
          await checkPronunciation(index, questions![index].title);
        }
      }

      notifyListeners();
    } catch (e) {
      errorMessages[index] = 'Lỗi khi dừng ghi âm: $e';
      notifyListeners();
      throw Exception('Lỗi khi dừng ghi âm: $e');
    }
  }

  // Phương thức để kiểm tra phát âm
  Future<void> checkPronunciation(int index, String referenceSentence) async {
    isChecking[index] = true;
    pronunciationResults[index] = null;
    errorMessages[index] = '';
    notifyListeners();

    try {
      final filePath = audioFilePaths[index];
      if (filePath == null) {
        throw Exception('Không tìm thấy file ghi âm');
      }

      final audioFile = File(filePath);
      final response = await whisperService.checkPronunciation(audioFile, referenceSentence);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        pronunciationResults[index] = PronunciationResult.fromJson(data);
        // Phát âm thanh dựa trên kết quả đánh giá phát âm
        final result = pronunciationResults[index];
        if (result != null) {
          if (result.mistakePercentage <= 15) { // Dưới 15% lỗi được coi là đúng
            playCorrectSound();
          } else {
            playWrongSound();
          }
        }
      } else {
        errorMessages[index] = 'Lỗi từ server: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      errorMessages[index] = 'Lỗi khi đánh giá phát âm: $e';
    } finally {
      isChecking[index] = false;
      notifyListeners();
    }
  }

  Future<void> playRecording(int index) async {
    try {
      final filePath = audioFilePaths[index];
      if (filePath != null && File(filePath).existsSync()) {
        isPlaying[index] = true;
        notifyListeners();

        await audioPlayer.play(DeviceFileSource(filePath));
      }
    } catch (e) {
      isPlaying[index] = false;
      notifyListeners();
      throw Exception('Lỗi khi phát ghi âm: $e');
    }
  }

  Future<void> stopPlayback() async {
    try {
      await audioPlayer.stop();
      for (var i in isPlaying.keys) {
        isPlaying[i] = false;
      }
      notifyListeners();
    } catch (e) {
      throw Exception('Lỗi khi dừng phát: $e');
    }
  }

  void _startDurationTimer(int index) {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));

      if (!(isRecording[index] ?? false)) {
        return false;
      }

      final startTime = recordingStartTimes[index];
      if (startTime != null) {
        final currentDuration = DateTime.now().difference(startTime);
        recordDurations[index] = currentDuration;
        notifyListeners();
      }

      return isRecording[index] ?? false;
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // Toggle ghi âm với đánh giá phát âm
  Future<void> toggleRecording(int index) async {
    if (isRecording[index] ?? false) {
      await stopRecordingAndCheck(index);
    } else {
      await startRecording(index);
    }
  }

  // Thêm phương thức này vào QuestionViewModel
  void resetAllState() {
    // Reset các thông số câu hỏi
    currentIndex = 0;

    // Reset các trạng thái SortQuestion
    sortQuestionWordMaps.clear();
    sortQuestionAnswers.clear();
    sortQuestionSubmitted.clear();

    // Reset các trạng thái MultiChoice
    selectedChoices.clear();
    multiChoiceSubmitted.clear();

    // Reset các trạng thái PronunciationQuestion
    isRecording.clear();
    hasRecorded.clear();
    audioFilePaths.clear();
    isPlaying.clear();
    recordDurations.clear();

    // Reset các trạng thái đánh giá phát âm
    isChecking.clear();
    pronunciationResults.clear();
    errorMessages.clear();

    // Reset audio player nếu đang phát
    audioPlayer.stop();

    notifyListeners();
  }

  // Phương thức để tăng progressValue
  void increaseProgressValue() {
    currentIndex += 1;
    notifyListeners();
  }

  // Phương thức để lấy danh sách các câu hỏi theo loại
  List<Question>? getQuestionsByType(String type) {
    return categorizedQuestions?[type];
  }

  // Phương thức để lấy số lượng câu hỏi theo loại
  int getQuestionsCountByType(String type) {
    return categorizedQuestions?[type]?.length ?? 0;
  }
  // Phương thức chung để phát âm thanh từ assets
  Future<void> playSound(String soundAsset) async {
    try {
      // Nếu đang phát âm thanh nào đó, dừng lại
      await audioPlayer.stop();
      // Phát âm thanh mới
      await audioPlayer.play(AssetSource(soundAsset));
    } catch (e) {
      print('Lỗi khi phát âm thanh: $e');
    }
  }

// Phương thức phát âm thanh đúng
  Future<void> playCorrectSound() async {
    await playSound('sounds/correct_answer.mp3');
  }

// Phương thức phát âm thanh sai
  Future<void> playWrongSound() async {
    await playSound('sounds/wrong_answer.mp3');
  }
}
