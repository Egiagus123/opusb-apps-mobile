import 'package:apps_mobile/ui/components/button/small_button_icon_only.dart';
import 'package:apps_mobile/ui/themes/design/design_theme.dart';
import 'package:flutter/material.dart';

class EamAppBar extends StatelessWidget implements PreferredSizeWidget {
  EamAppBar({
    Key? key,
    required this.title,
  })  : assert(title?.isNotEmpty ?? false, 'title must not be empty or null'),
        super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final designTheme = DesignTheme.of(context);
    return AppBar(
      title: Text(
        title,
        style: designTheme?.textStyle.paragraph1Semibold.copyWith(
          color: designTheme.color.blue3,
        ),
      ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      toolbarHeight: preferredSize.height,
      leading: Padding(
        padding: const EdgeInsets.only(
          left: 19,
        ),
        child: Center(
          child: SmallButtonIconOnly(
            icon: Icons.arrow_back,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(79);
}
