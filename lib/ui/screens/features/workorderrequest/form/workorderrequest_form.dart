import 'package:apps_mobile/business_logic/cubit/woservice_cubit.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/ui/screens/features/workorderrequest/pages/workorderrequest.dart';
import 'package:apps_mobile/ui/screens/home/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkOrderRequestForm extends StatefulWidget {
  @override
  State createState() => _WorkOrderRequestFormState();
}

class _WorkOrderRequestFormState extends State<WorkOrderRequestForm> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handling the return value to ensure non-nullable bool
        bool? exitConfirmed = await showDialog<bool>(
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
                      fontWeight: FontWeight.bold),
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
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeBody(),
                    ),
                  );
                  Navigator.pop(
                      c, true); // Ensure to return true to confirm exit
                },
              ),
            ],
          ),
        );

        return exitConfirmed ?? false; // Ensure non-nullable return
      },
      child: Scaffold(
        body: BlocProvider<WOServiceCubit>(
          create: (BuildContext context) => WOServiceCubit(),
          child: WorkOrderRequest(),
        ),
      ),
    );
  }
}
