import 'package:apps_mobile/ui/themes/design/design_theme.dart';
import 'package:flutter/material.dart';

class WrapTitle extends StatelessWidget {
  const WrapTitle({
    Key? key,
    required this.title,
    required this.child,
  })  : assert(child != null, 'title must not be null'),
        super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) {
      return child;
    }

    final design = DesignTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: design?.textStyle.heading5Semibold.copyWith(
            color: design.color.black,
          ),
        ),
        SizedBox(height: 10),
        child,
      ],
    );
  }
}
