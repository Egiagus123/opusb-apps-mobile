import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  final double width;
  final double height;
  final Color color;
  final BorderRadius borderRadius;

  CustomTabIndicator({
    required this.width,
    required this.height,
    required this.color,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(
      width: width,
      height: height,
      color: color,
      borderRadius: borderRadius,
    );
  }
}

class _CustomPainter extends BoxPainter {
  final double width;
  final double height;
  final Color color;
  final BorderRadius borderRadius;

  _CustomPainter({
    required this.width,
    required this.height,
    required this.color,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    final Paint paint = Paint()..color = color;

    final double left = offset.dx + (config.size!.width - width) / 2;
    final double top = offset.dy + config.size!.height - height;

    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, width, height),
      borderRadius.topLeft,
    );

    canvas.drawRRect(rRect, paint);
  }
}
