// ignore_for_file: unused_element

import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

class Screen {
  final Size screenSize;

  Screen(this.screenSize);

  double wp(double percentage) {
    return (percentage / 100) * screenSize.width;
  }

  double hp(double percentage) {
    return (percentage / 100) * screenSize.height;
  }

  /// Mengkonversi ukuran piksel desain ke ukuran layar saat ini.
  double getWidthPx(int pixels) {
    return (pixels / 3.61) / 100 * screenSize.width;
  }
}
