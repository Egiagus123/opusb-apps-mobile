import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apps_mobile/features/core/component/component.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/features/core/domain/usecase/attribute_set_usecase.dart';
import 'package:apps_mobile/features/mr/po/domain/usecase/po_usecase.dart';
import 'package:apps_mobile/features/mr/po/presentation/bloc/po_bloc.dart';
import 'package:apps_mobile/features/mr/po/presentation/widget/material_receipt_form.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_line_entity.dart';
import 'package:apps_mobile/features/mr/receipt/domain/usecase/receipt_usecase.dart';

class MaterialReceiptPage extends StatefulWidget {
  @override
  State createState() => _MaterialReceiptPageState();
}

class _MaterialReceiptPageState extends State<MaterialReceiptPage> {
  late List<ReceiptLineEntity> _receiptLines;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(
              'Warning!',
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
                onPressed: () => Navigator.of(c).pop(false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300], // Button color
                ),
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.of(c).pop(true),
              ),
            ],
          ),
        );

        return result ??
            false; // If the result is null (cancelled), return false
      },
      child: Scaffold(
        body: BlocProvider<PoBloc>(
          create: (context) => PoBloc(
            poUseCase: sl<PoUseCase>(),
            receiptUseCase: sl<ReceiptUseCase>(),
            attributeSetUseCase: sl<AttributeSetUseCase>(),
          ),
          child: MaterialReceiptForm(receiptLines: _receiptLines),
        ),
      ),
    );
  }
}
