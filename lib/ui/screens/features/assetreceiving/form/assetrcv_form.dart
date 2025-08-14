import 'dart:async';
import 'package:apps_mobile/business_logic/cubit/asset_trfrcv_cubit.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/conn.dart';
import 'package:apps_mobile/ui/screens/features/assetreceiving/pages/assetrcv.dart';
import 'package:apps_mobile/widgets/dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetRcvForm extends StatefulWidget {
  @override
  State createState() => _AssetRcvFormState();
}

class _AssetRcvFormState extends State<AssetRcvForm> {
  late StreamSubscription _connectionChangeStream;

  bool isOffline = false;
  bool _isDialogShowing = false;
  @override
  initState() {
    super.initState();

    var connectionStatus = ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      _isDialogShowing = !hasConnection;
      if (_isDialogShowing) {
        _showDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Tampilkan dialog dan tunggu hasilnya
        bool? shouldExit = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(
              'Warning !',
              style: TextStyle(fontFamily: 'Oswald'),
            ),
            content: Text(
              'Do you really want to exit?',
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // No button
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      Colors.green[300], // Yes button background color
                ),
                onPressed: () => Navigator.pop(context, true), // Yes button
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.white, // assuming purewhiteTheme is white
                  ),
                ),
              ),
            ],
          ),
        );

        // Mengembalikan false jika dialog mengembalikan null atau jika 'No' dipilih
        return shouldExit ?? false;
      },
      child: Scaffold(
        body: BlocProvider<AssetTransferReceivingCubit>(
          create: (BuildContext context) => AssetTransferReceivingCubit(),
          child: AssetRcv(),
        ),
      ),
    );
  }

  _showDialog() {
    _isDialogShowing
        ? Future.delayed(Duration(seconds: 2), () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => buildAlertDialog(
                      context,
                      title: 'Connection not available',
                      content: 'Want to switch to offline mode?',
                      proceedText: 'OK',
                      proceedCallback: () {
                        Navigator.of(context).pop(true);
                      },
                      cancelText: 'Cancel',
                      cancelCallback: () {
                        Navigator.of(context).pop(true);
                      },
                    ));
          })
        : Container();
  }
}
