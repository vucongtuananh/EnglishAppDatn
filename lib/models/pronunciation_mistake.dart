class PronunciationMistake {
  final String expected;
  final int position;
  final String transcribed;

  PronunciationMistake({
    required this.expected,
    required this.position,
    required this.transcribed,
  });

  factory PronunciationMistake.fromJson(Map<String, dynamic> json) {
    return PronunciationMistake(
      expected: json['expected'],
      position: json['position'],
      transcribed: json['transcribed'],
    );
  }
}