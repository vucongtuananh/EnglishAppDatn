import 'package:flutter/material.dart';

import '../utils/constants.dart';

class AnimatedBtnCommon extends StatefulWidget {
  final Color color;
  final Widget child;
  final bool enabled;
  final double width;
  final int duration;
  final double height;
  final Color disabledColor;
  final double borderRadius;
  final VoidCallback onPressed;
  final ShadowDegree shadowDegree;
  final double elevation; // Thêm thuộc tính mới để kiểm soát độ cao

  const AnimatedBtnCommon({
    super.key,
    required this.child,
    required this.onPressed,
    this.height = 40,
    this.width = 140,
    this.duration = 70,
    this.enabled = true,
    this.borderRadius = 12,
    this.color = Colors.blue,
    this.disabledColor = Colors.grey,
    this.shadowDegree = ShadowDegree.light,
    this.elevation = 8, // Mặc định cao hơn (8 thay vì 4)
  });

  @override
  State<AnimatedBtnCommon> createState() => _AnimatedBtnCommonState();
}

class _AnimatedBtnCommonState extends State<AnimatedBtnCommon> {
  static const Curve _curve = Curves.easeInOut; // Đổi sang easeInOut để animation mượt hơn
  late double _shadowHeight;
  late double _position;

  @override
  void initState() {
    super.initState();
    _shadowHeight = widget.elevation;
    _position = widget.elevation;
  }

  @override
  void didUpdateWidget(AnimatedBtnCommon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.elevation != widget.elevation) {
      _shadowHeight = widget.elevation;
      _position = widget.elevation;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _height = widget.height - _shadowHeight;

    return GestureDetector(
      onTapDown: widget.enabled ? _pressed : null,
      onTapUp: widget.enabled ? _unPressedOnTapUp : null,
      onTapCancel: widget.enabled ? _unPressed : null,
      child: Container(
        width: widget.width,
        height: _height + _shadowHeight,
        child: Stack(
          children: <Widget>[
            // Lớp đổ bóng xa nhất để tạo hiệu ứng nổi cao
            // Positioned(
            //   bottom: 0,
            //   child: Container(
            //     height: _height,
            //     width: widget.width,
            //     decoration: BoxDecoration(
            //       borderRadius: _getBorderRadius(),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black.withOpacity(0.2),
            //           blurRadius: _shadowHeight * 2,
            //           spreadRadius: 1,
            //           offset: Offset(0, _shadowHeight / 3),
            //         )
            //       ],
            //     ),
            //   ),
            // ),

            // Lớp shadow chính
            Positioned(
              bottom: 0,
              child: Container(
                height: _height,
                width: widget.width,
                decoration: BoxDecoration(
                  color: widget.enabled ? darken(widget.color, widget.shadowDegree) : darken(widget.disabledColor, widget.shadowDegree),
                  borderRadius: _getBorderRadius(),
                ),
              ),
            ),

            // Lớp button chính có animation
            AnimatedPositioned(
              curve: _curve,
              duration: Duration(milliseconds: widget.duration),
              bottom: _position,
              child: Container(
                height: _height,
                width: widget.width,
                decoration: BoxDecoration(
                  color: widget.enabled ? widget.color : widget.disabledColor,
                  borderRadius: _getBorderRadius(),
                  // Thêm gradient để tạo hiệu ứng độ sâu
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      widget.enabled ? lighten(widget.color, 0.1) : lighten(widget.disabledColor, 0.1),
                      widget.enabled ? widget.color : widget.disabledColor,
                    ],
                  ),
                  // Thêm shadow nhẹ cho button chính để tăng cảm giác 3D
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 2,
                      spreadRadius: 0,
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pressed(_) {
    setState(() {
      _position = 0;
    });
  }

  void _unPressedOnTapUp(_) => _unPressed();

  void _unPressed() {
    setState(() {
      _position = _shadowHeight; // Sử dụng shadowHeight thay vì giá trị cố định
    });
    widget.onPressed();
  }

  BorderRadius? _getBorderRadius() {
    return BorderRadius.circular(widget.borderRadius);
  }
}

// Get a darker color from any entered color.
Color darken(Color color, ShadowDegree degree) {
  double amount = degree == ShadowDegree.dark ? 0.3 : 0.12;
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

// Thêm hàm làm sáng màu để tạo hiệu ứng gradient
Color lighten(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  return hslLight.toColor();
}
