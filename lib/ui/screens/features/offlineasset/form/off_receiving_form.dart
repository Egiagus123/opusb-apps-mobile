import 'package:apps_mobile/business_logic/cubit/asset_trfrcv_cubit.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/pagesreceiving/1_off_receivinglist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfflineAssetRcvForm extends StatefulWidget {
  @override
  State createState() => _OfflineAssetRcvFormState();
}

class _OfflineAssetRcvFormState extends State<OfflineAssetRcvForm> {
  @override
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final result = await showDialog<bool>(
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
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => Navigator.pop(c, false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300],
                ),
                child: Text(
                  'Yes',
                  style: TextStyle(color: purewhiteTheme),
                ),
                onPressed: () => Navigator.pop(c, true),
              ),
            ],
          ),
        );
        return result ??
            false; // <-- fix: convert Future<bool?> to Future<bool>
      },
      child: Scaffold(
        body: BlocProvider<AssetTransferReceivingCubit>(
          create: (BuildContext context) => AssetTransferReceivingCubit(),
          child: OfflineReceivingList(null),
        ),
      ),
    );
  }
}
