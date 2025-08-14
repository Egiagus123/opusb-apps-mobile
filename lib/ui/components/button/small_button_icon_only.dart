import 'package:apps_mobile/ui/themes/design/design_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SmallButtonIconOnly extends StatelessWidget {
  const SmallButtonIconOnly({
    Key? key,
    required this.icon,
    required this.onTap,
  })  : assert(icon != null, 'icon must not be null'),
        super(key: key);

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DesignTheme.of(context)?.color.blue1,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        splashColor: DesignTheme.of(context)?.color.bluePressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: BoxConstraints.tight(Size.square(36)),
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: DesignTheme.of(context)?.color.white,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
