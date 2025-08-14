import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/features/imt/imt/data/model/imt_line_model.dart';
import 'package:apps_mobile/features/imt/imt/domain/entity/imt_line_entity.dart';
import 'package:apps_mobile/features/imt/om/domain/entity/order_movement_line.dart';
import 'package:apps_mobile/features/imt/om/presentation/bloc/bloc.dart';
import 'package:apps_mobile/features/core/component/component.dart';

class SlidingPage extends StatefulWidget {
  final List<ImtLineEntity> _movementLines;

  SlidingPage({required List<ImtLineEntity> movementLines})
      : _movementLines = movementLines;

  @override
  _SlidingPageState createState() => _SlidingPageState();
}

class _SlidingPageState extends State<SlidingPage> {
  final Map<String, ImtLineEntity> _cachedAttributeSets = {};
  final Map<String, TextEditingController> _quantityControllers = {};
  late List<ImtLineEntity> lines;
  late int _locatorId;
  var isSelected = false;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OmBloc, OmState>(
        listener: (context, state) => _poBlocListener(context, state),
        child: BlocBuilder<OmBloc, OmState>(builder: (context, state) {
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
                          var imtLine = this.lines[position];
                          var omLine = this.lines[position].orderLine;
                          var attributed = imtLine.attributeSetInstance == null
                              ? ''
                              : imtLine.attributeSetInstance?.identifier;
                          bool selected = imtLine.selected;
                          return Card(
                              elevation: 3,
                              color: whiteTheme,
                              child: Padding(
                                padding: EdgeInsets.all(2),
                                child: Stack(children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Checkbox(
                                        value: selected,
                                        onChanged: (value) => setState(
                                            () => imtLine.selected = value!)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: ListTile(
                                      onTap: () async {
                                        var quantity = await _showQuickDetail(
                                            context, omLine!, imtLine);
                                        setState(() {
                                          imtLine.quantity =
                                              double.tryParse(quantity!)!;
                                        });
                                      },
                                      dense: true,
                                      title: Text(
                                        this
                                            .lines[position]
                                            .product
                                            .identifier!,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      subtitle: Container(
                                          child: Padding(
                                        padding:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        child: Row(
                                          children: <Widget>[
                                            cardDetail(
                                                'Quantity : ${imtLine.quantity} (${imtLine.uom.identifier})'),
                                            imtLine.attributeSet != null
                                                ? cardDetail(
                                                    'Lot : $attributed')
                                                : cardDetail(''),
                                          ],
                                        ),
                                      )),
                                    ),
                                  ),
                                  imtLine.attributeSet != null
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
                                                      imtLine.isSerNo
                                                          ? 'serNo'
                                                          : 'lot';
                                                  BlocProvider.of<OmBloc>(
                                                          context)
                                                      .add(OmEventOpenAsiScanner(
                                                          scanMode: scanMode,
                                                          line: imtLine,
                                                          scannedAttributeSets:
                                                              _cachedAttributeSets,
                                                          locatorId:
                                                              _locatorId));
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

  Future<String?> _showQuickDetail(
      BuildContext context, OrderMovementLine poLine, ImtLineEntity imtLine) {
    final quantityController =
        TextEditingController(text: imtLine.quantity.toString());
    double initialvalue =
        imtLine.orderLine!.qtyDelivered! - imtLine.orderLine!.qtyReceipt!;

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
            initialValue: poLine.product.identifier,
            textAlign: TextAlign.left,
            style: TextStyle(fontFamily: 'Montserrat'),
            decoration: InputDecoration(
              labelText: 'Product Name',
            ),
          ),
          TextFormField(
            readOnly: true,
            textAlign: TextAlign.left,
            initialValue: initialvalue.toString(),
            decoration: InputDecoration(
              labelText: 'Movement Quantity',
            ),
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
          TextField(
            onTap: () => quantityController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: quantityController.value.text.length),
            decoration: InputDecoration(
              counterText: '',
              labelText: 'Input Quantity',
            ),
            style: TextStyle(fontFamily: 'Montserrat'),
            controller: quantityController,
            keyboardType: TextInputType.number,
            autofocus: true,
            onChanged: (value) {
              if (double.tryParse(value) != null &&
                  double.tryParse(value)! > initialvalue) {
                imtLine.quantity = initialvalue;
                quantityController.value = TextEditingValue(
                  text: initialvalue.toString(),
                  selection: TextSelection.fromPosition(
                      TextPosition(offset: initialvalue.toString().length)),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                        "Quantity can't be more than the available quantity"),
                  ),
                );
              } else {
                imtLine.quantity = double.tryParse(value)!;
              }
            },
          ),
          TextFormField(
            readOnly: true,
            initialValue: imtLine.uom.identifier,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              labelText: 'UoM',
            ),
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
          imtLine.attributeSet != null
              ? TextFormField(
                  readOnly: true,
                  style: TextStyle(fontFamily: 'Montserrat'),
                  initialValue: imtLine.attributeSetInstance?.identifier,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    labelText: 'Attribute Set Instance',
                  ),
                )
              : const SizedBox(height: 0),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: greenButton),
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
  ImtLineEntity _duplicateLine(ImtLineEntity source) {
    final index = widget._movementLines.indexOf(source);
    final reservedQty =
        source.orderLine!.qtyDelivered! - source.orderLine!.qtyReceipt!;
    final result = (source as ImtLineModel).copy();
    _quantityControllers[source.localUuid]!.text = reservedQty.toString();

    result
      ..attributeSetInstance = null
      ..selected = false
      ..quantity = reservedQty;

    setState(() {
      widget._movementLines.insert(index + 1, result);
    });

    return result;
  }

  void _poBlocListener(BuildContext context, OmState state) {
    if (state is OmStateImtLinesCreated) {
      _updateLines(state);
      BlocProvider.of<OmBloc>(context)
          .add(OmEventUpdateOrderLines(movement: lines));
    } else if (state is OmStateDocumentDiscarded) {
      _discardStates(state);
    } else if (state is OmStateLineEmpty) {
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
    } else if (state is OmStateLocatorChange) {
      _locatorId = state.locatorId;
    } else if (state is OmStateAsiScanned) {
      _showQuickDetail(context, state.line.orderLine!, state.line);
    }
  }

  void _updateLines(OmStateImtLinesCreated state) {
    setState(() {
      widget._movementLines
        ..clear()
        ..addAll(state.lines);
      this.lines = widget._movementLines;
      this.count = state.lines.length;
    });
  }

  void _discardStates(OmStateDocumentDiscarded state) {
    setState(() {
      widget._movementLines.clear();
      _cachedAttributeSets.clear();
      _quantityControllers
        ..forEach((_, c) => c.dispose())
        ..clear();
      this.count = 0;
      this.lines = [];
    });
  }
}
