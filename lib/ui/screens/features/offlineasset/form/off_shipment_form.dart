import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/assetshipment/offline_shipment.dart';
import 'package:flutter/material.dart';

class OfflineShipmentActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OfflineShipmentActivityState();
  }
}

class _OfflineShipmentActivityState extends State<OfflineShipmentActivity> {
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
        return result ?? false;
      },
      child: Scaffold(
        body: OfflineTranscationList(),
      ),
    );
  }
}
