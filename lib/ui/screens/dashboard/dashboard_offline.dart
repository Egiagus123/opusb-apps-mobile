import 'package:flutter/material.dart';
import 'greeting_widget.dart';
import 'menu_widget_offline.dart';

class DashboardBodyOffline extends StatefulWidget {
  static String routeName = "/dashboard";
  @override
  _DashboardBodyOfflineState createState() => _DashboardBodyOfflineState();
}

class _DashboardBodyOfflineState extends State<DashboardBodyOffline>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2));
      },
      child: ListView(
        // padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          Container(
              height: 10,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 0, color: Theme.of(context).primaryColor),
                  bottom: BorderSide(
                      width: 0, color: Theme.of(context).canvasColor),
                ),
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                ],
              )),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: MenuWidgetOffline(),
          ),
        ],
      ),
    );
  }
}
