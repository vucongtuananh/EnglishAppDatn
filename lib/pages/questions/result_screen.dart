import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../common/animation_button_common.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int percent;
  final String time;

  const ResultScreen({
    super.key,
    required this.score,
    required this.percent,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Firework Lottie
            SizedBox(
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.asset('assets/animations/firework.json', repeat: true, width: 100),
                ],
              ),
            ),
            // Illustration (replace with your own asset if needed)
            Lottie.asset('assets/animations/teamwork.json', height: 180),
            const SizedBox(height: 24),
            const Text(
              "Hoàn thành bài học!",
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ResultBox(
                  color: Colors.yellow[700]!,
                  icon: Icons.flash_on,
                  label: "TỔNG ĐIỂM KN",
                  value: "$score",
                ),
                _ResultBox(
                  color: Colors.green,
                  icon: Icons.gps_fixed,
                  label: "TỐT",
                  value: "$percent%",
                ),
                _ResultBox(
                  color: Colors.blue,
                  icon: Icons.timer,
                  label: "TỐC ĐỘ",
                  value: time,
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: AnimatedBtnCommon(
                  color: Colors.lightBlue,
                  width: double.infinity,
                  height: 56,
                  borderRadius: 14,
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text(
                    "NHẬN KN",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ResultBox extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final String value;

  const _ResultBox({
    required this.color,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
