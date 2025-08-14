import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:flutter/material.dart';

class TextLineCustom extends StatelessWidget {
  final String? freetext;
  final FontWeight? fontWeight;
  final double? fontSize;
  const TextLineCustom(
      {@required Key? key,
      @required this.freetext,
      @required this.fontWeight,
      @required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      freetext!,
      textAlign: TextAlign.left,
      style: OpusbTheme()
          .blackTextStyle
          .copyWith(fontWeight: fontWeight, fontSize: fontSize),
    );
  }
}
