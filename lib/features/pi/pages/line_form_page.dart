import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/features/core/base/utils/formatter.dart';
import 'package:apps_mobile/features/core/base/widgets/error_handler.dart';
import 'package:apps_mobile/features/core/base/widgets/loading_indicator.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../models/physical_inventory_line.dart';
import '../states/dispute_list_store.dart';
import '../states/line_form_store.dart';
import '../states/line_list_store.dart';

class LineFormPage extends StatefulWidget {
  final PhysicalInventoryLine? line;

  const LineFormPage({Key? key, this.line}) : super(key: key);
  @override
  _LineFormPageState createState() => _LineFormPageState();
}

class _LineFormPageState extends State<LineFormPage> {
  final log = getLogger('LineFormPage');

  late TextEditingController _descriptionTextEditingController;
  late TextEditingController _qtyTextEditingController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ),
        title: Text('Edit Inventory',
            style: TextStyle(
                fontFamily: 'Oswald', letterSpacing: 1, color: purewhiteTheme)),
        actions: <Widget>[
          IconButton(
            onPressed: saveLine,
            icon: Icon(
              Icons.save,
              color: purewhiteTheme,
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: StateBuilder<LineFormStore>(
          // models: [
          //   Injector.getAsReactive<LineFormStore>(),
          //   Injector.getAsReactive<LineListStore>(),
          //   Injector.getAsReactive<DisputeListStore>(),
          // ],
          // tag: hashCode,
          initState: (context, reactiveModel) {
            _descriptionTextEditingController = TextEditingController();
            _descriptionTextEditingController.text = widget.line!.description!;
            _qtyTextEditingController = TextEditingController();
            _qtyTextEditingController.text =
                Formatter.formatNumber(widget.line!.qtyCount!);
            reactiveModel!.setState((store) => store.init(widget.line!));
          },
          dispose: (context, reactiveModel) {
            _descriptionTextEditingController.dispose();
            _qtyTextEditingController.dispose();
            reactiveModel!.state.dispose();
          },
          afterInitialBuild: (_, reactiveModel) {},
          builder: (_, reactiveModel) {
            if (reactiveModel!.isWaiting) return LoadingIndicator();
            log.i('builder');
            return buildPage();
          },
        ),
      ),
    );
  }

  Widget buildPage() {
    final reactiveModel = Injector.getAsReactive<LineFormStore>();
    final state = reactiveModel.state;
    final PhysicalInventoryLine? line = state.line;

    return ListView(
      children: <Widget>[
        if (!line!.isInDispute!)
          Text(
            line.productName!,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontFamily: 'Montserrat'),
            textAlign: TextAlign.center,
          ),
        if (!line.isInDispute!) Divider(),
        if (!line.isInDispute!)
          ListTile(
            dense: true,
            title: Text(
              'Code',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontFamily: 'Montserrat'),
            ),
            subtitle: Text(
              line.upc! ?? line.productValue!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontFamily: 'Montserrat'),
            ),
          ),
        if (!line.isInDispute! && (line.isLot! || line.isSerNo!))
          ListTile(
            title: Text(
              'Attribute Set Instance :',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: DropdownButton<int>(
              isExpanded: true,
              value: state.asiId > 0 &&
                      state.asiList
                          .where((a) => a.id == state.asiId)
                          .toList()
                          .isNotEmpty
                  ? state.asiId
                  : null,
              items: state.asiList
                  .map((c) => DropdownMenuItem(
                        value: c.id as int,
                        child: Text(c.identifier!),
                      ))
                  .toList(),
              onChanged: (value) {
                setAsi(value!);
              },
            ),
            trailing: IconButton(
              icon: Icon(FontAwesomeIcons.qrcode),
              onPressed: () => scanAsi(context),
            ),
          ),
        ListTile(
          title: Text(
            'Description :',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: 'Montserrat'),
          ),
          subtitle: TextField(
            controller: _descriptionTextEditingController,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontFamily: 'Montserrat'),
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            decoration: InputDecoration(),
          ),
        ),
        if (line.isInDispute! || !line.isSerNo!)
          Padding(padding: EdgeInsets.only(top: 15)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'decrementQty',
              onPressed: () {
                decrementQty();
              },
              child: new Icon(
                Icons.remove,
                color: purewhiteTheme,
              ),
              backgroundColor: Colors.red,
            ),
            Container(
              width: 80,
              child: TextField(
                onTap: () {
                  _qtyTextEditingController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _qtyTextEditingController.text.length);
                },
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontFamily: 'Montserrat'),
                textAlign: TextAlign.center,
                controller: _qtyTextEditingController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            FloatingActionButton(
              heroTag: 'incrementQty',
              onPressed: () {
                incrementQty();
              },
              child: new Icon(Icons.add, color: purewhiteTheme),
              backgroundColor: greenButton,
            ),
          ],
        ),
        if (!line.isInDispute! && line.isSerNo!)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton(
                heroTag: 'decrementQty',
                onPressed: null,
                child: new Icon(
                  Icons.remove,
                  // color: Colors.black,
                ),
                backgroundColor: Colors.grey,
              ),
              Container(
                width: 80,
                child: TextField(
                  enabled: false,
                  onTap: null,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                  controller: _qtyTextEditingController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              FloatingActionButton(
                heroTag: 'incrementQty',
                onPressed: null,
                child: new Icon(
                  Icons.add,
                  // color: Colors.black,
                ),
                backgroundColor: Colors.grey,
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: SizedBox(
            width: double.infinity,
            child: MaterialButton(
              onPressed: saveLine,
              child: Text(
                'Save',
                style: TextStyle(fontFamily: 'Oswald', letterSpacing: 1),
              ),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  setAsi(int asiId) {
    final reactiveModel = Injector.getAsReactive<LineFormStore>();
    reactiveModel.setState(
      (store) => store.setAsiId(asiId),
      // onError: ErrorHandler.showSnackBar,
    );
  }

  void scanAsi(BuildContext context) async {
    // Mendapatkan hasil pemindaian barcode menggunakan scanBarcode(context)
    String? barcode = await scanBarcode(context);

    if (barcode != null && barcode != 'Cancelled') {
      // Mengakses Reactive Model dan mengupdate state dengan hasil pemindaian
      final reactiveModel = Injector.getAsReactive<LineFormStore>();
      reactiveModel.setState(
        (store) => store.scanAsi(barcode),
      );
    } else {
      // Menangani jika pemindaian dibatalkan atau gagal
      print('Scan was cancelled or failed');
    }
  }

  void saveLine() {
    final lineFormModel = Injector.getAsReactive<LineFormStore>();
    final line = lineFormModel.state.line;
    if (line!.isInDispute!) {
      final listModel = Injector.getAsReactive<DisputeListStore>();
      listModel.setState(
        (store) async {
          line.description = _descriptionTextEditingController.text;
          line.qtyCount = Formatter.parseNumber(_qtyTextEditingController.text);
          await store.mergeLine(lineFormModel.state.line!);
          Navigator.of(context).pop();
        },
      );
    } else {
      final listModel = Injector.getAsReactive<LineListStore>();
      listModel.setState(
        (store) async {
          line.description = _descriptionTextEditingController.text;
          line.qtyCount = Formatter.parseNumber(_qtyTextEditingController.text);
          await store.mergeLine(lineFormModel.state.line!);
          Navigator.of(context).pop();
        },
        // onError: ErrorHandler.showSnackBar,
      );
    }
  }

  void incrementQty() {
    String qtyStr = _qtyTextEditingController.text;
    num qty = Formatter.parseNumber(qtyStr);
    qty += 1;
    _qtyTextEditingController.text = Formatter.formatNumber(qty);
  }

  void decrementQty() {
    String qtyStr = _qtyTextEditingController.text;
    num qty = Formatter.parseNumber(qtyStr);
    qty -= 1;
    if (qty >= 0) {
      _qtyTextEditingController.text = Formatter.formatNumber(qty);
    }
  }
}
