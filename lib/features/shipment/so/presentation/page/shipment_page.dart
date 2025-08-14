import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/features/core/domain/usecase/attribute_set_usecase.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_line_entity.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/usecase/shipment_usecase.dart';
import 'package:apps_mobile/features/shipment/so/domain/usecase/so_usecase.dart';
import 'package:apps_mobile/features/shipment/so/presentation/bloc/bloc.dart';
import 'package:apps_mobile/features/shipment/so/presentation/widget/shipment_form.dart';

import '../../../../../service_locator.dart';

class ShipmentPage extends StatefulWidget {
  @override
  State createState() => _ShipmentPageState();
}

class _ShipmentPageState extends State<ShipmentPage> {
  List<ShipmentLineEntity> _shipmentLines = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final result = await showDialog<bool>(
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
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
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
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );

          return result ?? false; // <-- ini pastikan nilai tidak null
        },
        child: Scaffold(
            body: BlocProvider<SoBloc>(
          create: (context) => SoBloc(
              poUseCase: sl<SoUseCase>(),
              shipmentUseCase: sl<ShipmentUseCase>(),
              attributeSetUseCase: sl<AttributeSetUseCase>()),
          child: ShipmentForm(shipmentLines: _shipmentLines),
        )));
  }
}
