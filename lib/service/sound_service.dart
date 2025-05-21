import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;

  factory SoundService() {
    return _instance;
  }

  SoundService._internal();

  bool get isSoundEnabled => _soundEnabled;

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }

  Future<void> playCorrectSound() async {
    if (_soundEnabled) {
      await _audioPlayer.play(AssetSource('sounds/correct_answer.mp3'));
    }
  }

  Future<void> playErrorSound() async {
    if (_soundEnabled) {
      await _audioPlayer.play(AssetSource('sounds/error.mp3'));
    }
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}