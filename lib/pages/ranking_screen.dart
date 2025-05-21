import 'package:flutter/material.dart';

class RankingScreen extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboard = [
    {
      'rank': 1,
      'name': 'Milad',
      'country': 'US',
      'score': 1419,
      'avatar': 'images/avatar1.png',
      'flag': 'images/flag_Viet_Nam.png',
      'badge': 'images/medal.png',
      'badgeColor': Color(0xFFFFD700), // Gold
    },
    {
      'rank': 2,
      'name': 'Uwen',
      'country': 'ES',
      'score': 1046,
      'avatar': 'images/avatar2.png',
      'flag': 'images/flag_Viet_Nam.png',
      'badge': 'images/medal.png',
      'badgeColor': Color(0xFFC0C0C0), // Silver
    },
    {
      'rank': 3,
      'name': 'Şeyda Nur',
      'country': 'US',
      'score': 1040,
      'avatar': 'images/avatar3.png',
      'flag': 'images/flag_Viet_Nam.png',
      'badge': 'images/medal.png',
      'badgeColor': Color(0xFFCD7F32), // Bronze
    },
    {
      'rank': 4,
      'name': 'Stephanie',
      'country': 'US',
      'score': 688,
      'avatar': 'images/avatar1.png',
      'flag': 'images/flag_Viet_Nam.png',
    },
    {
      'rank': 5,
      'name': 'Krupska',
      'country': 'US',
      'score': 652,
      'avatar': 'images/avatar2.png',
      'flag': 'images/flag_Viet_Nam.png',
    },
    {
      'rank': 14,
      'name': 'Alperen',
      'country': 'US',
      'score': 100,
      'avatar': 'images/avatar3.png',
      'flag': 'images/flag_Viet_Nam.png',
      'isUser': true,
    },
    {
      'rank': 15,
      'name': 'Joshua',
      'country': 'US',
      'score': 10,
      'avatar': 'images/avatar1.png',
      'flag': 'images/flag_Viet_Nam.png',
    },
  ];

  Widget _podiumAvatar(Map<String, dynamic> user, double size, {required int rank}) {
    // Medal icon for each rank
    String medalAsset;
    switch (rank) {
      case 1:
        medalAsset = 'images/medal_top_1.png';
        break;
      case 2:
        medalAsset = 'images/medal_top_2.png';
        break;
      case 3:
        medalAsset = 'images/medal_top_3.png';
        break;
      default:
        medalAsset = '';
    }
    return Column(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(user['avatar']),
        ),
        const SizedBox(height: 4),
        if (medalAsset.isNotEmpty) Image.asset(medalAsset, width: size * 0.7, height: size * 0.7),
        Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('${user['score']} KN', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
      ],
    );
  }

  Widget _buildPodium() {
    final first = leaderboard[0];
    final second = leaderboard[1];
    final third = leaderboard[2];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _podiumAvatar(second, 56, rank: 2),
            ],
          ),
          const SizedBox(width: 16),
          // 1st place (center, larger)
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _podiumAvatar(first, 72, rank: 1),
            ],
          ),
          const SizedBox(width: 16),
          // 3rd place
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _podiumAvatar(third, 48, rank: 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankRow(Map<String, dynamic> user, {bool highlight = false, bool isRelegation = false}) {
    Color? rowColor;
    if (isRelegation) {
      rowColor = Colors.red[50];
    } else if (highlight) {
      rowColor = Colors.blue[50];
    } else {
      rowColor = Colors.white;
    }
    Widget leading;
    const double rankBoxWidth = 40;
    if (user['rank'] == 1 || user['rank'] == 2 || user['rank'] == 3) {
      String medalAsset;
      switch (user['rank']) {
        case 1:
          medalAsset = 'images/medal_top_1.png';
          break;
        case 2:
          medalAsset = 'images/medal_top_2.png';
          break;
        case 3:
          medalAsset = 'images/medal_top_3.png';
          break;
        default:
          medalAsset = '';
      }
      leading = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: rankBoxWidth,
            child: Center(
              child: medalAsset.isNotEmpty
                  ? Image.asset(
                      medalAsset,
                      width: 32,
                      height: 32,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            backgroundImage: AssetImage(user['avatar']),
          ),
        ],
      );
    } else {
      leading = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: rankBoxWidth,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                user['rank'].toString(),
                style: TextStyle(
                  color: user['rank'] == 4 ? Colors.green : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            backgroundImage: AssetImage(user['avatar']),
          ),
        ],
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
      decoration: BoxDecoration(
        color: rowColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: leading,
        title: Row(
          children: [
            Text(
              user['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(width: 8),
            Image.asset(user['flag'] ?? 'images/flag_Viet_Nam.png', width: 20, height: 20),
            if (user['rank'] == 1) ...[
              const SizedBox(width: 4),
              Text('60', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700], fontSize: 14)),
            ]
          ],
        ),
        trailing: Text(
          '${user['score']} KN',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userRow = leaderboard.firstWhere((u) => u['isUser'] == true, orElse: () => <String, dynamic>{});
    // Define promotion and relegation cutoffs
    const int promotionCutoff = 12;
    const int relegationCutoff = 15; // Example: last 5 users
    final int totalUsers = leaderboard.length;

    List<Widget> buildLeaderboardList() {
      List<Widget> widgets = [];
      for (int i = 0; i < leaderboard.length; i++) {
        final user = leaderboard[i];
        // Insert promotion group label
        if (i == promotionCutoff) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.arrow_upward, color: Colors.green, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'NHÓM THĂNG HẠNG',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_upward, color: Colors.green, size: 28),
                ],
              ),
            ),
          );
        }
        // Insert relegation group label
        if (i == totalUsers - (totalUsers - relegationCutoff)) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.arrow_downward, color: Colors.red, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'NHÓM RỚT HẠNG',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_downward, color: Colors.red, size: 28),
                ],
              ),
            ),
          );
        }
        // Style relegation users
        bool isRelegation = i >= relegationCutoff;
        widgets.add(_buildRankRow(user, highlight: user['isUser'] == true, isRelegation: isRelegation));
      }
      return widgets;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng xếp hạng', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          const SizedBox(height: 8),
          if (userRow.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Image.asset('images/trophy.png', width: 48, height: 48),
                  const SizedBox(height: 4),
                  Text(
                    'Chúc mừng! Tuần trước bạn đã đạt vị trí số ${userRow['rank']}.',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          _buildPodium(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView(
                children: buildLeaderboardList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
