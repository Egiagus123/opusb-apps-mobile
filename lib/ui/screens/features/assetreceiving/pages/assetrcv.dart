import 'package:apps_mobile/business_logic/cubit/asset_trfrcv_cubit.dart';
import 'package:apps_mobile/business_logic/models/assetrcvmodel/assetrcvdata_model.dart';
import 'package:apps_mobile/business_logic/models/assettrfmodel/generatetoolstrf.dart';
import 'package:apps_mobile/business_logic/models/assettrfmodel/generatetoolstrfline.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/model/assettrf_model.dart';
import 'package:apps_mobile/ui/screens/features/assetreceiving/form/assetrcv_form.dart';
import 'package:apps_mobile/widgets/dialog_util.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AssetRcv extends StatefulWidget {
  @override
  _AssetRcvState createState() => _AssetRcvState();
}

class _AssetRcvState extends State<AssetRcv> {
  late List data;
  late AssetTrfData modeldata;
  TextEditingController _documentNoController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _prodnameController = TextEditingController();
  TextEditingController _locationToController = TextEditingController();
  TextEditingController _uomController = TextEditingController();
  TextEditingController _snController = TextEditingController();
  late int locationToID;
  late AssetTransferReceivingCubit cubit;
  late List<AssetRcvData> assetRcvData;
  late AssetRcvData assetRcv;
  late String locatorTo;
  var isSelected = true;
  late GenerateDataLine pushLines;
  List<GenerateDataLine> listPushLine = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _documentNoController.dispose();
    _locationController.dispose();
    _locationToController.dispose();
    super.dispose();
  }

  void _resetForm() {
    // Kosongkan variabel data
    setState(() {
      assetRcvData.clear();
      listPushLine.clear();
      isSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0), // here the desired height
          child: AppBar(
            backgroundColor: Colors.white,
            leadingWidth: 100,
            leading: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      onTap: () => backButtonDrawer(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            title: Text(
              'Asset Receiving',
              style: TextStyle(
                  fontFamily: 'Oswald',
                  letterSpacing: 1,
                  color: Theme.of(context).primaryColor),
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
                  color: listPushLine.isEmpty ? Colors.grey : greenButton,
                  onPressed: () async {
                    var dataSubmit = new GenerateData(
                        orgID: Reference(id: assetRcvData.first.org.id),
                        dateDoc: DateTime.now().toString(),
                        doctype: Reference(id: 1001841),
                        locatorFrom:
                            Reference(id: assetRcvData.first.locator.id),
                        locatorToInTransit:
                            Reference(id: assetRcvData.first.locatorTo.id),
                        toolRequest: Reference(id: assetRcvData.first.id),
                        docStatus: Reference(id: 'CO'),
                        detail: listPushLine);
                    listPushLine.isEmpty
                        ? null
                        : _onSubmitButtonPressed(dataSubmit);
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
                        "SUBMIT",
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
        body: BlocConsumer<AssetTransferReceivingCubit,
            AssetTransferReceivingState>(
          builder: (context, state) {
            return buildPage();
          },
          listener: (context, state) {
            if (state is AssetNotFound) {
              _showSnackBar(context, state.message, 'Error');
            } else if (state is AssetRcvLine) {
              this.assetRcv = state.rcvData;
              this.locatorTo = state.rcvData.locatorTo.value!;
            } else if (state is AssetTransferReceivingSubmitted) {
              String? documentNo = state.data.documentNo;
              showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Text('Document Created'),
                  content: Text(
                    'Successfully created asset receiving with document no. : $documentNo',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ).then((_) {
                _resetForm();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AssetRcvForm()),
                );
              });
            }
          },
        ));
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

  void _onSubmitButtonPressed(GenerateData data) {
    BlocProvider.of<AssetTransferReceivingCubit>(context)
        .pushData(data, 'tools-return');
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
                                  _getnewlocator();
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: MaterialButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            _getLines();
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
                  ),
                ],
              )),
        ),
        SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listPushLine == null ? 0 : listPushLine.length,
                      itemBuilder: (BuildContext context, int position) {
                        var lines = this.listPushLine[position];
                        return Slidable(
                          child: Card(
                            elevation: 3,
                            color: purewhiteTheme,
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Checkbox(
                                      value:
                                          isSelected, // Status checkbox untuk setiap item
                                      onChanged: (value) {
                                        setState(() {
                                          isSelected = value ??
                                              false; // Mengupdate status seleksi
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: ListTile(
                                      onTap: () async {
                                        // Menambahkan fungsionalitas untuk klik item
                                        // var quantity = await _showQuickDetail(context, assetTrfLine.qtyEntered);
                                        setState(() {
                                          // _qtyController.text = quantity;  // Bisa disesuaikan
                                        });
                                      },
                                      title:
                                          Text(lines.installBase.identifier!),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text('Qty : ${lines.qtyEntered}'),
                                          SizedBox(width: 30),
                                          Text(
                                            'Serial No: ${lines.serNo}',
                                            overflow: TextOverflow.clip,
                                          ),
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
      ],
    );
  }

  _getnewlocator() async {
    cubit = BlocProvider.of<AssetTransferReceivingCubit>(context);
    var loc = await cubit.getLocation(context).whenComplete(() => _resetForm());

    setState(() {
      this._locationToController =
          TextEditingController(text: loc.first.locatorTo.identifier);
      this.locationToID = loc.first.locatorTo.id;
    });
  }

  _getLines() async {
    // Memindai barcode menggunakan scanBarcode(context)
    final serNo =
        await scanBarcode(context); // Menggunakan scanBarcode(context)

    // Cek jika pemindaian dibatalkan
    if (serNo == 'Cancelled') {
      return null; // Jika pemindaian dibatalkan, keluar dari fungsi
    }

    // Mendapatkan cubit untuk mengambil data
    cubit = BlocProvider.of<AssetTransferReceivingCubit>(context);

    // Mengambil data baris berdasarkan locationToID dan serNo yang dipindai
    var lines = await cubit.getLinesRcv(this.locationToID, serNo!);

    // Memperbarui UI dengan data yang diperoleh
    setState(() {
      assetRcvData = lines; // Menyimpan data baris yang diperoleh
      lines.forEach((e) {
        // Membuat objek baru untuk setiap item dalam lines dan menambahkannya ke listPushLine
        pushLines = GenerateDataLine(
          orgID: Reference(id: assetRcvData.first.org.id),
          installBase: Reference(
              id: e.installbase.id, identifier: e.installbase.identifier),
          serNo: e.serNo,
          toolRequestLineID: Reference(id: e.requestLineID.id),
          qtyEntered: e.qtyEntered,
        );
        listPushLine.add(pushLines); // Menambahkan baris baru ke listPushLine
      });
    });
  }

  // _getLines() async {
  //   // Memindai barcode menggunakan FlutterBarcodeScanner
  //   final serNo = await FlutterBarcodeScanner.scanBarcode(
  //     '#ff6666', // Warna dari garis pemindai
  //     'Cancel', // Teks untuk tombol Cancel
  //     true, // Apakah kamera depan atau belakang digunakan
  //     ScanMode.BARCODE, // Jenis pemindaian (barcode)
  //   );

  //   // Cek jika pemindaian dibatalkan
  //   if (serNo == '-1') {
  //     return null; // Jika pemindaian dibatalkan, keluar dari fungsi
  //   }

  //   // Mendapatkan cubit untuk mengambil data
  //   cubit = BlocProvider.of<AssetTransferReceivingCubit>(context);

  //   // Mengambil data baris berdasarkan locationToID dan serNo yang dipindai
  //   var lines = await cubit.getLinesRcv(this.locationToID, serNo);

  //   // Memperbarui UI dengan data yang diperoleh
  //   setState(() {
  //     assetRcvData = lines; // Menyimpan data baris yang diperoleh
  //     lines.forEach((e) {
  //       // Membuat objek baru untuk setiap item dalam lines dan menambahkannya ke listPushLine
  //       pushLines = GenerateDataLine(
  //         orgID: Reference(id: assetRcvData.first.org.id),
  //         installBase: Reference(
  //             id: e.installbase.id, identifier: e.installbase.identifier),
  //         serNo: e.serNo,
  //         toolRequestLineID: Reference(id: e.requestLineID.id),
  //         qtyEntered: e.qtyEntered,
  //       );
  //       listPushLine.add(pushLines); // Menambahkan baris baru ke listPushLine
  //     });
  //   });

  //   // Future<String> _showQuickDetail(BuildContext context, double qty) {
  //   //   double initialvalue = double.parse(_qtyController.text);
  //   //   return showDialog(
  //   //       barrierDismissible: false,
  //   //       context: context,
  //   //       builder: (context) => SimpleDialog(
  //   //             title: Text(
  //   //               'Line Detail',
  //   //               style: TextStyle(fontFamily: 'Oswald', letterSpacing: 1),
  //   //             ),
  //   //             contentPadding: const EdgeInsets.only(
  //   //                 left: 24.0, top: 12.0, right: 24.0, bottom: 16.0),
  //   //             children: <Widget>[
  //   //               TextFormField(
  //   //                 readOnly: true,
  //   //                 initialValue: _prodnameController.text,
  //   //                 style: TextStyle(fontFamily: 'Montserrat'),
  //   //                 textAlign: TextAlign.left,
  //   //                 decoration: InputDecoration(
  //   //                   labelText: 'Product Name',
  //   //                   labelStyle: TextStyle(fontFamily: 'Montserrat'),
  //   //                 ),
  //   //               ),
  //   //               TextFormField(
  //   //                 readOnly: true,
  //   //                 initialValue: qty.toString(),
  //   //                 style: TextStyle(fontFamily: 'Montserrat'),
  //   //                 textAlign: TextAlign.left,
  //   //                 decoration: InputDecoration(
  //   //                   labelText: 'Quantity',
  //   //                   labelStyle: TextStyle(fontFamily: 'Montserrat'),
  //   //                 ),
  //   //               ),
  //   //               TextField(
  //   //                 onTap: () => _qtyController.selection = TextSelection(
  //   //                     baseOffset: 0,
  //   //                     extentOffset: _qtyController.value.text.length),
  //   //                 decoration: InputDecoration(
  //   //                   counterText: '',
  //   //                   labelText: 'Input Quantity',
  //   //                   labelStyle: TextStyle(fontFamily: 'Montserrat'),
  //   //                 ),
  //   //                 controller: _qtyController,
  //   //                 style: TextStyle(fontFamily: 'Montserrat'),
  //   //                 keyboardType: TextInputType.number,
  //   //                 autofocus: true,
  //   //                 onChanged: (value) {
  //   //                   if (double.tryParse(value) < 0) {
  //   //                     qty = (initialvalue);
  //   //                     _qtyController.value = TextEditingValue(
  //   //                         text: initialvalue.toString(),
  //   //                         selection: TextSelection.fromPosition(TextPosition(
  //   //                             offset: initialvalue.toString().length)));
  //   //                     Scaffold.of(context).showSnackBar(new SnackBar(
  //   //                         backgroundColor: Colors.red,
  //   //                         content: new Text("Quantity can't more than it")));
  //   //                   } else {
  //   //                     _qtyController = double.tryParse(value).toString() ?? 0;
  //   //                   }
  //   //                   // setState(() {
  //   //                   //   shipmentLine.quantity =
  //   //                   //       double.tryParse(value).toString() ?? 0;
  //   //                   // });
  //   //                 },
  //   //               ),
  //   //               TextFormField(
  //   //                 style: TextStyle(fontFamily: 'Montserrat'),
  //   //                 readOnly: true,
  //   //                 initialValue: _uomController.text,
  //   //                 textAlign: TextAlign.left,
  //   //                 decoration: InputDecoration(
  //   //                   labelText: 'UoM',
  //   //                   labelStyle: TextStyle(fontFamily: 'Montserrat'),
  //   //                 ),
  //   //               ),
  //   //               SizedBox(
  //   //                 height: 8.0,
  //   //               ),
  //   //               Row(
  //   //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //   //                 children: <Widget>[
  //   //                   RaisedButton(
  //   //                       color: Colors.white,
  //   //                       onPressed: () =>
  //   //                           Navigator.of(context).pop(_qtyController.text),
  //   //                       child: Text('Cancel')),
  //   //                   RaisedButton(
  //   //                       color: Colors.white,
  //   //                       onPressed: () =>
  //   //                           Navigator.of(context).pop(_qtyController.text),
  //   //                       child: Text('Save'))
  //   //                 ],
  //   //               ),
  //   //             ],
  //   //           ));
  //   // }

  //   void _resetForm() {
  //     setState(() {
  //       _documentNoController.text = '';
  //       _locationToController.text = '';
  //       _prodnameController.text = '';
  //       _uomController.text = '';
  //       _locationController.text = '';
  //       assetRcv;
  //       assetRcvData = [];
  //       listPushLine = [];
  //       pushLines;
  //     });
  //   }
  // }
}
