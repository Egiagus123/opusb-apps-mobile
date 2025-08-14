// ignore_for_file: unused_field

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/features/core/component/component.dart';
import 'package:apps_mobile/features/core/data/model/reference_model.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/purchase_order.dart';
import 'package:apps_mobile/features/mr/po/presentation/bloc/bloc.dart';
import 'package:apps_mobile/features/mr/po/presentation/widget/slidinguppanel.dart';

import 'package:apps_mobile/features/mr/receipt/data/model/receipt_model.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_entity.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_line_entity.dart';

class MaterialReceiptForm extends StatefulWidget {
  final List<ReceiptLineEntity> _receiptLines;

  MaterialReceiptForm({required List<ReceiptLineEntity> receiptLines})
      : _receiptLines = receiptLines;

  @override
  State createState() {
    return _MaterialReceiptFormState(receiptLines: _receiptLines);
  }
}

class _MaterialReceiptFormState extends State<MaterialReceiptForm> {
  final _logger = Logger();
  final _documentNoController = TextEditingController();
  final _businessPartnerController = TextEditingController();
  final _warehouseController = TextEditingController();
  late List<DropdownMenuItem> _locatorItems;
  late int _locatorValue;
  PurchaseOrder? _po;
  ReceiptEntity? _receipt;
  List<ReceiptLineEntity>? _receiptLines = [];
  int? count = 0;
  Screen? size;
  List<LocatorEntity>? _locators = [];
  _MaterialReceiptFormState({required List<ReceiptLineEntity> receiptLines})
      : _receiptLines = receiptLines;

