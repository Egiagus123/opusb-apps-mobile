import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/features/core/component/component.dart';
import 'package:apps_mobile/features/core/data/model/reference_model.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/features/imt/imt/data/model/imt_model.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_entity.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_line_entity.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/locator_entity.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement.dart';
import 'package:apps_mobile/features/imt/om/presentation/bloc/bloc.dart';
import 'package:apps_mobile/features/imt/om/presentation/widget/slidinguppanel.dart';

class ImtForm extends StatefulWidget {
  final List<ImtLineEntity> _movementLines;

  ImtForm({required List<ImtLineEntity> movementLines})
      : _movementLines = movementLines;

  @override
  State createState() {
    return _ImtFormState();
  }
}

class _ImtFormState extends State<ImtForm> {
  final _logger = Logger();
  final _documentNoController = TextEditingController();
  final _warehouseController = TextEditingController();
  final _warehouseToController = TextEditingController();
  final _locatorItems = TextEditingController();
  List<LocatorEntity> _locators = [];
  List<ImtLineEntity> _movementLines = [];
  late int _locatorFrom;
  late int _locatorToValue;
  late OrderMovement _om;
  late ImtEntity _imtEntity;
  int count = 0;
  late Screen size;
  late bool isLargeScreen;

  @override
  void dispose() {
    _documentNoController.dispose();
    _warehouseController.dispose();
    _warehouseToController.dispose();
    _locatorItems.dispose();
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
            //drawer: OpusBNavDrawer(),
            appBar: AppBar(
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: purewhiteTheme,
                  ),
                  onPressed: () => backButtonDrawer(),
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              bottomOpacity: 0,
              title: Text(
                'Inventory Move To',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Oswald',
                    color: purewhiteTheme,
                    letterSpacing: 1),
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
                                  horizontal: 16, vertical: 12),
                            ),
                            onPressed: (_om != null)
                                ? () async {
                                    final proceed = await _confirmAction(
                                      context,
                                      title: 'Submit Confirmation',
                                      content:
                                          'Are you sure want to submit the document?',
                                    );

                                    if (proceed) {
                                      BlocProvider.of<OmBloc>(context).add(
                                        OmEventSubmitImt(
                                          receipt: _imtEntity,
                                          locatorId: _locatorFrom,
                                          locatorTo: _locatorToValue,
                                          lines: widget._movementLines,
                                        ),
                                      );
                                    }
                                  }
                                : null,
                            child: (_om != null)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                          letterSpacing: 1,
                                          fontFamily: 'Oswald',
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
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
                          movementLines: widget._movementLines,
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
        height: isLargeScreen ? size.hp(20) : size.hp(25),
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
                  child: Column(children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
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
                                  color: pureblackTheme, fontSize: 14),
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      if (_om != null) {
                                        final proceed = await _confirmAction(
                                            context,
                                            title: 'Scan Confirmation',
                                            content:
                                                'Are you sure want to scan another document?');

                                        if (proceed) {
                                          _resetForm();
                                          BlocProvider.of<OmBloc>(context)
                                            ..add(OmEventDiscardDocument())
                                            ..add(OmEventOpenDocumentScanner());
                                        }
                                      } else {
                                        BlocProvider.of<OmBloc>(context)
                                            .add(OmEventOpenDocumentScanner());
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
                                    fontFamily: 'Montserrat',
                                  ))),
                        ),
                      ],
                    ),
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
                                    color: pureblackTheme,
                                    fontSize: 14,
                                    fontFamily: 'Montserrat'),
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
                                  hintText: 'Warehouse (From)',
                                  labelText: 'Warehouse (From)',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Icon(
                              EvaIcons.home,
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
                                child: TextField(
                                  style: TextStyle(
                                      color: pureblackTheme,
                                      fontFamily: 'Montserrat',
                                      fontSize: 14),
                                  controller: _locatorItems,
                                  readOnly: true,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelStyle: TextStyle(
                                      color: pureblackTheme,
                                      fontSize: 12,
                                      fontFamily: 'Montserrat',
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: pureblackTheme),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: pureblackTheme),
                                    ),
                                    hintText: 'Locator (From)',
                                    labelText: 'Locator (From)',
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
                                width: 20,
                              ),
                              Expanded(
                                child: DropdownButtonFormField(
                                  style: TextStyle(
                                      color: pureblackTheme,
                                      fontFamily: 'Montserrat',
                                      fontSize: 14),
                                  icon: Icon(
                                    // Add this
                                    EvaIcons.arrowRight,
                                    color: Theme.of(context)
                                        .primaryColor, // Add this
                                  ),
                                  items: _buildLocators(context, _locators),
                                  value: _locatorToValue,
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
                                      _locatorToValue = value;
                                    });
                                    BlocProvider.of<OmBloc>(context).add(
                                        OmEventLocatorsChange(
                                            locatorId: _locatorToValue));
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelStyle: TextStyle(
                                      color: pureblackTheme,
                                      fontSize: 12,
                                      fontFamily: 'Montserrat',
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
                                    labelText: 'Locator (To)',
                                  ),
                                  isDense: true,
                                  isExpanded: true,
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

  void _resetForm() {
    setState(() {
      _documentNoController.text = '';
      _warehouseController.text = '';
      _warehouseToController.text = '';
      _locatorItems.text = '';
      count = 0;
      _movementLines = [];
      _om;
      _imtEntity;
      _locators = [];
      // Use ScaffoldMessenger instead of Scaffold for hiding SnackBar
      ScaffoldMessenger.of(context).clearSnackBars();
    });
  }

  Future<bool> _confirmAction(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    return showDialog<bool>(
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
    ).then((value) => value ?? false); // default to false if dismissed
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

  _handleOmState(BuildContext context, OmState state) {
    if (state is OmStateDocumentNoScanned) {
      _documentNoController.text = state.documentNo;
    } else if (state is OmStateDocumentLoaded) {
      _om = state.data;
      _warehouseController.text = _om.warehouse.identifier!;
      _warehouseToController.text = _om.warehouseTo.identifier!;
      _imtEntity = ImtModel.fromPo(_om);

      BlocProvider.of<OmBloc>(context)
        ..add(OmEventLoadImtDocType(poDocTypeId: _om.docType.id))
        ..add(OmEventLoadLocatorsTransit(
          warehouseFromId: _om.warehouseTo.id,
        ))
        ..add(OmEventLoadLocators(
          warehouseId: _om.warehouseTo.id,
        ));
    } else if (state is OmStateImtDocTypeLoaded) {
      _imtEntity.docType = ReferenceModel(id: state.id);
    } else if (state is OmStateLocatorsTransitLoaded) {
      _locatorItems.text = state.locators.toString();
      _locatorFrom = state.locatorsId;
    } else if (state is OmStateLocatorsLoaded) {
      setState(() {
        _locators = state.locators;

        if (_locators.length > 0) {
          _locatorToValue = _locators[0].id;
        }
      });
      BlocProvider.of<OmBloc>(context)
          .add(OmEventLocatorsChange(locatorId: _locatorFrom));

      BlocProvider.of<OmBloc>(context)
          .add(OmEventLoadOrderLines(movement: _om));
    } else if (state is OmStateImtCreated) {
      String? documentNo = state.receipt.documentNo;
      _logger.i('Imt created with document no.: $documentNo');

      showDialog(
          context: context,
          builder: (context) => buildAlertDialog(context,
                  title: 'Document Created',
                  content:
                      'IMT has been successfully created. Document No.: $documentNo',
                  proceedCallback: () {
                Navigator.of(context).pop(true);
              })).then((_) {
        _resetForm();
        BlocProvider.of<OmBloc>(context).add(OmEventDiscardDocument());
      });
    } else if (state is OmStateImtLinesUpdate) {
      setState(() {
        this._movementLines = state.lines;
        this.count = state.lines.length;
      });
    }
  }
}
