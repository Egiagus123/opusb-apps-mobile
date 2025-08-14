part of 'design_theme.dart';

class DesignData {
  const DesignData._({
    required this.textStyle,
    required this.color,
  });

  factory DesignData.foundation() {
    return DesignData._(
      textStyle: DesignTextStyle.foundation(),
      color: DesignColor.foundation(),
    );
  }

  final DesignTextStyle textStyle;
  final DesignColor color;

  InputDecoration getInputDecoration({
    bool hasFocus = false,
    bool enabled = true,
    String? errorText,
    IconData? suffixIcon,
  }) {
    final focusColor = color.bluePressed;
    final Color defaultFillColor = const Color(0xffF7F7FD);
    final Color defaultIconColor = const Color(0xff212121);
    final Color disabledColor = const Color(0xffC5C0DB);
    final Color errorColor = const Color(0xffF93232);
    final Color errorBorderColor = const Color(0xffFFD8D8);

    Color fillColor = hasFocus ? color.white : defaultFillColor;
    Color iconColor = hasFocus ? focusColor : defaultIconColor;

    final TextStyle hintStyle = textStyle.paragraph1Regular.copyWith(
      color: enabled ? color.black : disabledColor,
    );

    final TextStyle errorStyle = textStyle.paragraph2Regular.copyWith(
      color: errorColor,
    );

    final InputBorder baseBorder = OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.circular(4.r),
      borderSide: BorderSide.none,
    );

    final InputBorder errorBorder = baseBorder.copyWith(
      borderSide: BorderSide(
        style: BorderStyle.solid,
        width: 1.w,
        color: errorBorderColor,
      ),
    );

    final InputBorder focusBorder = errorBorder.copyWith(
      borderSide: BorderSide(
        color: focusColor,
        width: 1.w,
      ),
    );

    // SuffixIcon hanya muncul jika disediakan
    Widget? suffix;
    if (suffixIcon != null) {
      suffix = Container(
        constraints: BoxConstraints.tight(Size.square(24.r)),
        alignment: Alignment.center,
        child: Icon(
          suffixIcon,
          size: 24.r,
          color: iconColor,
        ),
      );
    }

    return InputDecoration(
      hintStyle: hintStyle,
      errorStyle: errorStyle,
      errorText: errorText,
      contentPadding: EdgeInsets.all(20.r),
      filled: true,
      fillColor: fillColor,
      focusColor: focusColor,
      enabled: enabled,

      // Borders
      border: baseBorder,
      enabledBorder: baseBorder,
      disabledBorder: baseBorder,
      focusedBorder: focusBorder,
      focusedErrorBorder: focusBorder,
      errorBorder: errorBorder,

      // Optional suffix
      suffixIcon: suffix,
    );
  }
}