  @override
  void dispose() {
    _documentNoController.dispose();
    _businessPartnerController.dispose();
    _warehouseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return BlocListener<PoBloc, PoState>(
        listener: (context, state) => _handlePoState(context, state),
        child: Scaffold(
            appBar: AppBar(
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () => backButtonDrawer(),
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              bottomOpacity: 0,
              title: Text(
                'PO Receipt',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Oswald',
                    letterSpacing: 1,
                    color: Colors.white),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              bottom: new PreferredSize(
                  child: new Container(
                    padding: const EdgeInsets.all(1.0),
                  ),
                  preferredSize: const Size.fromHeight(8.0)),
            ),
            extendBodyBehindAppBar: false,
            bottomNavigationBar: Stack(children: [
              new Container(
                padding: EdgeInsets.only(left: 15),
                height: 50.0,
                color: Theme.of(context).primaryColor,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Line Total : $count',
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1,
                              fontSize: 16,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: double.infinity,
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenButton, // button color
                            disabledForegroundColor:
                                Colors.transparent.withOpacity(0.38),
                            disabledBackgroundColor: Colors.transparent
                                .withOpacity(0.12), // disabled color
                            textStyle: TextStyle(color: Colors.white),
                          ),
                          onPressed: (_po != null)
                              ? () async {
                                  final proceed = await _confirmAction(
                                    context,
                                    title: 'Submit Confirmation',
                                    content:
                                        'Are you sure you want to submit the document?',
                                  );

                                  if (proceed) {
                                    BlocProvider.of<PoBloc>(context).add(
                                      PoEventSubmitReceipt(
                                        receipt: _receipt!,
                                        locatorId: _locatorValue,
                                        lines: _receiptLines!,
                                      ),
                                    );
                                  }
                                }
                              : null,
                          child: (_po != null)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image(
                                      width: 20,
                                      height: 20,
                                      image: AssetImage(
                                          'assets/sendbuttonwhite.png'),
                                    ),
                                    Text(
                                      "SUBMIT",
                                      style: TextStyle(
                                        fontSize: 16,
                                        letterSpacing: 1,
                                        fontFamily: 'Oswald',
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      ),
                    ]),
              ),
            ]),
            backgroundColor: Colors.grey[200],
            body: Container(
                child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        upperPart(),
                        SlidingPage(receiptLines: _receiptLines!),
                        BlocBuilder<PoBloc, PoState>(
                            builder: (context, state) => Center(
                                child: (state is PoStateLoading)
                                    ? CircularProgressIndicator()
                                    : null))
                      ],
                    )))));
  }

  void backButtonDrawer() {
    showDialog(
        context: context,
        builder: (ctx) => buildAlertDialog(ctx,
            title: 'Warning',
            content: 'Do you really want to exit?',
            cancelText: 'No',
            cancelCallback: () {
              Navigator.of(ctx).pop(false);
            },
            proceedText: 'Yes',
            proceedCallback: () {
              Navigator.pop(ctx, true);
              Navigator.pop(ctx, true);
            }));
  }

  Widget upperPart() {
    return Stack(children: <Widget>[
      Container(
        height: size!.getWidthPx(155),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
      ),
      Center(
        child: Column(children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.receipt,
                              color: Theme.of(context).primaryColor),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextField(
                                controller: _documentNoController,
                                textAlign: TextAlign.left,
                                readOnly: true,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Montserrat'),
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        if (_po != null) {
                                          final proceed = await _confirmAction(
                                              context,
                                              title: 'Scan Confirmation',
                                              content:
                                                  'Are you sure want to scan another document?');

                                          if (proceed) {
                                            _resetForm();
                                            BlocProvider.of<PoBloc>(context)
                                              ..add(PoEventDiscardDocument())
                                              ..add(
                                                  PoEventOpenDocumentScanner());
                                          }
                                        } else {
                                          BlocProvider.of<PoBloc>(context).add(
                                              PoEventOpenDocumentScanner());
                                        }
                                      },
                                      alignment: Alignment.bottomRight,
                                      icon: Icon(Icons.camera_alt,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    isDense: false,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    labelText: 'Purchase Order No',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Montserrat',
                                    ))),
                          ),
                        ],
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(
                              EvaIcons.person,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _businessPartnerController,
                                readOnly: true,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    color: Colors.black),
                                decoration: const InputDecoration(
                                  suffixIcon: const Icon(
                                    Icons.person,
                                    color: Color.fromRGBO(255, 255, 255, .3),
                                    size: 30,
                                  ),
                                  isDense: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                  ),
                                  hintText: 'Business Partner',
                                  labelText: 'Business Partner',
                                ),
                              ),
                            ),
                          ]),
                      Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(
                                EvaIcons.home,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _warehouseController,
                                  readOnly: true,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Montserrat',
                                      fontSize: 14),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                    ),
                                    hintText: 'Warehouse',
                                    labelText: 'Warehouse',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Icon(
                                Icons.place,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: DropdownButtonFormField(
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      color: Colors.black),
                                  icon: Icon(
                                    EvaIcons.arrowRight,
                                    color: Theme.of(context)
                                        .primaryColor, // Add this
                                  ),
                                  items: _buildLocators(context, _locators!),
                                  isDense: true,
                                  value: _locatorValue,
                                  selectedItemBuilder: (_) {
                                    return _locators!
                                        .map((e) => Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                e.value,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.black),
                                              ),
                                            ))
                                        .toList();
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _locatorValue = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    // hintText: 'Warehouse (From)',
                                    labelText: 'Locator',
                                  ),
                                  isExpanded: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    ]);
  }

  List<DropdownMenuItem> _buildLocators(
      BuildContext context, List<LocatorEntity> locators) {
    return locators
        .map((locator) => DropdownMenuItem(
              value: locator.id,
              child: Text(
                locator.value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),
              ),
            ))
        .toList();
  }

  void _resetForm() {
    setState(() {
      _po = null;
      _receipt = null;
      _documentNoController.text = '';
      _businessPartnerController.text = '';
      _warehouseController.text = '';
      ScaffoldMessenger.of(context)
          .clearSnackBars(); // To hide any current snack bar
      _receiptLines!.clear(); // To clear the list of receipt lines

      _locators = [];
      count = 0;
    });
  }

  Future<bool> _confirmAction(BuildContext context,
      {required String title, required String content}) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontFamily: 'Oswald'),
          ),
          content: Text(
            content,
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false); // Close dialog and return false
              },
              child: Text(
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
                backgroundColor: Colors.green[300], // Button color
              ),
              onPressed: () {
                Navigator.of(ctx).pop(true); // Close dialog and return true
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    ).then(
        (result) => result ?? false); // Directly return result or false if null
  }

  _handlePoState(BuildContext context, PoState state) {
    if (state is PoStateDocumentNoScanned) {
      _documentNoController.text = state.documentNo;
    } else if (state is PoStateDocumentLoaded) {
      _po = state.data;
      _businessPartnerController.text =
          _po!.businessPartner.identifier!.replaceFirst('-', ' - ');
      _warehouseController.text = _po!.warehouse.identifier!;
      Context().orgId = _po!.organization.id;
      print('afterrrr scan ^^^^ ${Context().orgId}');
      _receipt = ReceiptModel.fromPo(_po!);

      BlocProvider.of<PoBloc>(context)
          .add(PoEventLoadReceiptDocType(poDocTypeId: _po!.docType.id));

      BlocProvider.of<PoBloc>(context)
          .add(PoEventLoadLocators(warehouseId: _po!.warehouse.id));
    } else if (state is PoStateReceiptDocTypeLoaded) {
      _receipt!.docType = ReferenceModel(id: state.id);
    } else if (state is PoStateLocatorsLoaded) {
      setState(() {
        _locators = state.locators;
      });

      if (_locators!.length > 0) {
        _locatorValue = _locators![0].id;
      }

      BlocProvider.of<PoBloc>(context).add(
          PoEventLoadPurchaseOrderLines(po: _po!, locatorId: _locatorValue));
    } else if (state is PoStateReceiptCreated) {
      String documentNo = state.receipt.documentNo!;
      _logger.i('PO Receipt created with document no.: $documentNo');

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => buildAlertDialog(context,
                  title: 'Document Created',
                  content:
                      'PO Receipt has been successfully created. Document No.: $documentNo',
                  proceedText: 'OK', proceedCallback: () {
                Navigator.of(context).pop(true);
              })).then((created) {
        _resetForm();
        BlocProvider.of<PoBloc>(context).add(PoEventDiscardDocument());
      });
    } else if (state is PoStateReceiptLinesUpdate) {
      setState(() {
        this._receiptLines = state.lines;
        this.count = state.lines.length;
      });
    } else if (state is PoStateScanCanceled) {
      _showSnackBar(context, 'Scan canceled', 'Scan canceled', Colors.amber);
    } else if (state is PoStateFailed) {
      _showSnackBar(context, state.message, 'Error');
    }
  }

  void _showSnackBar(BuildContext context, String message, String notify,
      [Color color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(days: 365),
      action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }),
      content: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: notify),
            TextSpan(text: ', click '),
            TextSpan(
                text: 'here',
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => buildAlertDialog(context,
                                title: notify,
                                content: message,
                                proceedText: 'OK', proceedCallback: () {
                              Navigator.pop(context);
                            }));
                  }),
            TextSpan(text: ' for details.')
          ],
        ),
      ),
      backgroundColor: color,
    ));
  }
}
