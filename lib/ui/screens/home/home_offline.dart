// ignore_for_file: unused_field

import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/ui/screens/dashboard/dashboard_offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart'; // Make sure to import this if using EvaIcons

class HomeOffline extends StatefulWidget {
  static const String routeName = '/home-offline'; // <-- ADD THIS LINE

  @override
  _HomeOfflineState createState() => _HomeOfflineState();
}

class _HomeOfflineState extends State<HomeOffline> with WidgetsBindingObserver {
  final log = getLogger('HomeOffline');
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: Text('Warning'),
                content: Text('Do you really want to exit?'),
                actions: [
                  TextButton(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(c, false),
                  ),
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () => SystemNavigator.pop(),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          shadowColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: purewhiteTheme),
          backgroundColor: Theme.of(context).primaryColor,
          bottom: PreferredSize(
            child: Container(
              alignment: Alignment.center,
              constraints: BoxConstraints.expand(height: 0),
            ),
            preferredSize: Size(1, 1),
          ),
          bottomOpacity: 0,
          elevation: 0.0,
          title: Image.asset(
            'assets/logo2.png',
            fit: BoxFit.fitHeight,
            height: 35,
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(EvaIcons.bellOutline, color: purewhiteTheme),
                onPressed: () {
                  // Add functionality here for the bell icon if needed
                },
              ),
            ),
          ],
        ),
        body: DashboardBodyOffline(),
        extendBodyBehindAppBar: false,
      ),
    );
  }
}
