import 'package:english_learning_app/common/animation_button_common.dart';
import 'package:english_learning_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:english_learning_app/utils/app_style.dart';

class PronunciationScreen extends StatefulWidget {
  const PronunciationScreen({super.key});

  @override
  _PronunciationScreenState createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends State<PronunciationScreen> with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late TabController _tabController;

  // Danh sách nguyên âm với IPA và từ mẫu
final List<Map<String, String>> vowels = [ // Nguyên âm
      {"ipa": "/æ/", "example": "cat", "name": "Nguyên âm /æ/"},
      {"ipa": "/ɑː/", "example": "car", "name": "Nguyên âm /ɑː/"},
      {"ipa": "/e/", "example": "bed", "name": "Nguyên âm /e/"},
      {"ipa": "/ə/", "example": "about", "name": "Nguyên âm /ə/"},
      {"ipa": "/ɜː/", "example": "bird", "name": "Nguyên âm /ɜː/"},
      {"ipa": "/ɪ/", "example": "sit", "name": "Nguyên âm /ɪ/"},
      {"ipa": "/iː/", "example": "see", "name": "Nguyên âm /iː/"},
      {"ipa": "/ɒ/", "example": "hot", "name": "Nguyên âm /ɒ/"},
      {"ipa": "/ɔː/", "example": "law", "name": "Nguyên âm /ɔː/"},
      {"ipa": "/ʊ/", "example": "put", "name": "Nguyên âm /ʊ/"},
      {"ipa": "/uː/", "example": "too", "name": "Nguyên âm /uː/"},
      {"ipa": "/ʌ/", "example": "cup", "name": "Nguyên âm /ʌ/"},
      {"ipa": "/eɪ/", "example": "day", "name": "Nguyên âm đôi /eɪ/"},
      {"ipa": "/aɪ/", "example": "my", "name": "Nguyên âm đôi /aɪ/"},
      {"ipa": "/ɔɪ/", "example": "boy", "name": "Nguyên âm đôi /ɔɪ/"},
    ];
  // Danh sách phụ âm với IPA và từ mẫu
final List<Map<String, String>> consonants = [ // Phụ âm
      {"ipa": "/b/", "example": "bad", "name": "Phụ âm /b/"},
      {"ipa": "/d/", "example": "day", "name": "Phụ âm /d/"},
      {"ipa": "/f/", "example": "fun", "name": "Phụ âm /f/"},
      {"ipa": "/g/", "example": "go", "name": "Phụ âm /g/"},
      {"ipa": "/h/", "example": "hat", "name": "Phụ âm /h/"},
      {"ipa": "/j/", "example": "yes", "name": "Phụ âm /j/"},
      {"ipa": "/k/", "example": "key", "name": "Phụ âm /k/"},
      {"ipa": "/l/", "example": "live", "name": "Phụ âm /l/"},
      {"ipa": "/m/", "example": "man", "name": "Phụ âm /m/"},
      {"ipa": "/n/", "example": "not", "name": "Phụ âm /n/"},
      {"ipa": "/p/", "example": "pen", "name": "Phụ âm /p/"},
      {"ipa": "/r/", "example": "red", "name": "Phụ âm /r/"},
      {"ipa": "/s/", "example": "sun", "name": "Phụ âm /s/"},
      {"ipa": "/t/", "example": "tea", "name": "Phụ âm /t/"},
      {"ipa": "/v/", "example": "van", "name": "Phụ âm /v/"},
      {"ipa": "/w/", "example": "we", "name": "Phụ âm /w/"},
      {"ipa": "/z/", "example": "zoo", "name": "Phụ âm /z/"},
      {"ipa": "/ʃ/", "example": "she", "name": "Phụ âm /ʃ/"},
      {"ipa": "/ʒ/", "example": "vision", "name": "Phụ âm /ʒ/"},
      {"ipa": "/θ/", "example": "think", "name": "Phụ âm /θ/"},
      {"ipa": "/ð/", "example": "this", "name": "Phụ âm /ð/"},
    ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _setupTts();
  }

  void _setupTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    _tabController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Phát Âm",
          style: TextStyle(fontSize: AppStyle.dimen.fontSizeHeadline, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Nguyên Âm",),
            Tab(text: "Phụ Âm"),
          ],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Cùng học phát âm tiếng Anh nào!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab nguyên âm
                _buildSoundGridView(vowels),

                // Tab phụ âm
                _buildSoundGridView(consonants),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundGridView(List<Map<String, String>> sounds) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: sounds.length,
        itemBuilder: (context, index) {
          return _buildSoundCard(sounds[index]);
        },
      ),
    );
  }

  Widget _buildSoundCard(Map<String, String> sound) {
    return Hero(
      tag: 'sound_${sound["ipa"]}',
      child: Material(
        color: Colors.transparent,
        child: LayoutBuilder(builder: (context, constrait) {
          return AnimatedBtnCommon(
            width: 120,
            height: 120,
            color: Colors.white,
            elevation: 5,
            borderRadius: 16,
            shadowDegree: ShadowDegree.light,
            onPressed: () {
              _showSoundDetail(sound);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  sound["ipa"]!,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  sound["example"]!,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _showSoundDetail(Map<String, String> sound) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                sound["name"]!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                sound["ipa"]!,
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => _speak(sound["ipa"]!.replaceAll("/", "")),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppStyle.color.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.volume_up,
                        color: AppStyle.color.primary,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "Ví dụ:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                sound["example"]!,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              AnimatedBtnCommon(
                width: 160,
                height: 50,
                color: AppStyle.color.primary,
                elevation: 5,
                borderRadius: 30,
                shadowDegree: ShadowDegree.light,
                onPressed: () => _speak(sound["example"]!),
                child: Center(
                  child: const Text(
                    "Nghe ví dụ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
