// ignore_for_file: unused_field

import 'dart:async';
import 'dart:io';

import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/main.dart';
import 'package:apps_mobile/ui/screens/dashboard/dashboard_body.dart';
import 'package:apps_mobile/ui/screens/home/app_drawer.dart';
import 'package:apps_mobile/widgets/dialog_util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> with WidgetsBindingObserver {
  Map _source = {ConnectivityResult.mobile: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  final log = getLogger('HomeBody');
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() {
        _source = source;
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivity.disposeStream();
    super.dispose();
  }

  void _switchTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // switch (_source.keys.toList()[0]) {
    //   case ConnectivityResult.wifi:
    //     break;
    //   case ConnectivityResult.mobile:
    //     break;
    //   case ConnectivityResult.none:
    //     _showDialog();
    //     break;
    // }

    if (_source.keys.first == ConnectivityResult.none) {
      _showDialog();
    }

    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                  child: ImageIcon(
                    const AssetImage("assets/stats.png"),
                  ),
                ),
              );
            },
          ),
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
        ),
        body: DashboardBody(),
        drawer: AppDrawer(
          updateTabFunction: _switchTab,
          key: null,
        ),
        extendBodyBehindAppBar: false);
  }

  _showDialog() {
    Future.delayed(Duration(seconds: 2), () {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => buildAlertDialog(
                context,
                title: 'Connection not available',
                content: 'Want to switch to offline mode?',
                proceedText: 'OK',
                proceedCallback: () {
                  RestartWidget.restartApp(context);
                },
                cancelText: 'Cancel',
                cancelCallback: () {
                  Navigator.of(context).pop(false);
                },
              ));
    });
  }
}

Future<ConnectivityResult> check() async {
  ConnectivityResult result = await Connectivity().checkConnectivity();
  return result;
}

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});

    print('isonlien= $result');
  }

  void disposeStream() => controller.close();
}
