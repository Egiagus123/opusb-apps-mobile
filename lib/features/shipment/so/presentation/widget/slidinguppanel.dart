import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logger/logger.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
// import 'package:apps_mobile/features/core/component/component.dart';
import 'package:apps_mobile/features/shipment/shipment/data/model/shipment_line_model.dart';
import 'package:apps_mobile/features/shipment/shipment/domain/entity/shipment_line_entity.dart';
import 'package:apps_mobile/features/shipment/so/domain/entity/order_line.dart';
import 'package:apps_mobile/features/shipment/so/presentation/bloc/bloc.dart';

class SlidingPage extends StatefulWidget {
  final List<ShipmentLineEntity> _shipmentLines;

  SlidingPage({required List<ShipmentLineEntity> shipmentLines})
      : _shipmentLines = shipmentLines;

  @override
  _SlidingPageState createState() => _SlidingPageState();
}

class _SlidingPageState extends State<SlidingPage> {
  final Map<String, ShipmentLineEntity> _cachedAttributeSets = {};
  final Map<String, TextEditingController> _quantityControllers = {};
  List<ShipmentLineEntity>? lines;
  var isSelected = false;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SoBloc, SoState>(
        listener: (context, state) => _handleSoState(context, state),
        child: BlocBuilder<SoBloc, SoState>(builder: (context, state) {
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: count,
                        itemBuilder: (BuildContext context, int position) {
                          var shipLine = this.lines![position];
                          var soLine = this.lines![position].orderLine;
                          var attributed = shipLine.attributeSetInstance == null
                              ? ''
                              : shipLine.attributeSetInstance?.identifier;
                          bool? selected = shipLine.selected;
                          return Card(
                              elevation: 3,
                              color: purewhiteTheme,
                              child: Padding(
                                padding: EdgeInsets.all(2),
                                child: Stack(children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Checkbox(
                                        value: selected,
                                        onChanged: (value) => setState(
                                            () => shipLine.selected = value)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: ListTile(
                                      onTap: () async {
                                        var quantity = await _showQuickDetail(
                                            context, soLine!, shipLine);
                                        setState(() {
                                          shipLine.quantity =
                                              double.tryParse(quantity)!;
                                        });
                                      },
                                      dense: true,
                                      title: Text(
                                        this
                                            .lines![position]
                                            .product!
                                            .identifier!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat',
                                            fontSize: 14),
                                      ),
                                      subtitle: Container(
                                          child: Padding(
                                        padding:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        child: Row(
                                          children: <Widget>[
                                            cardDetail(
                                                'Quantity : ${shipLine.qtyEntered} (${shipLine.uom!.identifier})'),
                                            shipLine.attributeSet != null
                                                ? cardDetail(
                                                    'Attribute Set : $attributed')
                                                : cardDetail(''),
                                          ],
                                        ),
                                      )),
                                    ),
                                  ),
                                  shipLine.attributeSet != null
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, right: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              IconButton(
                                                icon: Image.asset(
                                                    'assets/scan.png'),
                                                iconSize: 5,
                                                onPressed: () async {
                                                  String scanMode =
                                                      shipLine.isSerNo!
                                                          ? 'serNo'
                                                          : 'lot';
                                                  BlocProvider.of<SoBloc>(
                                                          context)
                                                      .add(SoEventOpenAsiScanner(
                                                          scanMode: scanMode,
                                                          line: shipLine,
                                                          scannedAttributeSets:
                                                              _cachedAttributeSets));
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(height: 0),
                                ]),
                              ));
                        }))
              ],
            ),
          );
        }));
  }

  @override
  void dispose() {
    _quantityControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Widget cardDetail(String title) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'Montserrat',
            ),
          )
        ],
      ),
    );
  }

  Future<String> _showQuickDetail(
      BuildContext context, OrderLine poLine, ShipmentLineEntity shipmentLine) {
    final quantityController =
        TextEditingController(text: shipmentLine.qtyEntered.toString());
    double? initialvalue = shipmentLine.qtyEntered;

    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'Line Detail',
          style: TextStyle(fontFamily: 'Oswald', letterSpacing: 1),
        ),
        contentPadding: const EdgeInsets.only(
            left: 24.0, top: 12.0, right: 24.0, bottom: 16.0),
        children: <Widget>[
          TextFormField(
            readOnly: true,
            initialValue: poLine.product!.identifier,
            style: TextStyle(fontFamily: 'Montserrat'),
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              labelText: 'Product Name',
              labelStyle: TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
          TextFormField(
            readOnly: true,
            initialValue: poLine.qtyOrdered.toString(),
            style: TextStyle(fontFamily: 'Montserrat'),
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              labelText: 'SO Quantity',
              labelStyle: TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
          TextField(
            onTap: () => quantityController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: quantityController.value.text.length),
            decoration: InputDecoration(
              counterText: '',
              labelText: 'Input Quantity',
              labelStyle: TextStyle(fontFamily: 'Montserrat'),
            ),
            controller: quantityController,
            style: TextStyle(fontFamily: 'Montserrat'),
            keyboardType: TextInputType.number,
            autofocus: true,
            onChanged: (value) {
              // Cek apakah input valid (angka positif)
              double? parsedValue = double.tryParse(value);
              if (parsedValue == null || parsedValue < 0) {
                shipmentLine.quantity = initialvalue!;
                quantityController.value = TextEditingValue(
                    text: initialvalue.toString(),
                    selection: TextSelection.fromPosition(
                        TextPosition(offset: initialvalue.toString().length)));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: const Text("Quantity can't be negative")));
              } else {
                shipmentLine.quantity = parsedValue;
              }
            },
          ),
          TextFormField(
            style: TextStyle(fontFamily: 'Montserrat'),
            readOnly: true,
            initialValue: shipmentLine.uom!.identifier,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              labelText: 'UoM',
              labelStyle: TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
          shipmentLine.attributeSet != null
              ? TextFormField(
                  style: TextStyle(fontFamily: 'Montserrat'),
                  readOnly: true,
                  initialValue: shipmentLine.attributeSetInstance?.identifier,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    labelText: 'Attribute Set Instance',
                    labelStyle: TextStyle(fontFamily: 'Montserrat'),
                  ),
                )
              : const SizedBox(height: 0),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () =>
                      Navigator.of(context).pop(''), // Return empty string
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.black))),
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () =>
                      Navigator.of(context).pop(quantityController.text),
                  child: const Text('Save',
                      style: TextStyle(color: Colors.black))),
            ],
          ),
        ],
      ),
    ).then((value) =>
        value ?? ''); // If the dialog returns null, fallback to an empty string
  }

  /// Duplicate [source] and update its quantity.
  ShipmentLineEntity _duplicateLine(ShipmentLineEntity source) {
    final index = widget._shipmentLines.indexOf(source);
    final reservedQty = source.orderLine!.qtyReserved! - source.movementQty!;
    final result = (source as ShipmentLineModel).copy();
    _quantityControllers[source.localUuid]!.text = reservedQty.toString();

    result.orderLine!..qtyReserved = reservedQty;

    result
      ..attributeSetInstance = null
      ..selected = false
      ..quantity = result.orderLine!.qtyReserved!;

    setState(() {
      widget._shipmentLines.insert(index + 1, result);
    });

    return result;
  }

  void _handleSoState(BuildContext context, SoState state) {
    if (state is SoStateShipmentLinesCreated) {
      _updateLines(state);
      BlocProvider.of<SoBloc>(context)
          .add(SoEventUpdateLines(shipmentLine: lines!));
    } else if (state is SoStateAsiScanned) {
      _showQuickDetail(context, state.line.orderLine!, state.line);
    } else if (state is SoStateDocumentDiscarded) {
      _discardStates(state);
    } else if (state is SoStateLineEmpty) {
      showDialog(
          builder: (_) => AlertDialog(
                  title: Text('No Lines'),
                  content: Text('All lines has been delivered'),
                  actions: <Widget>[
                    MaterialButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ]),
          context: context);
    }
  }

  void _updateLines(SoStateShipmentLinesCreated state) {
    setState(() {
      widget._shipmentLines
        ..clear()
        ..addAll(state.lines);
      this.lines = widget._shipmentLines;
      this.count = state.lines.length;
    });
  }

  void _discardStates(SoStateDocumentDiscarded state) {
    setState(() {
      widget._shipmentLines.clear();
      _cachedAttributeSets.clear();
      _quantityControllers
        ..forEach((_, c) => c.dispose())
        ..clear();
      this.count = 0;
      this.lines = [];
    });
  }
}
