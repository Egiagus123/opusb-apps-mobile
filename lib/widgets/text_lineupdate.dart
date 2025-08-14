import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:flutter/material.dart';

class TextLineUpdateCustom extends StatelessWidget {
  final String? freetext;
  final String? title;
  final FontWeight? fontWeight;
  final double? fontSize;
  const TextLineUpdateCustom({
    @required Key? key,
    @required this.title,
    @required this.freetext,
    @required this.fontWeight,
    @required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          textAlign: TextAlign.left,
          style: OpusbTheme().blackTextStyle.copyWith(
                fontSize: 10,
              ),
        ),
        Text(
          freetext!,
          textAlign: TextAlign.left,
          style: OpusbTheme().blackTextStyle.copyWith(
                fontWeight: fontWeight,
                fontSize: 16,
              ),
        ),
      ],
    );
  }
}
