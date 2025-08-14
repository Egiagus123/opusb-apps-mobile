part of 'design_theme.dart';

class DesignColor {
  /// Better to define proper Color naming
  /// Please refer to:
  /// https://m3.material.io/styles/color/system/how-the-system-works#e196928a-9922-4d1f-a25f-ab6a550714aa
  DesignColor.foundation()
      : blue1 = Color(0xff00adef),
        blue2 = Color(0xff31aad8),
        blue3 = Color(0xff4199bc),
        bluePressed = Color(0xff1995c5),
        white = Colors.white,
        red1 = Color(0xffd10f0f),
        redPressed = Color(0xffb61717),
        gray1 = Color(0xffefefef),
        gray2 = Color(0xffc7c7c7),
        gray3 = Color(0xff8b8b8b),
        black = Colors.black;

  final Color blue1;
  final Color blue2;
  final Color blue3;
  final Color bluePressed;
  final Color white;
  final Color red1;
  final Color redPressed;
  final Color gray1;
  final Color gray2;
  final Color gray3;
  final Color black;
}
