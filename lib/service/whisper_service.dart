import 'dart:io';

import 'package:english_learning_app/utils/constants.dart';
import 'package:http/http.dart' as http;

import 'data_client_service.dart';

class WhisperService {
  static final WhisperService _instance = WhisperService.internal();

  factory WhisperService() {
    return _instance;
  }

  WhisperService.internal();

  checkPronunciation(File voiceFile, String referenceSentence) async {
    String path = 'transcribe';
    var url = Uri.parse(local_url + path);
    var header = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Bearer ${DataClient.user.token!}",
    };
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(header);
    request.fields['reference'] = referenceSentence;
    request.files.add(await http.MultipartFile.fromPath('audio', voiceFile.path));
    try {
      var streamedResponse = await request.send().timeout(Duration(seconds: 6));
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      throw Exception("Failed to send request: $e");
    }
  }
}
