import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/features/core/base/widgets/date_text.dart';
import 'package:apps_mobile/features/core/base/widgets/error_handler.dart';
import 'package:apps_mobile/features/core/base/widgets/loading_indicator.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../states/inventory_form_store.dart';

import 'inventory_line_page.dart';

class InventoryFormPage extends StatefulWidget {
  @override
  _InventoryFormPageState createState() => _InventoryFormPageState();
}

class _InventoryFormPageState extends State<InventoryFormPage> {
  final log = getLogger('InventoryFormPage');
  late TextEditingController _documentTextController;

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
            onPressed: () => backButtonDrawer(),
          ),
        ),
        title: Text(
          'Physical Inventory',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Oswald',
              letterSpacing: 1,
              color: purewhiteTheme),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: StateBuilder<InventoryFormStore>(
          // models: [Injector.getAsReactive<InventoryFormStore>()],
          // tag: hashCode,
          initState: (context, reactiveModel) {
            _documentTextController = TextEditingController();
          },
          dispose: (context, reactiveModel) {
            _documentTextController.dispose();
          },
          builder: (_, reactiveModel) {
            if (reactiveModel!.isWaiting) return LoadingIndicator();
            log.i('builder');
            return buildPage(reactiveModel.state);
          },
        ),
      ),
    );
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

  Widget buildPage(InventoryFormStore state) {
    final inventory = state.inventory;
    _documentTextController.text = inventory?.documentNo ?? '';
    return ListView(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            'Document No',
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 12),
          ),
          subtitle: TextField(
            controller: _documentTextController,
            style: TextStyle(fontFamily: 'Montserrat'),
            decoration: InputDecoration(
              isDense: true,
              //contentPadding: EdgeInsets.all(8.0),
            ),
            textInputAction: TextInputAction.go,
            onSubmitted: (value) => loadDocument(value),
          ),
          trailing: IconButton(
            icon: Icon(FontAwesomeIcons.qrcode,
                color: Theme.of(context).primaryColor),
            onPressed: () async {
              // Mendapatkan hasil pemindaian barcode dengan scanBarcode(context)
              String? barcodeScanRes = await scanBarcode(context);

              // Memeriksa apakah pemindaian dibatalkan
              if (barcodeScanRes != null && barcodeScanRes != 'Cancelled') {
                loadDocument(barcodeScanRes);
              } else {
                // Penanganan jika pemindaian dibatalkan atau tidak ada hasil
                // Misalnya, Anda bisa menampilkan pesan atau melakukan tindakan lain
                print('Scan was cancelled or failed');
              }
            },
          ),
        ),
        inventory != null ? buildDetails(state) : Container(),
      ],
    );
  }

  Widget buildDetails(InventoryFormStore state) {
    final inventory = state.inventory;
    return Column(children: [
      Divider(
        height: 0,
      ),
      ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          'Date',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
          ),
        ),
        subtitle: DateText(
          dateTime: inventory!.movementDate,
        ),
      ),
      Divider(
        height: 0,
      ),
      ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          'Warehouse',
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 12),
        ),
        subtitle: Text(inventory.warehouse.identifier!,
            style: TextStyle(fontFamily: 'Montserrat')),
      ),
      Divider(
        height: 0,
      ),
      SizedBox(
        width: double.infinity,
        child: MaterialButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InventoryLinePage(inventory: inventory),
              ),
            );
          },
          child: Text(
            'Start Counting',
            style: TextStyle(fontFamily: 'Oswald', letterSpacing: 1),
          ),
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: MaterialButton(
          onPressed: clear,
          child: Text(
            'Close',
            style: TextStyle(fontFamily: 'Oswald', letterSpacing: 1),
          ),
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
        ),
      ),
    ]);
  }

  void loadDocument(String documentNo) {
    final reactiveModel = Injector.getAsReactive<InventoryFormStore>();
    reactiveModel.setState(
      (store) => store.loadDocument(documentNo),
      // onError: ErrorHandler.showSnackBar,
      // filterTags: [hashCode],
    );
  }

  void clear() {
    final reactiveModel = Injector.getAsReactive<InventoryFormStore>();
    reactiveModel.setState(
      (store) => store.clear(),
    );
  }
}
