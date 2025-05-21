import 'package:english_learning_app/models/topicmodel.dart';
import 'package:english_learning_app/service/topic_list_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Định nghĩa TopicViewModel kế thừa từ ChangeNotifier
class TopicViewModel extends ChangeNotifier {
  List<TopicModel> topics = [];
  bool isLoading = false;
  String? errorMessage;

  // Constructor
  TopicViewModel();

  // Getter cho topics
  List<TopicModel> get getTopics => topics;

  // Get active topics (status == 1)
  List<TopicModel> get getActiveTopics => topics.where((topic) => topic.status == 1).toList();

  // Get inactive topics (status == 0)
  List<TopicModel> get getInactiveTopics => topics.where((topic) => topic.status == 0).toList();

  // Get topic progress
  int getTopicProgress(int topicId) {
    final topic = topics.firstWhere((t) => t.id == topicId, orElse: () => TopicModel(category_name: ''));
    return topic.progress_percent;
  }

  // Check if topic is active
  bool isTopicActive(int topicId) {
    final topic = topics.firstWhere((t) => t.id == topicId, orElse: () => TopicModel(category_name: ''));
    return topic.status == 1;
  }

  void load() async {
    try {
      setLoading(true);
      setError(null);

      final loadedTopics = await TopicListService.getListTopic();
      topics = loadedTopics;

      setLoading(false);
    } catch (e) {
      setLoading(false);
      setError('Failed to load topics: $e');
    }
  }

  // Đặt lỗi và thông báo thay đổi
  void setError(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  // Đặt trạng thái loading
  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  // Fetch topics và cập nhật trạng thái
  Future<List<TopicModel>> fetchTopics() async {
    try {
      setLoading(true);
      setError(null);
      load();
      setLoading(false);
      return topics;
    } catch (e) {
      setLoading(false);
      setError('Failed to fetch topics: $e');
      return [];
    }
  }

  Future<TopicModel?> getTopicById(int topicId) async {
    try {
      return topics.firstWhere((topic) => topic.id == topicId);
    } catch (e) {
      setError('Failed to fetch topic: $e');
      return null;
    }
  }

  Future<void> addTopic(TopicModel topic) async {
    try {
      setLoading(true);
      setError(null);
      topics.add(topic);
      setLoading(false);
    } catch (e) {
      setLoading(false);
      setError('Failed to add topic: $e');
    }
  }

  String generateId() {
    if (topics.isEmpty) {
      return "1";
    }
    int maxId = topics.isNotEmpty ? topics.map((topic) => topic.id ?? 0).reduce((a, b) => a > b ? a : b) : 0;
    return (maxId + 1).toString();
  }

  Future<void> updateTopic(TopicModel topic) async {
    try {
      setLoading(true);
      setError(null);
      final index = topics.indexWhere((t) => t.id == topic.id);
      if (index != -1) {
        topics[index] = topic;
      }
      setLoading(false);
    } catch (e) {
      setLoading(false);
      setError('Failed to update topic: $e');
    }
  }

  Future<void> deleteTopic(int id) async {
    try {
      setLoading(true);
      setError(null);
      topics.removeWhere((topic) => topic.id == id);
      setLoading(false);
    } catch (e) {
      setLoading(false);
      setError('Failed to delete topic: $e');
    }
  }

  
}

// Define the provider
final topicViewModelProvider = ChangeNotifierProvider<TopicViewModel>((ref) {
  return TopicViewModel();
});
