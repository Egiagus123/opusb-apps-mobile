import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double defaultSize = 0;
  static Orientation orientation = Orientation.portrait;

  // Initialize size configurations
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }

  // Getters to ensure init() has been called first
  static double get screenWidthSafe {
    if (_mediaQueryData == null) {
      throw Exception(
          "SizeConfig.init() must be called before accessing screen properties.");
    }
    return screenWidth;
  }

  static double get screenHeightSafe {
    if (_mediaQueryData == null) {
      throw Exception(
          "SizeConfig.init() must be called before accessing screen properties.");
    }
    return screenHeight;
  }

  static Orientation get orientationSafe {
    if (_mediaQueryData == null) {
      throw Exception(
          "SizeConfig.init() must be called before accessing orientation.");
    }
    return orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeightSafe;
  // 812 is the layout height that designer uses (reference screen height)
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate width as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidthSafe;
  // 375 is the layout width that designer uses (reference screen width)
  return (inputWidth / 375.0) * screenWidth;
}
