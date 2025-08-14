import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';
import 'package:apps_mobile/business_logic/cubit/auth_cubit.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/business_logic/utils/keys.dart';
import 'package:apps_mobile/features/core/component/component.dart';
import 'package:apps_mobile/features/core/data/model/reference_model.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/features/shipment/shipment/data/model/shipment_model.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_entity.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_line_entity.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/sales_order.dart';
import 'package:apps_mobile/features/shipment/so/presentation/bloc/bloc.dart';
import 'package:apps_mobile/ui/screens/configuration/pin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../service_locator.dart';
import 'slidinguppanel.dart';

class ShipmentForm extends StatefulWidget {
  final List<ShipmentLineEntity> _shipmentLines;

  ShipmentForm({required List<ShipmentLineEntity> shipmentLines})
      : _shipmentLines = shipmentLines;

  @override
  State createState() {
    return _ShipmentFormState(shipmentLines: _shipmentLines);
  }
}

class _ShipmentFormState extends State<ShipmentForm>
    with WidgetsBindingObserver {
  final _logger = Logger();
  final _documentNoController = TextEditingController();
  final _businessPartnerController = TextEditingController();
  final _warehouseController = TextEditingController();
  List<LocatorEntity>? _locators = [];
  List<DropdownMenuItem>? _locatorItems = [];
  int? _locatorValue;
  SalesOrder? _po;
  bool? isScan;
  bool? fingerPrint = false;
  ShipmentEntity? _shipmentEntity;
  List<ShipmentLineEntity>? _shipmentLines;
  int count = 0;
  Screen? size;
  String? pin = sl<SharedPreferences>().getString(Keys.pin);
  final LocalAuthentication auth = LocalAuthentication();

  _ShipmentFormState({required List<ShipmentLineEntity> shipmentLines})
      : _shipmentLines = shipmentLines;
  // @override
  // Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
  //   print('fingerPrint');
  //   super.didChangeAppLifecycleState(state);
  //   final fingerPrintStatus = await _fingerPrintStatus();
  //   final pinOn = await _pinStatus();
  //   print('scan di shpment $isScan');
  //   if (isScan == false) {
  //     if (state == AppLifecycleState.resumed ||
  //         state == AppLifecycleState.paused) {
  //       if (fingerPrintStatus) {
  //         var fingerTrue = await auth.authenticateWithBiometrics(
  //             localizedReason: 'Scan your fingerprint to authenticate',
  //             useErrorDialogs: true,
  //             stickyAuth: true);

  //         if (!fingerTrue) {
  //           if (pinOn)
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => PinPutPage(pin: pin)));
  //         }
  //       } else if (pinOn) {
  //         Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => PinPutPage(pin: pin)));
  //       }
  //     }
  //   }
  //   if (state == AppLifecycleState.paused) {
  //     if (isScan) isScan = false;
  //   }
  // }

  @override
  void dispose() {
    _documentNoController.dispose();
    _businessPartnerController.dispose();
    _warehouseController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // Future<bool> _fingerPrintStatus() async {
  //   final fingerPrint = sl<SharedPreferences>().getBool(Keys.fingerOn);
  //   if (fingerPrint == null) {
  //     return false;
  //   }
  //   return fingerPrint;
  // }

  // Future<bool> _pinStatus() async {
  //   final fingerPrint = sl<SharedPreferences>().getString(Keys.pin);
  //   if (fingerPrint == null) {
  //     return false;
  //   }
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return BlocListener<SoBloc, SoState>(
        listener: (context, state) => _handleSoState(context, state),
        child: Scaffold(
            //  drawer: OpusBNavDrawer(),
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
                'SHIPMENT',
                style: TextStyle(
                    //fontWeight: FontWeight.bold,
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
                        child: MaterialButton(
                          disabledColor: Colors.transparent,
                          disabledTextColor: Colors.transparent,
                          color: greenButton,
                          onPressed: (_po != null)
                              ? () async {
                                  final proceed = await _confirmAction(context,
                                      title: 'Submit Confirmation',
                                      content:
                                          'Are you sure want to submit the document?');

                                  if (proceed) {
                                    BlocProvider.of<SoBloc>(context).add(
                                        SoEventSubmitShipment(
                                            shipment: _shipmentEntity!,
                                            locatorId: _locatorValue!,
                                            lines: _shipmentLines!));
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
                                            'assets/sendbuttonwhite.png')),
                                    Text(
                                      "SUBMIT",
                                      style: TextStyle(
                                        fontSize: 16,
                                        letterSpacing: 1,
                                        fontFamily: 'Oswald',
                                        // fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                          textColor: Colors.white,
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
                        SlidingPage(shipmentLines: _shipmentLines!),
                        BlocBuilder<SoBloc, SoState>(
                            builder: (context, state) => Center(
                                child: (state is SoStateLoading)
                                    ? CircularProgressIndicator()
                                    : null))
                      ],
                    )))));
  }

  Widget upperPart() {
    return Stack(children: <Widget>[
      Container(
        height: size!.getWidthPx(200),
        decoration: BoxDecoration(
          color: purewhiteTheme,
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
                    children: <Widget>[
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
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
                                      color: pureblackTheme, fontSize: 14),
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
                                                isScan = true;
                                                sl<SharedPreferences>()
                                                    .setBool('isScan', isScan!);
                                                _resetForm();
                                                BlocProvider.of<SoBloc>(context)
                                                  ..add(
                                                      SoEventDiscardDocument())
                                                  ..add(
                                                      SoEventOpenDocumentScanner());
                                              }
                                            } else {
                                              isScan = true;
                                              sl<SharedPreferences>()
                                                  .setBool('isScan', isScan!);
                                              BlocProvider.of<SoBloc>(context).add(
                                                  SoEventOpenDocumentScanner());
                                            }
                                          },
                                          alignment: Alignment.bottomRight,
                                          icon: Icon(
                                            Icons.camera_alt,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                      isDense: false,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: pureblackTheme),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: pureblackTheme),
                                      ),
                                      labelText:
                                          (_po == null) ? 'Sales Order No' : '',
                                      labelStyle: TextStyle(
                                        color: pureblackTheme,
                                        fontSize: 12,
                                        fontFamily: 'Montserrat',
                                      ))),
                            ),
                          ]),
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
                                    color: pureblackTheme, fontSize: 14),
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.person,
                                    color: Color.fromRGBO(255, 255, 255, .3),
                                    size: 30,
                                  ),
                                  isDense: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: pureblackTheme),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: pureblackTheme),
                                  ),
                                  labelStyle: TextStyle(
                                    color: pureblackTheme,
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                  ),
                                  // hintText: 'Business Partner',
                                  labelText: 'Business Partner',
                                ),
                              ),
                            ),
                          ]),
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
                                  color: pureblackTheme,
                                  fontFamily: 'Montserrat',
                                  fontSize: 14),
                              decoration: InputDecoration(
                                isDense: false,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: pureblackTheme),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: pureblackTheme),
                                ),
                                labelStyle: TextStyle(
                                  color: pureblackTheme,
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                ),
                                // hintText: 'Warehouse',
                                labelText: 'Warehouse',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.place,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: DropdownButtonFormField(
                                style: TextStyle(
                                    color: pureblackTheme, fontSize: 14),
                                icon: Icon(
                                    // Add this
                                    EvaIcons.arrowRight, // Add this
                                    color: Theme.of(context).primaryColor),
                                items: _buildLocators(context, _locators!),
                                isDense: true,
                                value: _locatorValue,
                                selectedItemBuilder: (_) {
                                  return _locators!
                                      .map((e) => Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              e.value!,
                                              style: TextStyle(
                                                  color: pureblackTheme),
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
                                    color: pureblackTheme,
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: pureblackTheme),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: pureblackTheme),
                                  ),
                                  // hintText: 'Warehouse (From)',
                                  labelText: 'Locator',
                                ),
                                isExpanded: true,
                              ),
                            ),
                          ])
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

  void backButtonDrawer() {
    showDialog(
        barrierDismissible: false,
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

  List<DropdownMenuItem> _buildLocators(
      BuildContext context, List<LocatorEntity> locators) {
    return locators
        .map((locator) => DropdownMenuItem(
              value: locator.id,
              child: Text(
                locator.value!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: pureblackTheme),
              ),
            ))
        .toList();
  }

  void _resetForm() {
    setState(() {
      _po = null;
      _documentNoController.text = '';
      _businessPartnerController.text = '';
      _warehouseController.text = '';
      _locators = [];
      _shipmentLines!.clear();
      count = 0;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }

  Future<bool> _confirmAction(BuildContext context,
      {required String title, required String content}) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => buildAlertDialog(
        ctx,
        title: title,
        content: content,
        cancelText: 'No',
        cancelCallback: () {
          Navigator.of(ctx).pop(false);
        },
        proceedText: 'Yes',
        proceedCallback: () {
          Navigator.of(ctx).pop(true);
        },
      ),
    );

    return result ?? false; // Pastikan tidak null, kembalikan false jika null.
  }

  _initApp(context, value) {
    BlocProvider.of<AuthCubit>(context).isScan(value);
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
            TextSpan(text: '. Click '),
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

  _handleSoState(BuildContext context, SoState state) {
    if (state is SoStateDocumentNoScanned) {
      isScan = true;
      _documentNoController.text = state.documentNo;
      _initApp(context, isScan);
    } else if (state is SoStateDocumentLoaded) {
      isScan = true;
      _po = state.data;
      _businessPartnerController.text =
          _po!.businessPartner!.identifier!.replaceFirst('-', ' - ');
      _warehouseController.text = _po!.warehouse!.identifier!;
      _shipmentEntity = ShipmentModel.fromPo(_po!);
      _logger.i(_po!.docTypeTarget!.id);
      BlocProvider.of<SoBloc>(context)
        ..add(SoEventLoadShipmentDocType(poDocTypeId: _po!.docTypeTarget!.id))
        ..add(SoEventLoadLocators(warehouseId: _po!.warehouse!.id));
    } else if (state is SoStateShipmentDocTypeLoaded) {
      _shipmentEntity!.docType = ReferenceModel(id: state.id);
    } else if (state is SoStateLocatorsLoaded) {
      setState(() {
        _locators = state.locators;
      });

      if (_locators!.length > 0) {
        _locatorValue = _locators![0].id;
      }

      BlocProvider.of<SoBloc>(context)
          .add(SoEventLoadOrderLines(so: _po!, locatorId: _locatorValue!));
    } else if (state is SoStateShipmentCreated) {
      String documentNo = state.shipment.documentNo!;
      _logger.i('SO Shipment created with document no.: $documentNo');

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => buildAlertDialog(context,
                  title: 'Document Created',
                  content:
                      'SO Shipment has been successfully created. Document No.: $documentNo',
                  proceedText: 'OK', proceedCallback: () {
                Navigator.pop(context);
              })).then((_) {
        _resetForm();
        BlocProvider.of<SoBloc>(context).add(SoEventDiscardDocument());
      });
    } else if (state is SoStateShipmentLinesUpdate) {
      setState(() {
        this._shipmentLines = state.lines;
        this.count = state.lines.length;
      });
    } else if (state is SoStateScanCanceled) {
      isScan = false;
      sl<SharedPreferences>().setBool('isScan', isScan!);
      _showSnackBar(context, 'Scan canceled', 'Scan canceled', Colors.amber);
    } else if (state is SoStateSerialNoDuplication) {
      _showSnackBar(context, state.message, '', Colors.amber);
    } else if (state is SoStateFailed) {
      _showSnackBar(context, state.message, 'Error');
    }
  }
}
