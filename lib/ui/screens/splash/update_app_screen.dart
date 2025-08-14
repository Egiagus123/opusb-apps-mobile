import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/business_logic/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UpdateAppScreen extends StatelessWidget {
  static String routeName = "/update-app";

  @override
  Widget build(BuildContext context) {
    // Safe access to route arguments with a fallback message if null
    final Object? message = ModalRoute.of(context)?.settings.arguments ??
        'No additional message available';

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(200),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(10)),
                  padding: EdgeInsets.all(getProportionateScreenWidth(12)),
                  height: getProportionateScreenHeight(250),
                  width: getProportionateScreenWidth(250),
                  child: SvgPicture.asset(
                    'assets/svg/undraw_os_upgrade_nj2m.svg',
                    semanticsLabel: 'Update',
                  ),
                ),
                Text(
                  'Please update your app.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  message.toString(), // Safely display the message
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                  'Version: ${Context().version} Build: ${Context().buildNumber}'),
            ),
          )
        ],
      ),
    );
  }
}
