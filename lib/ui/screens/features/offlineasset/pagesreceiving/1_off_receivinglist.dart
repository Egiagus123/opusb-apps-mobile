import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/assetshipment/offline_shipment.dart';
import 'package:apps_mobile/business_logic/cubit/asset_offlne_cubit.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/database.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/table_assetrcv.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/table_trxasset.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_asset.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_asset_rcv.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_assetline.dart';
import 'package:apps_mobile/widgets/dialog_util.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OfflineReceivingList extends StatefulWidget {
  final ListAssetTrf? listDatasaved;
  OfflineReceivingList(this.listDatasaved);
  @override
  _OfflineReceivingListState createState() {
    return _OfflineReceivingListState(this.listDatasaved!);
  }
}

class _OfflineReceivingListState extends State<OfflineReceivingList> {
  int count = 0;
  List<ListDataGetReceiving> assetReceivingLine = [];
  QueryGetAssetReceiving sql = QueryGetAssetReceiving();
  QueryTrxTable querytrx = QueryTrxTable();
  ListAssetTrf listDatasaved;
  _OfflineReceivingListState(this.listDatasaved);
  List<ListAssetTrfLine>? listDataTrxLine;
  DatabaseHelper helper = DatabaseHelper();
  TextEditingController _prodnameController = TextEditingController();
  TextEditingController _locationToController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  TextEditingController _uomController = TextEditingController();
  TextEditingController _snController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (listDatasaved != null) {
      _locationToController.text = listDatasaved.locationToName;
      updateListLine(listDatasaved.toolRequestId);
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
                              }, cancelText: '', cancelCallback: () {}));
                    }),
              TextSpan(text: ' for details.')
            ],
          ),
        ),
        backgroundColor: color,
      ));
    }

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
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Asset Receiving (Offline Mode)',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Oswald',
                letterSpacing: 1,
                color: purewhiteTheme),
          ),
        ),
      ),
      body: listBody(),
      backgroundColor: Colors.grey[200],
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 20, right: 10),
      //   child: FloatingActionButton(
      //     // backgroundColor: Color.fromRGBO(147, 49, 42, 10),
      //     onPressed: () {
      //       // navigateToDetail(
      //       //     DataMasterTransaction("", DateTime.now().toString(), "", ""),
      //       //     "Add new stock opname");
      //     },
      //     tooltip: 'Add New Data',
      //     child: Icon(
      //       Icons.add,
      //       color: purewhiteTheme,
      //     ),
      //   ),
      // ),
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
                    // Image(
                    //     width: 20,
                    //     height: 20,
                    //     image: AssetImage('assets/sendbuttonwhite.png')),
                    Icon(
                      EvaIcons.save,
                      color: purewhiteTheme,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "SAVE",
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
    );
  }

  Widget listBody() {
    return Column(
      children: [
        Card(
          child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _locationToController,
                          readOnly: true,
                          decoration: InputDecoration(
                              disabledBorder: InputBorder.none,
                              labelText: 'Location To',
                              labelStyle: TextStyle(
                                color: pureblackTheme,
                                fontSize: 12,
                              ),
                              contentPadding: EdgeInsets.only(
                                  bottom: 11, top: 11, right: 15),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  _getLocator(context);
                                },
                                icon: Icon(
                                  FontAwesomeIcons.searchLocation,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _snController,
                          readOnly: true,
                          decoration: InputDecoration(
                              disabledBorder: InputBorder.none,
                              labelText: 'Serial No.',
                              labelStyle: TextStyle(
                                color: pureblackTheme,
                                fontSize: 12,
                              ),
                              contentPadding: EdgeInsets.only(
                                  bottom: 11, top: 11, right: 15),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  _getLines(context);
                                },
                                icon: Icon(
                                  FontAwesomeIcons.search,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ),
        SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listDataTrxLine != null
                        ? listDataTrxLine!.length
                        : assetReceivingLine.length,
                    itemBuilder: (BuildContext context, int position) {
                      var assetRcvData;
                      if (listDataTrxLine != null) {
                        assetRcvData = this.listDataTrxLine![position];
                      } else {
                        assetRcvData = this.assetReceivingLine[position];
                      }

                      return Slidable(
                        endActionPane: ActionPane(
                          motion:
                              const DrawerMotion(), // Bisa diganti dengan ScrollMotion, BehindMotion, dll
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                assetReceivingLine.removeWhere(
                                    (i) => i.id == assetRcvData.id);
                                setState(() {
                                  assetReceivingLine = assetReceivingLine;
                                });
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
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
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 1),
                                  child: ListTile(
                                    dense: true,
                                    title: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8, top: 8),
                                      child: Text(
                                        '${assetRcvData.installBaseName}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Quantity : ${assetRcvData.qtyEntered}'),
                                          SizedBox(width: 15),
                                          Text(
                                              'Serial No. : ${assetRcvData.serNo}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        )
      ],
    );
  }

  void _getLocator(BuildContext context) async {
    try {
      // Memindai barcode menggunakan scanBarcode(context)
      String? scanResult =
          await scanBarcode(context); // Menggunakan scanBarcode(context)

      if (scanResult != 'Cancelled') {
        // Memastikan hasil scan bukan 'Cancelled'
        final Future<Database> dbfuture =
            sql.databaseHelper.initializedDatabase();

        dbfuture.then((database) {
          Future<List<ListDataGetReceiving>> listLocation =
              sql.filterLocationFromDB(int.parse(scanResult!));

          listLocation.then((l) {
            if (l.isNotEmpty) {
              setState(() {
                // Menyimpan nama lokasi yang ditemukan ke controller
                _locationToController =
                    TextEditingController(text: l.first.locationToName);
              });
            } else {
              // Menampilkan SnackBar jika lokasi tidak ditemukan
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Location not found.')),
              );
            }
          });
        });
      }
    } catch (e) {
      print('Barcode scan error: $e');
    }
  }

  void _getLines(BuildContext context) async {
    try {
      // Memindai barcode menggunakan scanBarcode(context)
      String? scanSN =
          await scanBarcode(context); // Menggunakan scanBarcode(context)

      // Jika user menekan cancel, scanSN akan bernilai "Cancelled"
      if (scanSN == 'Cancelled') return;

      // Menginisialisasi database dan memanggil filterSn
      final Future<Database> dbfuture =
          sql.databaseHelper.initializedDatabase();
      dbfuture.then((database) {
        Future<List<ListDataGetReceiving>> listLines =
            sql.filterSn(scanSN!, this._locationToController.text);

        listLines.then((l) {
          setState(() {
            // Menyimpan hasil scan ke dalam controller dan menambahkan data yang diterima ke assetReceivingLine
            this._snController = TextEditingController(text: scanSN);
            assetReceivingLine.addAll(l);
          });
        });
      });
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }

  _save() async {
    ListAssetTrfLine listLineLocal;
    List<dynamic> listLine = [];

    assetReceivingLine.forEach((e) async {
      listLineLocal = new ListAssetTrfLine(
          e.clientId,
          e.orgId,
          e.toolRequestLineID,
          e.toolRequestId,
          e.installBaseID,
          e.installBaseName,
          e.serNo,
          0,
          e.qtyEntered);
      listLine.add(listLineLocal);
    });
    List<ListAssetTrfLine> line =
        listLine.map((item) => item as ListAssetTrfLine).toList();

    ListAssetTrf header = new ListAssetTrf(
        assetReceivingLine[0].clientId,
        assetReceivingLine[0].orgId,
        assetReceivingLine[0].toolRequestId,
        assetReceivingLine[0].locatorIntransitID,
        assetReceivingLine[0].locatorNewID,
        assetReceivingLine[0].trfdocno,
        assetReceivingLine[0].trfdatedoc,
        assetReceivingLine[0].dateReceived,
        'none',
        'none',
        assetReceivingLine[0].locationToName,
        assetReceivingLine[0].trxtype);
    await querytrx.insertDataTrx(header, line);

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
          querytrx.fetchdatalistLine(headerId);
      linesLists.then((linesList) {
        setState(() {
          this.listDataTrxLine = linesList;
          print(listDataTrxLine!.length);
        });
      });
    });
  }
}
