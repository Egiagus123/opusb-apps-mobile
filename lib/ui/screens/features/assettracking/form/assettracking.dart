import 'package:apps_mobile/business_logic/cubit/asset_tracking_cubit.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/ui/screens/features/assettracking/pages/assettracking_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetTracking extends StatefulWidget {
  @override
  State createState() => _AssetTrackingState();
}

class _AssetTrackingState extends State<AssetTracking> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text(
              'Warning !',
              style: TextStyle(fontFamily: 'Oswald'),
            ),
            content: const Text(
              'Do you really want to exit?',
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300],
                ),
                onPressed: () => Navigator.pop(c, true),
                child: Text(
                  'Yes',
                  style: TextStyle(color: purewhiteTheme),
                ),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        body: BlocProvider<AssetTrackingCubit>(
          create: (BuildContext context) => AssetTrackingCubit(),
          child: AssetTrackingHome(),
        ),
      ),
    );
  }
}
