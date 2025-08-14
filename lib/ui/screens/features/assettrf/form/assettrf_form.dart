import 'package:apps_mobile/business_logic/cubit/asset_trfrcv_cubit.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/ui/screens/features/assettrf/pages/asset_trf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetTrfForm extends StatefulWidget {
  @override
  State createState() => _AssetTrfFormState();
}

class _AssetTrfFormState extends State<AssetTrfForm> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show dialog on back press
        bool? exit = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
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
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => Navigator.pop(c, false), // Return false
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300],
                ),
                child: Text(
                  'Yes',
                  style: TextStyle(color: purewhiteTheme),
                ),
                onPressed: () => Navigator.pop(c, true), // Return true
              ),
            ],
          ),
        );

        return exit ??
            false; // If the dialog is dismissed, return false by default
      },
      child: Scaffold(
        body: BlocProvider<AssetTransferReceivingCubit>(
          create: (BuildContext context) => AssetTransferReceivingCubit(),
          child: AssetTrf(),
        ),
      ),
    );
  }
}
