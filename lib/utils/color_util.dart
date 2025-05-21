import 'dart:math';

String getRandomColor() {
  final List<String> colorHexCodes = [
    '#57cc02', // xanh lá cây
    '#cc3c3d', // đỏ
    '#cc6ca7', // hồng
    '#168dc5', // xanh
    '#ffc605', //vàng
  ];

  final Random random = Random();
  String hexCode = colorHexCodes[random.nextInt(colorHexCodes.length)];

  return hexCode;
}
