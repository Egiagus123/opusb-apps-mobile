import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/features/core/component/component.dart';
import 'package:apps_mobile/features/core/data/model/reference_model.dart';
import 'package:apps_mobile/features/core/domain/entity/warehouse_entity.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/data/model/imf_model.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_entity.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_line_entity.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement.dart';
import 'package:apps_mobile/features/imf/om/presentation/bloc/bloc.dart';
import 'package:apps_mobile/features/imf/om/presentation/widget/slidinguppanel.dart';

class MovementForm extends StatefulWidget {
  final List<ImfLineEntity> _movementLines;
  MovementForm({
    @required List<ImfLineEntity>? movementLines,
  }) : _movementLines = movementLines!;

  @override
  State createState() {
    return _MovementFormState();
  }
}

class _MovementFormState extends State<MovementForm> {
  final _logger = Logger();
  final _documentNoController = TextEditingController();
  final _warehouseToController = TextEditingController();
  final _locatorToController = TextEditingController();
  List<ImfLineEntity> _movementLines = [];
  List<WarehouseEntity> _warehouses = [];
  List<LocatorEntity> _locators = [];
  int? _warehouseValue;
  int? _locatorValue;
  int? _locatorToValue;
  int count = 0;
  OrderMovement? _om;
  ImfEntity? _movement;
  Screen? size;
  bool? isLargeScreen;

