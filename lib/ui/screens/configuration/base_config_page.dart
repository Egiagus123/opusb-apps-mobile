import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:flutter/material.dart';

class BaseConfigPage extends StatelessWidget {
  final bool? isDarkMode;
  BaseConfigPage({this.isDarkMode});
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[topHalf(context), bottomHalf(context, isDarkMode!)],
    );
  }

  Widget topHalf(BuildContext context) {
    return new Flexible(
      flex: 2,
      child: ClipPath(
        child: Stack(
          children: <Widget>[
            new Container(
              decoration:
                  new BoxDecoration(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomHalf(BuildContext context, bool isDarkMode) {
    return new Flexible(
      flex: 3,
      child: new Container(
        decoration: new BoxDecoration(
            color: isDarkMode ? Colors.grey[850] : purewhiteTheme),
      ),
    );
  }
}
