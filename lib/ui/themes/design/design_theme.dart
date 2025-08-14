// ignore_for_file: unnecessary_null_comparison

import 'package:apps_mobile/ui/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'design_text_style.dart';
part 'design_color.dart';
part 'design_data.dart';

class DesignTheme extends InheritedWidget {
  DesignTheme({
    Key? key,
    required this.data,
    required Widget child,
  })  : assert(data != null, 'data must not be null'),
        assert(child != null, 'child must not be null'),
        super(key: key, child: child);

  static DesignData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DesignTheme>()?.data;
  }

  static DesignData? of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No DesignTheme found in context');
    return result;
  }

  final DesignData data;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    if (oldWidget is DesignTheme) {
      return oldWidget.data != data;
    }
    return false;
  }
}
