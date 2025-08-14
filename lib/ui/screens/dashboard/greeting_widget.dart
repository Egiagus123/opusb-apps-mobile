import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/business_logic/utils/size_config.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class GreetingWidget extends StatefulWidget {
  @override
  _GreetingWidgetState createState() => _GreetingWidgetState();
}

class _GreetingWidgetState extends State<GreetingWidget> {
  @override
  Widget build(BuildContext context) {
    // return ListTile(

    var bytes;
    bytes = Context().photo;

    return Container(
      height: SizeConfig.screenHeight * 0.24,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Theme.of(context).primaryColor, Color(0xFF81D1F0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight),

        shape: BoxShape.rectangle,
        // color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(70.0),
          bottomRight: Radius.circular(70.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: SizeConfig.screenWidth * 0.03),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Welcome,',
                        style: TextStyle(
                            color: purewhiteTheme,
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        Context().userName.toUpperCase(),
                        style: TextStyle(
                            color: purewhiteTheme,
                            fontFamily: 'Montserrat',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          EvaIcons.bell,
                          color: purewhiteTheme,
                          size: 25,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
