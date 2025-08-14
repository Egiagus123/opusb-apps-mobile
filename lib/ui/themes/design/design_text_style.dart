// ignore_for_file: unnecessary_null_comparison

part of 'design_theme.dart';

class DesignTextStyle {
  const DesignTextStyle._({
    required this.heading1Semibold,
    required this.heading1Medium,
    required this.heading1Regular,
    required this.heading2Semibold,
    required this.heading2Medium,
    required this.heading2Regular,
    required this.heading3Semibold,
    required this.heading3Medium,
    required this.heading3Regular,
    required this.heading4Semibold,
    required this.heading4Medium,
    required this.heading4Regular,
    required this.heading5Semibold,
    required this.heading5Medium,
    required this.heading5Regular,
    required this.paragraph1Semibold,
    required this.paragraph1Medium,
    required this.paragraph1Regular,
    required this.paragraph2Semibold,
    required this.paragraph2Medium,
    required this.paragraph2Regular,
  })  : assert(heading1Semibold != null, 'heading1Semibold must not be null'),
        assert(heading1Medium != null, 'heading1Medium must not be null'),
        assert(heading1Regular != null, 'heading1Regular must not be null'),
        assert(heading2Semibold != null, 'heading2Semibold must not be null'),
        assert(heading2Medium != null, 'heading2Medium must not be null'),
        assert(heading2Regular != null, 'heading2Regular must not be null'),
        assert(heading3Semibold != null, 'heading3Semibold must not be null'),
        assert(heading3Medium != null, 'heading3Medium must not be null'),
        assert(heading3Regular != null, 'heading3Regular must not be null'),
        assert(heading4Semibold != null, 'heading4Semibold must not be null'),
        assert(heading4Medium != null, 'heading4Medium must not be null'),
        assert(heading4Regular != null, 'heading4Regular must not be null'),
        assert(heading5Semibold != null, 'heading5Semibold must not be null'),
        assert(heading5Medium != null, 'heading5Medium must not be null'),
        assert(heading5Regular != null, 'heading5Regular must not be null'),
        assert(
            paragraph1Semibold != null, 'paragraph1Semibold must not be null'),
        assert(paragraph1Medium != null, 'paragraph1Medium must not be null'),
        assert(paragraph1Regular != null, 'paragraph1Regular must not be null'),
        assert(
            paragraph2Semibold != null, 'paragraph2Semibold must not be null'),
        assert(paragraph2Medium != null, 'paragraph2Medium must not be null'),
        assert(paragraph2Regular != null, 'paragraph2Regular must not be null');

  factory DesignTextStyle.foundation() {
    return DesignTextStyle._(
      heading1Semibold: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeHeading1,
        fontWeight: _semibold,
        letterSpacing: 0,
        height: 1,
      ),
      heading1Medium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeHeading1,
        fontWeight: _medium,
        letterSpacing: 0,
        height: 1,
      ),
      heading1Regular: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeHeading1,
        fontWeight: _regular,
        letterSpacing: 0,
        height: 1,
      ),
      heading2Semibold: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeHeading2,
        fontWeight: _semibold,
        letterSpacing: 0,
        height: 1,
      ),
      heading2Medium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeHeading2,
        fontWeight: _medium,
        letterSpacing: 0,
        height: 1,
      ),
      heading2Regular: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeHeading2,
        fontWeight: _regular,
        letterSpacing: 0,
        height: 1,
      ),
      heading3Semibold: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeHeading3,
        fontWeight: _semibold,
        letterSpacing: 0,
        height: 1,
      ),
      heading3Medium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeHeading3,
        fontWeight: _medium,
        letterSpacing: 0,
        height: 1,
      ),
      heading3Regular: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeHeading3,
        fontWeight: _regular,
        letterSpacing: 0,
        height: 1,
      ),
      heading4Semibold: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeHeading4,
        fontWeight: _semibold,
        letterSpacing: 0,
        height: 1,
      ),
      heading4Medium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeHeading4,
        fontWeight: _medium,
        letterSpacing: 0,
        height: 1,
      ),
      heading4Regular: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeHeading4,
        fontWeight: _regular,
        letterSpacing: 0,
        height: 1,
      ),
      heading5Semibold: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeHeading5,
        fontWeight: _semibold,
        letterSpacing: 0,
        height: 1,
      ),
      heading5Medium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeHeading5,
        fontWeight: _medium,
        letterSpacing: 0,
        height: 1,
      ),
      heading5Regular: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeHeading5,
        fontWeight: _regular,
        letterSpacing: 0,
        height: 1,
      ),
      paragraph1Semibold: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeParagraph1,
        fontWeight: _semibold,
        letterSpacing: 0,
        height: 1,
      ),
      paragraph1Medium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeParagraph1,
        fontWeight: _medium,
        letterSpacing: 0,
        height: 1,
      ),
      paragraph1Regular: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeParagraph1,
        fontWeight: _regular,
        letterSpacing: 0,
        height: 1,
      ),
      paragraph2Semibold: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeParagraph2,
        fontWeight: _semibold,
        letterSpacing: 0,
        height: 1,
      ),
      paragraph2Medium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeParagraph2,
        fontWeight: _medium,
        letterSpacing: 0,
        height: 1,
      ),
      paragraph2Regular: TextStyle(
        fontFamily: _fontFamily,
        fontSize: _sizeParagraph2,
        fontWeight: _regular,
        letterSpacing: 0,
        height: 1,
      ),
    );
  }

  static const String _fontFamily = 'Montserrat';
  static const FontWeight _semibold = FontWeight.w600;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _regular = FontWeight.normal;
  static const double _sizeHeading1 = 48;
  static const double _sizeHeading2 = 36;
  static const double _sizeHeading3 = 24;
  static const double _sizeHeading4 = 18;
  static const double _sizeHeading5 = 16;
  static const double _sizeParagraph1 = 19;
  static const double _sizeParagraph2 = 16;

  final TextStyle heading1Semibold;
  final TextStyle heading1Medium;
  final TextStyle heading1Regular;

  final TextStyle heading2Semibold;
  final TextStyle heading2Medium;
  final TextStyle heading2Regular;

  final TextStyle heading3Semibold;
  final TextStyle heading3Medium;
  final TextStyle heading3Regular;

  final TextStyle heading4Semibold;
  final TextStyle heading4Medium;
  final TextStyle heading4Regular;

  final TextStyle heading5Semibold;
  final TextStyle heading5Medium;
  final TextStyle heading5Regular;

  final TextStyle paragraph1Semibold;
  final TextStyle paragraph1Medium;
  final TextStyle paragraph1Regular;

  final TextStyle paragraph2Semibold;
  final TextStyle paragraph2Medium;
  final TextStyle paragraph2Regular;
}
