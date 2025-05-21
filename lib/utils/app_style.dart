import 'dart:math';
import 'package:flutter/material.dart';

class AppStyle {
  static AppStyleColor color = AppStyleColor();
  static AppStyleDimen dimen = AppStyleDimen();

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class AppStyleColor {
  final Color primary = Color(0xFF58CC02);
  final Color success = Color(0xFF2CA91C);
  final Color info = Color(0xFF888888);
  final Color warning = Color(0xFFE45B00);
  final Color danger = Color(0xFFD42222);
  final Color avatar = Color(0xFFC4C4C4);
  final Color link = Color(0xFF4285F4);

  final Color scheme1 = Color(0xFF4285F4);
  final Color scheme2 = Color(0xFF0F9D58);
  final Color scheme3 = Color(0xFEDB4437);
  final Color scheme4 = Color(0xFFF4A400);
  final Color scheme5 = Color(0xFF1DBFB2);
  final Color scheme6 = Color(0xFFDF5491);

  final Color colorIcon = Color(0XFF999999);
  final Color textDark = Colors.black;
  final Color textNormal = Color(0xFF333333);
  final Color textMuted = Color(0xFF555555);

  final Color background = Color(0xFFEAEAEA);
  final Color primaryBackground = Color(0xFFCACACA);
  final Color secondaryBackground = Color(0xFFE5E5E5);
  final Color selectedBackground = Color(0xFFF0F1FA);
  final Color highlightBackground = Color(0xFFEAEAEA);

  final Color border = Color(0xFFCACACA);
  final Color borderMuted = Color(0xFFEAEAEA);
  final Color borderFocus = Color(0xFF888888);
  final Color divider = Color(0x33000000);
  final Color colorTitle = Color(0xFF626773);

  final Color brButtonUnSuccess = Color(0xFFEAEAEA);
  final Color brButtonSuccess = Color(0xFF1769D7);
  final Color textButtonUnSuccess = Color(0xFFABAEBB);
  final Color brLine = Color(0xFFF0F0F0);
  final Color textColorNew = Color(0xFF696B72);
  final Color dangerNew = Color(0xFFB5393B);
  final Color colorIconNew = Color(0xFF9497A5);
  final Color colorTextNew = Color(0xFF42444D);
  final Color colorSuccessNew = Color(0xFF218656);
  final Color colorFacebook = Color(0xFF3A6EED);
  final Color colorApple = Color(0xFF0A0B0C);

  final Color colorBgMesRight = AppStyle.fromHex("#E1EDFD");
  final Color colorBgMesLeft = AppStyle.fromHex("#F4F5F9");
  final Color colorTiktok = AppStyle.fromHex("#5245e2");

  final Gradient primaryGradient =
  LinearGradient(colors: [Color(0xFFE40065), Color(0xFFDF5491)]);

  final List<ColorDisplay> colorDisplay = [
    ColorDisplay(color: "#20C2DE", display: "#1895B0"),
    ColorDisplay(color: "#F1D42F", display: "#E08E0E"),
    ColorDisplay(color: "#127ABD", display: "#1769D7"),
    ColorDisplay(color: "#FD9E31", display: "#FB6321"),
    ColorDisplay(color: "#59E79A", display: "#2D8F77"),
    ColorDisplay(color: "#FD7BCA", display: "#CF59AE"),
    ColorDisplay(color: "#354662", display: "#354662"),
    ColorDisplay(color: "#64BB55", display: "#23702B"),
    ColorDisplay(color: "#E95B4B", display: "#E82B2E"),
    ColorDisplay(color: "#C27ADE", display: "#7D4DBA"),
  ];

  getColorDisplay(color) {
    var col = colorDisplay.where((item) => item.color == color);
    if (col != null && col.length > 0) {
      return col.first.display;
    }
    return colorDisplay.first.display;
  }

  Color colorScheme(String value) {
    var hash = value != null ? value.hashCode % 8 : Random().nextInt(8);
    return scheme(hash);
  }

  Color scheme(int index) {
    switch (index) {
      case 0:
        return this.primary;
      case 1:
        return this.success;
      case 2:
        return this.info;
      case 3:
        return this.warning;
      case 4:
        return this.danger;
      case 5:
        return this.scheme1;
      case 6:
        return this.scheme2;
      case 6:
        return this.scheme3;
      default:
        return this.primary;
    }
  }

  Color randomColor(String s) {
    final hash = s.hashCode % 6;
    switch (hash) {
      case 0:
        return this.scheme1;
      case 1:
        return this.success;
      case 2:
        return this.scheme4;
      case 3:
        return this.warning;
      case 4:
        return this.danger;
      case 5:
        return this.scheme5;
      default:
        return this.primary;
    }
  }

  Color rateColor(int rating) {
    switch (rating) {
      case 1:
        return Color(0xFFFCD45E);
      case 2:
        return Color(0xFFCBCFCF);
      case 3:
        return Color(0xFFBD9354);
      default:
        return Color(0xFF999999);
    }
  }
}

class AppStyleDimen {
  final double radiusCommon = 10;
  final double radiusSmall = 5;
  final double radiusLarge = 20;
  final double fontSizeDisplay = 34;
  final double fontSizeHeadline = 24;
  final double fontSizeTitle = 16;
  final double fontSizeBody = 14;
  final double fontSizeCaption = 12;
  final double fontSizeExtraInfo = 11;
  final double fontSizeButton = 14;
  final double fontSizeButtonSmall = 10;
  final double fontSizeTitleConversation = 18;
  final double fontSizeContentConversation = 14;
  final double fontSizeUnReadCount = 11;
  final double fontSizeWarning = 13;
}

class ColorDisplay {
  String? color;
  String? display;

  ColorDisplay({this.color, this.display});
}
