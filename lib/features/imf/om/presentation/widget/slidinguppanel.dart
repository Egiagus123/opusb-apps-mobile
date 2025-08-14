import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/data/model/imf_line_model.dart';
import 'package:apps_mobile/features/imf/inventorymovefrom/domain/entity/imf_line_entity.dart';
import 'package:apps_mobile/features/imf/om/domain/entity/order_movement_line.dart';
import 'package:apps_mobile/features/imf/om/presentation/bloc/bloc.dart';

class SlidingPage extends StatefulWidget {
  final List<ImfLineEntity> _movementLines;

  SlidingPage({required List<ImfLineEntity> movementLines})
      : _movementLines = movementLines;

  @override
  _SlidingPageState createState() => _SlidingPageState();
}

class _SlidingPageState extends State<SlidingPage> {
  final Map<String, ImfLineEntity> _cachedAttributeSets = {};
  final Map<String, TextEditingController> _quantityControllers = {};
  List<ImfLineEntity>? lines;
  int? _locatorId;
  int count = 0;

  @override
  void initState() {
    super.initState();
    lines = widget._movementLines;
    count = lines?.length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OmBloc, OmState>(
      listener: (context, state) => _poBlocListener(context, state),
      child: BlocBuilder<OmBloc, OmState>(
        builder: (context, state) {
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
                      var imfLine = lines![position];
                      var omLine = imfLine.orderLine;
                      var attributed =
                          imfLine.attributeSetInstance?.identifier ?? '';
                      bool selected = imfLine.selected;

                      return Card(
                        elevation: 3,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(2),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Checkbox(
                                  value: selected,
                                  onChanged: (value) {
                                    setState(() {
                                      imfLine.selected = value!;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: ListTile(
                                  onTap: () async {
                                    var quantity = await _showQuickDetail(
                                        context, omLine!, imfLine);
                                    setState(() {
                                      imfLine.qtyEntered =
                                          double.tryParse(quantity!) ?? 0;
                                    });
                                  },
                                  dense: true,
                                  title: Text(
                                    imfLine.product.identifier!,
                                    style: TextStyle(
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
                                              'Quantity: ${imfLine.qtyEntered} (${imfLine.uom.identifier})'),
                                          imfLine.attributeSet != null
                                              ? cardDetail('Lot: $attributed')
                                              : cardDetail(''),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              imfLine.attributeSet != null
                                  ? Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, right: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.camera_alt),
                                            iconSize: 20,
                                            onPressed: () async {
                                              String scanMode = imfLine.isSerNo!
                                                  ? 'serNo'
                                                  : 'lot';
                                              BlocProvider.of<OmBloc>(context)
                                                  .add(
                                                OmEventOpenAsiScanner(
                                                  scanMode: scanMode,
                                                  line: imfLine,
                                                  scannedAttributeSets:
                                                      _cachedAttributeSets,
                                                  locatorId: _locatorId!,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(height: 0),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget cardDetail(String title) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 10),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _quantityControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<String?> _showQuickDetail(
      BuildContext context, OrderMovementLine omLine, ImfLineEntity imfLine) {
    final quantityController =
        TextEditingController(text: imfLine.quantity.toString());
    final movementQty = omLine.movementQty - omLine.qtyDelivered;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Line Detail',
              style: TextStyle(fontFamily: 'Oswald', letterSpacing: 1)),
          contentPadding: EdgeInsets.all(24.0),
          children: <Widget>[
            TextFormField(
              readOnly: true,
              initialValue: omLine.product.identifier,
              textAlign: TextAlign.left,
              style: TextStyle(fontFamily: 'Montserrat'),
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextFormField(
              readOnly: true,
              initialValue: movementQty.toString(),
              textAlign: TextAlign.left,
              style: TextStyle(fontFamily: 'Montserrat'),
              decoration: InputDecoration(labelText: 'Movement Quantity'),
            ),
            TextField(
              onTap: () => quantityController.selection = TextSelection(
                  baseOffset: 0, extentOffset: quantityController.text.length),
              decoration:
                  InputDecoration(counterText: '', labelText: 'Input Quantity'),
              controller: quantityController,
              style: TextStyle(fontFamily: 'Montserrat'),
              keyboardType: TextInputType.number,
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  imfLine.quantity = double.tryParse(value) ?? 0;
                });
              },
            ),
            TextFormField(
              readOnly: true,
              initialValue: omLine.uom.identifier,
              textAlign: TextAlign.left,
              style: TextStyle(fontFamily: 'Montserrat'),
              decoration: InputDecoration(labelText: 'UoM'),
            ),
            if (imfLine.attributeSet != null)
              TextFormField(
                readOnly: true,
                initialValue: imfLine.attributeSetInstance?.identifier,
                textAlign: TextAlign.left,
                style: TextStyle(fontFamily: 'Montserrat'),
                decoration:
                    InputDecoration(labelText: 'Attribute Set Instance'),
              ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(''),
                  child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pop(quantityController.text),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _poBlocListener(BuildContext context, OmState state) {
    if (state is OmStateReceiptLinesCreated) {
      _updateLines(state);
      BlocProvider.of<OmBloc>(context)
          .add(OmEventUpdateOrderLines(movement: lines!));
    } else if (state is OmStateDocumentDiscarded) {
      _discardStates(state);
    } else if (state is OmStateLineEmpty) {
      showDialog(
        builder: (_) => AlertDialog(
          title: Text('No Lines'),
          content: Text('All lines have been delivered'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        context: context,
      );
    } else if (state is OmStateLocatorChange) {
      _locatorId = state.locatorId;
    } else if (state is OmStateAsiScanned) {
      _showQuickDetail(context, state.line.orderLine!, state.line);
    }
  }

  void _updateLines(OmStateReceiptLinesCreated state) {
    setState(() {
      widget._movementLines
        ..clear()
        ..addAll(state.lines!);
      lines = widget._movementLines;
      count = state.lines!.length;
    });
  }

  void _discardStates(OmStateDocumentDiscarded state) {
    setState(() {
      widget._movementLines.clear();
      _cachedAttributeSets.clear();
      _quantityControllers
        ..forEach((_, c) => c.dispose())
        ..clear();
      count = 0;
      lines = [];
    });
  }
}
