import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/assetshipment/offline_shipment.dart';
import 'package:apps_mobile/business_logic/cubit/asset_offlne_cubit.dart';
import 'package:apps_mobile/business_logic/models/assetrequestline_model.dart';
import 'package:apps_mobile/business_logic/models/assetrequestwindow_model.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/database.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_asset.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_assetline.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_header.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_line.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/table_trxasset.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/tablemovementreq_line.dart';
import 'package:apps_mobile/widgets/dialog_util.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqflite/sqlite_api.dart';

// import '1_off_trflist.dart';

class AssetTrfOffDetail extends StatefulWidget {
  final ListDataMovReqHeader? listDataHeader;
  final ListAssetTrf? assettrx;
  AssetTrfOffDetail(this.listDataHeader, this.assettrx);

  @override
  _AssetTrfState createState() {
    return _AssetTrfState(this.listDataHeader!, this.assettrx!);
  }
}

class _AssetTrfState extends State<AssetTrfOffDetail> {
  TextEditingController _documentNoController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _prodnameController = TextEditingController();
  TextEditingController _locationToController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  TextEditingController _uomController = TextEditingController();

  AssetRequestModel? assetRequestModel;
  List<AssetRequestLine>? assetRequestLine = [];
  AssetRequestLine? line;

  QueryTableLine query = QueryTableLine();
  QueryTrxTable queryLine = QueryTrxTable();
  DatabaseHelper helper = DatabaseHelper();

  ListDataMovReqHeader listDataHeader;
  ListAssetTrf assettrx;
  _AssetTrfState(this.listDataHeader, this.assettrx);
  List<ListDataMovReqLine> listLines = [];
  List<ListAssetTrfLine>? listDataTrxLine;

  var wh, by;
  var isSelected = false;
  @override
  void initState() {
    super.initState();
    // loadinitData(assetRequestModel.headerID.id);
  }

