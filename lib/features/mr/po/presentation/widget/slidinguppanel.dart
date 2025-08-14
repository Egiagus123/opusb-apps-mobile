// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/features/mr/po/domain/entity/order_line.dart';
import 'package:apps_mobile/features/mr/po/presentation/bloc/bloc.dart';
import 'package:apps_mobile/features/mr/receipt/domain/entity/receipt_line_entity.dart';
import 'package:apps_mobile/features/mr/receipt/data/model/receipt_line_model.dart';

class SlidingPage extends StatefulWidget {
  final List<ReceiptLineEntity> _receiptLines;

  SlidingPage({required List<ReceiptLineEntity> receiptLines})
      : _receiptLines = receiptLines;

  @override
  _SlidingPageState createState() => _SlidingPageState();
}

class _SlidingPageState extends State<SlidingPage> {
  final Map<String, ReceiptLineEntity> _cachedAttributeSets = {};
  final Map<String, TextEditingController> _quantityControllers = {};
  late List<ReceiptLineEntity> lines;
  var isSelected = false;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PoBloc, PoState>(
        listener: (context, state) => _poBlocListener(context, state),
        child: BlocBuilder<PoBloc, PoState>(builder: (context, state) {
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
                          var receiptLine = this.lines[position];
                          var poLine = this.lines[position].orderLine;
                          var attributed = receiptLine.attributeSetInstance ==
                                  null
                              ? ''
                              : receiptLine.attributeSetInstance?.identifier;
                          bool? selected = receiptLine.selected;
                          return Card(
                              elevation: 3,
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(2),
                                child: Stack(children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Checkbox(
                                        value: selected,
                                        onChanged: (value) => setState(() =>
                                            receiptLine.selected = value!)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: ListTile(
                                      onTap: () async {
                                        var quantity = await _showQuickDetail(
                                            context, poLine!, receiptLine);
                                        setState(() {
                                          receiptLine.quantity =
                                              double.tryParse(
                                                  quantity.toString())!;
                                        });
                                      },
                                      dense: true,
                                      title: Text(
                                        this
                                            .lines[position]
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
                                                'Quantity : ${receiptLine.qtyEntered} (${receiptLine.uom!.identifier})'),
                                            receiptLine.attributeSet != null
                                                ? cardDetail(
                                                    'Attribute Set : $attributed')
                                                : cardDetail(''),
                                          ],
                                        ),
                                      )),
                                    ),
                                  ),
                                  receiptLine.attributeSet != null
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
                                                      receiptLine.isSerNo!
                                                          ? 'serNo'
                                                          : 'lot';
                                                  BlocProvider.of<PoBloc>(
                                                          context)
                                                      .add(PoEventOpenAsiScanner(
                                                          scanMode: scanMode,
                                                          line: receiptLine,
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

  Future<Future> _showQuickDetail(BuildContext context, OrderLine poLine,
      ReceiptLineEntity receiptLine) async {
    final quantityController =
        TextEditingController(text: receiptLine.qtyEntered.toString());
    double initialvalue = receiptLine.qtyEntered!;
    return showDialog(
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
            initialValue: poLine.product.identifier,
            textAlign: TextAlign.left,
            style: TextStyle(fontFamily: 'Montserrat'),
            decoration: InputDecoration(
              labelText: 'Product Name',
            ),
          ),
          TextFormField(
            readOnly: true,
            initialValue: poLine.qtyOrdered.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(fontFamily: 'Montserrat'),
            decoration: InputDecoration(
              labelText: 'PO Quantity',
            ),
          ),
          TextField(
            onTap: () => quantityController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: quantityController.value.text.length),
            decoration: InputDecoration(
              counterText: '',
              labelText: 'Input Quantity',
            ),
            controller: quantityController,
            style: TextStyle(fontFamily: 'Montserrat'),
            keyboardType: TextInputType.number,
            autofocus: true,
            onChanged: (value) {
              final parsedValue = double.tryParse(value);
              if (parsedValue == null || parsedValue < 0) {
                receiptLine.quantity = initialvalue;
                quantityController.value = TextEditingValue(
                  text: initialvalue.toString(),
                  selection: TextSelection.fromPosition(
                      TextPosition(offset: initialvalue.toString().length)),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("Quantity can't be less than 0"),
                  ),
                );
              } else {
                receiptLine.quantity = parsedValue;
              }
            },
          ),
          TextFormField(
            readOnly: true,
            initialValue: receiptLine.uom!.identifier,
            textAlign: TextAlign.left,
            style: TextStyle(fontFamily: 'Montserrat'),
            decoration: InputDecoration(
              labelText: 'UoM',
            ),
          ),
          receiptLine.attributeSet != null
              ? TextFormField(
                  readOnly: true,
                  style: TextStyle(fontFamily: 'Montserrat'),
                  initialValue: receiptLine.attributeSetInstance?.identifier,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    labelText: 'Attribute Set Instance',
                  ),
                )
              : const SizedBox(height: 0.0),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(quantityController.text),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenButton, // Button color
                ),
                onPressed: () =>
                    Navigator.of(context).pop(quantityController.text),
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Duplicate [source] and update its quantity.
  ReceiptLineEntity _duplicateLine(ReceiptLineEntity source) {
    final index = widget._receiptLines.indexOf(source);
    final reservedQty = source.orderLine!.qtyReserved - source.movementQty!;
    final result = (source as ReceiptLineModel).copy();
    _quantityControllers[source.localUuid]!.text = reservedQty.toString();

    result.orderLine!..qtyReserved = reservedQty;

    result
      ..attributeSetInstance
      ..selected = false
      ..quantity = result.orderLine!.qtyReserved;

    setState(() {
      widget._receiptLines.insert(index + 1, result);
    });

    return result;
  }

  void _poBlocListener(BuildContext context, PoState state) {
    if (state is PoStateReceiptLinesCreated) {
      _updateLines(state);
      BlocProvider.of<PoBloc>(context)
          .add(PoEventUpdateLines(receiptLine: lines));
    } else if (state is PoStateAsiScanned) {
      _showQuickDetail(context, state.line.orderLine!, state.line);
    } else if (state is PoStateSerialNoDuplication) {
      _showSnackBar(context, state.message, Colors.amber);
    } else if (state is PoStateDocumentDiscarded) {
      _discardStates(state);
    } else if (state is PoStateLineEmpty) {
      showDialog(
          builder: (_) => new AlertDialog(
                  title: Text('No Lines'),
                  content: Text('All lines has been delivered'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ]),
          context: context);
    }
  }

  void _updateLines(PoStateReceiptLinesCreated state) {
    setState(() {
      this.lines = state.lines;
      this.count = state.lines.length;
    });
  }

  void _discardStates(PoStateDocumentDiscarded state) {
    setState(() {
      widget._receiptLines.clear();
      _cachedAttributeSets.clear();
      _quantityControllers
        ..forEach((_, c) => c.dispose())
        ..clear();
      this.count = 0;
      this.lines = [];
    });
  }

  void _showSnackBar(BuildContext context, String message,
      [Color color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }
}
