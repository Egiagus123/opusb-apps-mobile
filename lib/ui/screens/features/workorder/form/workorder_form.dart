// import 'package:apps_mobile/business_logic/cubit/asset_trfrcv_cubit.dart';
import 'package:apps_mobile/business_logic/cubit/woservice_cubit.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
// import 'package:apps_mobile/ui/screens/features/assettrf/pages/asset_trf.dart';
import 'package:apps_mobile/ui/screens/features/workorder/pages/workorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkOrderForm extends StatefulWidget {
  const WorkOrderForm({super.key});

  @override
  State<WorkOrderForm> createState() => _WorkOrderFormState();
}

class _WorkOrderFormState extends State<WorkOrderForm> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showExitConfirmationDialog,
      child: Scaffold(
        body: BlocProvider<WOServiceCubit>(
          create: (BuildContext context) => WOServiceCubit(),
          child: WorkOrder(),
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog() async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Warning!',
          style: TextStyle(fontFamily: 'Oswald'),
        ),
        content: const Text(
          'Do you really want to exit?',
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
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
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Yes',
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