  @override
  void dispose() {
    _documentNoController.dispose();
    _locationController.dispose();
    _locationToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (assettrx != null && listDataTrxLine == null) {
      listDataTrxLine = [];
      updateListLine(assettrx.toolRequestId);
    }
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
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Asset Transfer Detail (Offline)',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Oswald',
                  letterSpacing: 1,
                  color: purewhiteTheme),
            ),
          ),
        ),
        backgroundColor: Colors.grey[200],
        bottomNavigationBar: Stack(
          children: [
            new Container(
              height: 50.0,
              child: Container(
                height: double.infinity,
                child: MaterialButton(
                  color: greenButton,
                  onPressed: () async {
                    await _save();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        EvaIcons.paperPlane,
                        color: purewhiteTheme,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                          fontFamily: 'Oswald',
                          color: purewhiteTheme,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: buildPage());
  }

  void getSerNo(int id, String serno, BuildContext context) {
    Future<List<ListDataMovReqLine>> result = query.addLineBySerno(id, serno);

    result.then((e) {
      if (e.length > 0) {
        setState(() {
          this.listLines.addAll(e);
        });
      } else {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (ctx) => AlertDialog(
                  title: Text('Not Found'),
                  content: Text('Data with serial no. : $serno is Not Found!'),
                ));
      }
    });
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

  Widget buildPage() {
    return Column(children: [
      Card(
          color: purewhiteTheme,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Icon(Icons.receipt,
                            color: Theme.of(context).primaryColor)),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                            text: listDataHeader == null
                                ? assettrx.docNo
                                : listDataHeader.docNo),
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                          isDense: false,
                          labelText: 'Document No.',
                          labelStyle: TextStyle(
                            color: pureblackTheme,
                            fontSize: 12,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: pureblackTheme),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Icon(
                        EvaIcons.home,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                        child: TextField(
                            controller: TextEditingController(
                                text: listDataHeader == null
                                    ? assettrx.locationfromName
                                    : listDataHeader.locationfromName),
                            textAlign: TextAlign.left,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Location',
                              labelStyle: TextStyle(
                                color: pureblackTheme,
                                fontSize: 12,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: pureblackTheme),
                              ),
                            ),
                            style: TextStyle(
                              color: pureblackTheme,
                              fontSize: 14,
                              // fontFamily: 'Montserrat'
                            ))),
                    SizedBox(
                      width: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Icon(
                        EvaIcons.home,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                        child: TextField(
                            controller: TextEditingController(
                                text: listDataHeader == null
                                    ? assettrx.locationToName
                                    : listDataHeader.locationToName),
                            textAlign: TextAlign.left,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Location To',
                              labelStyle: TextStyle(
                                color: pureblackTheme,
                                fontSize: 12,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: pureblackTheme),
                              ),
                            ),
                            style: TextStyle(
                              color: pureblackTheme,
                              fontSize: 14,
                              // fontFamily: 'Montserrat'
                            ))),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: MaterialButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () async {
                          String? barcodeScanRes = await scanBarcode(
                              context); // Menggunakan scanBarcode(context)

                          if (barcodeScanRes != 'Cancelled') {
                            // 'Cancelled' artinya user menekan 'Cancel'
                            getSerNo(
                              assettrx != null
                                  ? assettrx.toolRequestId
                                  : listDataHeader.toolRequestId,
                              barcodeScanRes!,
                              context,
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Scan Serial No.',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              FontAwesomeIcons.qrcode,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                // SizedBox(height: 10),
              ],
            ),
          )),
      SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listDataTrxLine != null
                        ? listDataTrxLine!.length
                        : listLines.length,
                    itemBuilder: (BuildContext context, int position) {
                      var listLine;
                      if (listDataTrxLine != null) {
                        listLine = this.listDataTrxLine![position];
                      } else {
                        listLine = this.listLines[position];
                      }
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (BuildContext context) {
                                listDataTrxLine == null
                                    ? listLines.removeWhere((i) =>
                                        i.toolRequestLineID ==
                                        this
                                            .listLines[position]
                                            .toolRequestLineID)
                                    : listDataTrxLine!.removeWhere((e) =>
                                        e.toolRequestLineID ==
                                        this
                                            .listDataTrxLine![position]
                                            .toolRequestLineID);
                                setState(() {
                                  listLines = listLines;
                                });
                              },
                              backgroundColor: Colors.red,
                              icon: EvaIcons.close,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 3,
                          color: purewhiteTheme,
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 0),
                                  child: ListTile(
                                    onTap: () async {
                                      var quantity = await _showQuickDetail(
                                          context, listLine.qtyEntered);
                                      setState(() {
                                        _qtyController.text = quantity!;
                                      });
                                    },
                                    dense: true,
                                    title: Text(
                                      listLine.installBaseName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('Qty : ' +
                                            listLine.qtyEntered.toString()),
                                        SizedBox(width: 30),
                                        listLine.serNo == null
                                            ? Text('Serial No:',
                                                overflow: TextOverflow.clip)
                                            : Text(
                                                'Serial No: ${listLine.serNo}',
                                                overflow: TextOverflow.clip),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }))
          ],
        ),
      )
    ]);
  }

  Future<String?> _showQuickDetail(BuildContext context, double qty) async {
    double initialvalue = qty;

    return await showDialog<String>(
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
            initialValue: _prodnameController.text,
            style: TextStyle(fontFamily: 'Montserrat'),
            decoration: InputDecoration(
              labelText: 'Product Name',
              labelStyle: TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
          TextFormField(
            readOnly: true,
            initialValue: qty.toString(),
            style: TextStyle(fontFamily: 'Montserrat'),
            decoration: InputDecoration(
              labelText: 'Quantity',
              labelStyle: TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
          TextField(
            onTap: () {
              _qtyController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _qtyController.text.length,
              );
            },
            decoration: InputDecoration(
              counterText: '',
              labelText: 'Input Quantity',
              labelStyle: TextStyle(fontFamily: 'Montserrat'),
            ),
            controller: _qtyController,
            style: TextStyle(fontFamily: 'Montserrat'),
            keyboardType: TextInputType.number,
            autofocus: true,
            onChanged: (value) {
              final parsed = double.tryParse(value);
              if (parsed == null || parsed < 0) {
                _qtyController.text = initialvalue.toString();
                _qtyController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _qtyController.text.length),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("Quantity can't be negative"),
                  ),
                );
              }
            },
          ),
          TextFormField(
            readOnly: true,
            initialValue: _uomController.text,
            style: TextStyle(fontFamily: 'Montserrat'),
            decoration: InputDecoration(
              labelText: 'UoM',
              labelStyle: TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () => Navigator.of(context).pop(_qtyController.text),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () => Navigator.of(context).pop(_qtyController.text),
                child: Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _save() async {
    ListAssetTrfLine listLineLocal;
    List<dynamic> listLine = [];

    listLines.forEach((e) async {
      listLineLocal = new ListAssetTrfLine(
          e.clientId,
          e.orgId,
          e.toolRequestLineID,
          e.toolRequestId,
          e.installBaseID,
          e.installBaseName,
          e.serNo,
          e.qtyDelivered,
          e.qtyEntered);
      listLine.add(listLineLocal);
    });
    List<ListAssetTrfLine> line =
        listLine.map((item) => item as ListAssetTrfLine).toList();

    ListAssetTrf header = new ListAssetTrf(
        listDataHeader.clientId,
        listDataHeader.orgId,
        listDataHeader.toolRequestId,
        listDataHeader.locatorID,
        listDataHeader.locatorNewID,
        listDataHeader.docNo,
        listDataHeader.dateDocument,
        listDataHeader.dateRec,
        listDataHeader.dateReq,
        listDataHeader.locationfromName,
        listDataHeader.locationToName,
        'Transfer');
    await queryLine.insertDataTrx(header, line);

    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => BlocProvider<AssetOfflineCubit>(
              create: (BuildContext context) => AssetOfflineCubit(),
              child: OfflineTranscationList(),
            )));
  }

  void updateListLine(int headerId) {
    final Future<Database> dbfuture = helper.initializedDatabase();
    dbfuture.then((database) {
      Future<List<ListAssetTrfLine>> linesLists =
          queryLine.fetchdatalistLine(headerId);
      linesLists.then((linesList) {
        setState(() {
          this.listDataTrxLine = linesList;
          print(listDataTrxLine!.length);
        });
      });
    });
  }
}
