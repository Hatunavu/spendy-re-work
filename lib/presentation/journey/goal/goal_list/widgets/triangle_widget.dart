import 'dart:math';

import 'package:flutter/material.dart';

import 'package:spendy_re_work/presentation/theme/theme_color.dart';

class TriangleWidget extends StatelessWidget {
  const TriangleWidget(
      {Key? key, this.color, this.pathImage, this.sizeContainer, this.sizeIcon})
      : super(key: key);
  final Color? color;
  final String? pathImage;
  final double? sizeContainer;
  final double? sizeIcon;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: _ShapesPainter(color!),
        child: Container(
            height: sizeContainer,
            width: sizeContainer,
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 16),
                    child: Transform.rotate(
                        angle: pi / 4,
                        child: Image.asset(
                          pathImage!,
                          height: sizeIcon,
                          width: sizeIcon,
                          color: AppColor.white,
                        ))))));
  }
}

class _ShapesPainter extends CustomPainter {
  final Color color;

  _ShapesPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.height, size.width)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