  @override
  void dispose() {
    _documentNoController.dispose();
    _warehouseToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    if (MediaQuery.of(context).size.width > 600) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }
    return BlocListener<OmBloc, OmState>(
        listener: (context, state) => _handleOmState(context, state),
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
                'Inventory Move From',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Oswald',
                    letterSpacing: 1,
                    color: purewhiteTheme),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              bottom: new PreferredSize(
                  child: new Container(
                    padding: EdgeInsets.all(1.0),
                  ),
                  preferredSize: Size.fromHeight(4.0)),
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
                              color: purewhiteTheme,
                              letterSpacing: 1,
                              fontSize: 16,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                          height: double.infinity,
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (_om != null)
                                  ? greenButton
                                  : Colors.transparent,
                              foregroundColor: purewhiteTheme,
                              disabledBackgroundColor: Colors.transparent,
                              disabledForegroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: (_om != null)
                                ? () async {
                                    final proceed = await _confirmAction(
                                      context,
                                      title: 'Submit Confirmation',
                                      content:
                                          'Are you sure you want to submit the document?',
                                    );

                                    if (proceed!) {
                                      BlocProvider.of<OmBloc>(context).add(
                                        OmEventSubmitImf(
                                          imf: _movement!,
                                          locatorId: _locatorValue!,
                                          locatorToId: _locatorToValue!,
                                          lines: _movementLines,
                                        ),
                                      );
                                    }
                                  }
                                : null,
                            child: (_om != null)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/sendbuttonwhite.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "SUBMIT",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Oswald',
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          )),
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
                        SlidingPage(
                          movementLines: _movementLines,
                        ),
                        BlocBuilder<OmBloc, OmState>(
                            builder: (context, state) => Center(
                                child: (state is OmStateLoading)
                                    ? CircularProgressIndicator()
                                    : null))
                      ],
                    )))));
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

  Widget upperPart() {
    return Stack(children: <Widget>[
      Container(
        height: isLargeScreen! ? size?.hp(20) : size?.hp(25),
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
                  child: Column(children: <Widget>[
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
                                    color: pureblackTheme,
                                    fontSize: 14,
                                    fontFamily: 'Montserrat'),
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        if (_om != null) {
                                          final proceed = await _confirmAction(
                                              context,
                                              title: 'Scan Confirmation',
                                              content:
                                                  'Are you sure want to scan another document?');

                                          if (proceed!) {
                                            _resetForm();
                                            BlocProvider.of<OmBloc>(context)
                                              ..add(OmEventDiscardDocument())
                                              ..add(
                                                  OmEventOpenDocumentScanner());
                                          }
                                        } else {
                                          BlocProvider.of<OmBloc>(context).add(
                                              OmEventOpenDocumentScanner());
                                        }
                                      },
                                      alignment: Alignment.bottomRight,
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    isDense: false,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: pureblackTheme),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: pureblackTheme),
                                    ),
                                    labelText: 'Order Movement No',
                                    labelStyle: TextStyle(
                                      color: pureblackTheme,
                                      fontSize: 12,
                                    ))),
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
                              child: DropdownButtonFormField(
                                icon: Icon(
                                  EvaIcons.arrowRight,
                                  color: Theme.of(context).primaryColor,
                                ),
                                value: _warehouseValue,
                                style: TextStyle(
                                    fontFamily: 'Montserrat', fontSize: 14),
                                items: _buildWarehouses(context, _warehouses),
                                selectedItemBuilder: (_) {
                                  return _warehouses
                                      .map((e) => Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              e.name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: pureblackTheme,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12),
                                            ),
                                          ))
                                      .toList();
                                },
                                onChanged: (value) {
                                  _movement!.warehouse =
                                      ReferenceModel(id: value);
                                  setState(() {
                                    _warehouseValue = value;
                                  });

                                  BlocProvider.of<OmBloc>(context).add(
                                      OmEventLoadLocators(
                                          warehouseId: value, isFrom: true));
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelStyle: TextStyle(
                                    color: pureblackTheme,
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
                                  hintText: 'Warehouse (From)',
                                  labelText: 'Warehouse (From)',
                                ),
                                isDense: true,
                                isExpanded: true,
                              ),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Icon(
                              Icons.home,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _warehouseToController,
                                readOnly: true,
                                style: TextStyle(
                                    color: pureblackTheme,
                                    fontFamily: 'Montserrat',
                                    fontSize: 14),
                                decoration: InputDecoration(
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
                                      fontSize: 12,
                                      fontFamily: 'Montserrat'),
                                  hintText: 'Warehouse (To)',
                                  labelText: 'Warehouse (To)',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      color: pureblackTheme),
                                  icon: Icon(
                                    EvaIcons.arrowRight,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  items: _buildLocators(context, _locators),
                                  value: _locatorValue,
                                  selectedItemBuilder: (_) {
                                    return _locators
                                        .map((e) => Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                e.value,
                                                style: TextStyle(
                                                    color: pureblackTheme,
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 14),
                                              ),
                                            ))
                                        .toList();
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _locatorValue = value;
                                    });
                                    BlocProvider.of<OmBloc>(context).add(
                                        OmEventLocatorsChange(
                                            locatorId: _locatorValue!));
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelStyle: TextStyle(
                                      color: pureblackTheme,
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
                                    labelText: 'Locator (From)',
                                  ),
                                  isDense: true,
                                  isExpanded: true,
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
                                width: 20,
                              ),
                              Expanded(
                                child: TextField(
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      color: pureblackTheme),
                                  controller: _locatorToController,
                                  readOnly: true,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelStyle: TextStyle(
                                      color: pureblackTheme,
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
                                    hintText: 'Locator (To)',
                                    labelText: 'Locator (To)',
                                  ),
                                ),
                              ),
                            ])
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ]),
      ),
    ]);
  }

  List<DropdownMenuItem> _buildWarehouses(
      BuildContext context, List<WarehouseEntity> warehouses) {
    return warehouses
        .map((warehouse) => DropdownMenuItem(
              value: warehouse.id,
              child: Text(
                warehouse.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),
              ),
            ))
        .toList();
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

  void _handleOmState(BuildContext context, OmState state) {
    if (state is OmStateDocumentNoScanned) {
      _documentNoController.text = state.documentNo;
    } else if (state is OmStateDocumentLoaded) {
      _om = state.data;
      _warehouseToController.text = _om?.warehouse.identifier ?? '';
      _movement = ImfModel.fromOm(_om!);
      Context().orgId = _om?.organization.id ?? '';
      print('afterrrr scan ^^^^ ${Context().orgId}');

      // Trigger next events if data loaded
      BlocProvider.of<OmBloc>(context)
        ..add(OmEventLoadImfDocType(imfDocTypeId: _om?.docType.id ?? 0))
        ..add(OmEventLoadWarehouses())
        ..add(
            OmEventLoadInTransitLocator(warehouseId: _om?.warehouseTo.id ?? 0));
    } else if (state is OmStateReceiptDocTypeLoaded) {
      _movement!.docType = ReferenceModel(id: state.id);
    } else if (state is OmStateWarehousesLoaded) {
      if (state.warehouses.isNotEmpty) {
        setState(() {
          _warehouses = state.warehouses;
          _warehouseValue = _warehouses[0].id;
        });
        // Load locators once warehouses loaded
        BlocProvider.of<OmBloc>(context).add(
            OmEventLoadLocators(warehouseId: _warehouseValue!, isFrom: true));
      }
    } else if (state is OmStateInTransitLocatorLoaded) {
      _locatorToController.text = state.locator.identifier!;
      _locatorToValue = state.locator.id;

      // Load order lines once locator is loaded
      BlocProvider.of<OmBloc>(context)
          .add(OmEventLoadOrderLines(movement: _om!));
    } else if (state is OmStateLocatorsLoaded) {
      if (state.locators.isNotEmpty) {
        setState(() {
          _locators = state.locators;
          _locatorValue = _locators[0].id;
        });
        // Trigger locators change after locators loaded
        BlocProvider.of<OmBloc>(context)
            .add(OmEventLocatorsChange(locatorId: _locatorValue!));
      }
    } else if (state is OmStateImfCreated) {
      String? documentNo = state.imf.documentNo;
      _logger.i('IMF created with document no.: $documentNo');

      // Show success dialog for document creation
      showDialog(
          context: context,
          builder: (context) => buildAlertDialog(
                context,
                title: 'Document Created',
                content:
                    'IMF has been successfully created. Document No.: $documentNo',
                proceedCallback: () {
                  Navigator.of(context).pop(true);
                },
              )).then((_) {
        _resetForm();
        BlocProvider.of<OmBloc>(context).add(OmEventDiscardDocument());
      });
    } else if (state is OmStateImfLinesUpdate) {
      setState(() {
        _movementLines = state.lines;
        count = state.lines.length;
      });
    }
  }

  void _resetForm() {
    setState(() {
      _documentNoController.text = '';
      _warehouseToController.text = '';
      _warehouses = [];
      _locators = [];
      _locatorToController.text = '';
      _om = null;
      _movement = null;
      _movementLines = [];
      // Menggunakan ScaffoldMessenger untuk menyembunyikan SnackBar
      ScaffoldMessenger.of(context).clearSnackBars();
      count = 0;
    });
  }

  Future<bool?> _confirmAction(BuildContext context,
      {required String title, required String content}) {
    return showDialog<bool>(
          context: context,
          barrierDismissible: false, // Prevent tapping outside to dismiss
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false); // User pressed "No"
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true); // User pressed "Yes"
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        Future.value(false); // Default value in case the dialog is dismissed
  }
}
