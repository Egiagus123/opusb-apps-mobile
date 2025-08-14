// import 'package:barcode_scan/barcode_scan.dart';
import 'package:apps_mobile/business_logic/cubit/asset_trfrcv_cubit.dart';
import 'package:apps_mobile/business_logic/models/assetrequestline_model.dart';
import 'package:apps_mobile/business_logic/models/assetrequestwindow_model.dart';
import 'package:apps_mobile/business_logic/models/assettrfmodel/generatetoolstrf.dart';
import 'package:apps_mobile/business_logic/models/assettrfmodel/generatetoolstrfline.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
// import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/ui/screens/features/assettrf/form/assettrf_form.dart';
import 'package:apps_mobile/widgets/dialog_util.dart';
import 'package:apps_mobile/widgets/loading_indicator.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AssetTrfDetail extends StatefulWidget {
  final AssetRequestModel assetRequestModel;
  AssetTrfDetail(this.assetRequestModel);

  @override
  _AssetTrfState createState() {
    return _AssetTrfState(this.assetRequestModel);
  }
}

class _AssetTrfState extends State<AssetTrfDetail> {
  TextEditingController _documentNoController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _prodnameController = TextEditingController();
  TextEditingController _locationToController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  TextEditingController _uomController = TextEditingController();
  TextEditingController _snController = TextEditingController();
  AssetTransferReceivingCubit? assetReqCubit;
  AssetRequestModel assetRequestModel;
  List<AssetRequestLine> assetRequestLine = [];
  AssetRequestLine? line;
  GenerateDataLine? pushLines;
  _AssetTrfState(this.assetRequestModel);

  List<AssetRequestLine> listLine = [];
  List<GenerateDataLine> listPushLine = [];

  var wh, by;
  var isSelected = false;
  @override
  void initState() {
    super.initState();
    // loadinitData(assetRequestModel.headerID.id);
  }

  Future<String> loadinitData(var id) async {
    assetReqCubit = BlocProvider.of<AssetTransferReceivingCubit>(context);
    await assetReqCubit!.getDataLine(id);
    return 'success';
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
              'Asset Transfer',
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
                  color: listPushLine.isEmpty ? Colors.grey : greenButton,
                  disabledColor: Colors.grey,
                  onPressed: () {
                    var dataSubmit = new GenerateData(
                        orgID: Reference(id: assetRequestModel.org.id),
                        dateDoc: '08/19/2021',
                        doctype: Reference(id: 1001857),
                        locatorFrom:
                            Reference(id: assetRequestModel.locator.id),
                        locatorToInTransit: Reference(id: 1000137),
                        toolRequest:
                            Reference(id: assetRequestModel.headerID.id),
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
            AssetTransferReceivingState>(builder: (context, state) {
          if (state is AssetTransferReceivingInProgress) {
            return LoadingIndicator();
          }
          return buildPage();
        }, listener: (context, state) {
          if (state is AssetTransferLoadDataLine) {
            // setState(() {
            //   assetRequestLine = state.line;
            //   assetRequestLine.forEach((e) {
            //     pushLines = GenerateDataLine(
            //         installBase: Reference(id: e.installbase.id),
            //         serNo: e.serNo,
            //         toolRequestLineID: Reference(id: e.id),
            //         qtyEntered: e.qtyEntered);
            //     listPushLine.add(pushLines);
            //   });
            // });
          } else if (state is AssetNotFound) {
            _showSnackBar(context, state.message, 'Error');
          } else if (state is AssetTransferReceivingSubmitted) {
            String? documentNo = state.data.documentNo;
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => buildAlertDialog(context,
                        title: 'Document Created',
                        content:
                            'successfully created asset receiving with document no. : $documentNo',
                        proceedText: 'OK', proceedCallback: () {
                      Navigator.of(context).pop(true);
                    }, cancelText: '', cancelCallback: () {})).then((_) {
              _resetForm();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AssetTrfForm()));
            });
          }
        }));
  }

  void _onSubmitButtonPressed(GenerateData data) {
    BlocProvider.of<AssetTransferReceivingCubit>(context)
        .pushData(data, 'tools-transfer');
  }

  Future<void> getSerNo(int id, List<AssetRequestLine> assetRequestLine) async {
    assetReqCubit = BlocProvider.of<AssetTransferReceivingCubit>(context);
    var lines = await assetReqCubit!.getSerno(id, assetRequestLine, context);
    setState(() {
      this.assetRequestLine = lines;
      assetRequestLine.forEach((e) {
        pushLines = GenerateDataLine(
            orgID: Reference(id: e.org.id),
            installBase: Reference(id: e.installbase.id),
            serNo: e.serNo,
            toolRequestLineID: Reference(id: e.id),
            qtyEntered: e.qtyEntered);
        listPushLine.add(pushLines!);
      });
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
                            text: assetRequestModel.documentNo),

                        textInputAction: TextInputAction.go,
                        // onSubmitted: (value) => loadDocument(value),
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
                                text: assetRequestModel.locator.identifier),
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
                                text: assetRequestModel.locatorTo.identifier),
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
                          await getSerNo(
                              assetRequestModel.headerID.id, assetRequestLine);
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
                    itemCount:
                        assetRequestLine == null ? 0 : assetRequestLine.length,
                    itemBuilder: (BuildContext context, int position) {
                      var assetTrfLine = this.assetRequestLine[position];
                      return Slidable(
                        endActionPane: ActionPane(
                          // Updated to endActionPane instead of secondaryActions
                          motion:
                              DrawerMotion(), // Define the swipe motion (e.g., DrawerMotion)
                          children: [
                            SlidableAction(
                              label: 'Delete', // Action label
                              backgroundColor:
                                  Colors.red, // Action background color
                              icon: EvaIcons.close, // Action icon
                              onPressed: (context) {
                                setState(() {
                                  // Remove item from both lists
                                  assetRequestLine.removeWhere(
                                      (i) => i.id == assetTrfLine.id);
                                  listPushLine.removeWhere(
                                      (i) => i.serNo == assetTrfLine.serNo);
                                });
                              },
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 3,
                          color: purewhiteTheme, // Your custom color theme
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 0),
                                  child: ListTile(
                                    onTap: () async {
                                      // Your onTap logic
                                    },
                                    dense: true,
                                    title: Text(
                                        assetTrfLine.installbase.identifier!),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('Qty: ' +
                                            assetTrfLine.qtyEntered.toString()),
                                        SizedBox(width: 30),
                                        assetTrfLine.serNo == null
                                            ? Text('Serial No:',
                                                overflow: TextOverflow.clip)
                                            : Text(
                                                'Serial No: ${assetTrfLine.serNo}',
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

  // Future<String> _showQuickDetail(BuildContext context, double qty) {
  //   double initialvalue = qty;
  //   return showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) => SimpleDialog(
  //             title: Text(
  //               'Line Detail',
  //               style: TextStyle(fontFamily: 'Oswald', letterSpacing: 1),
  //             ),
  //             contentPadding: const EdgeInsets.only(
  //                 left: 24.0, top: 12.0, right: 24.0, bottom: 16.0),
  //             children: <Widget>[
  //               TextFormField(
  //                 readOnly: true,
  //                 initialValue: _prodnameController.text,
  //                 style: TextStyle(fontFamily: 'Montserrat'),
  //                 textAlign: TextAlign.left,
  //                 decoration: InputDecoration(
  //                   labelText: 'Product Name',
  //                   labelStyle: TextStyle(fontFamily: 'Montserrat'),
  //                 ),
  //               ),
  //               TextFormField(
  //                 readOnly: true,
  //                 initialValue: qty.toString(),
  //                 style: TextStyle(fontFamily: 'Montserrat'),
  //                 textAlign: TextAlign.left,
  //                 decoration: InputDecoration(
  //                   labelText: 'Quantity',
  //                   labelStyle: TextStyle(fontFamily: 'Montserrat'),
  //                 ),
  //               ),
  //               TextField(
  //                 onTap: () => _qtyController.selection = TextSelection(
  //                     baseOffset: 0,
  //                     extentOffset: _qtyController.value.text.length),
  //                 decoration: InputDecoration(
  //                   counterText: '',
  //                   labelText: 'Input Quantity',
  //                   labelStyle: TextStyle(fontFamily: 'Montserrat'),
  //                 ),
  //                 controller: _qtyController,
  //                 style: TextStyle(fontFamily: 'Montserrat'),
  //                 keyboardType: TextInputType.number,
  //                 autofocus: true,
  //                 onChanged: (value) {
  //                   if (double.tryParse(value) < 0) {
  //                     qty = (initialvalue);
  //                     _qtyController.value = TextEditingValue(
  //                         text: initialvalue.toString(),
  //                         selection: TextSelection.fromPosition(TextPosition(
  //                             offset: initialvalue.toString().length)));
  //                     Scaffold.of(context).showSnackBar(new SnackBar(
  //                         backgroundColor: Colors.red,
  //                         content: new Text("Quantity can't more than it")));
  //                   } else {
  //                     _qtyController = double.tryParse(value).toString() ?? 0;
  //                   }
  //                   // setState(() {
  //                   //   shipmentLine.quantity =
  //                   //       double.tryParse(value).toString() ?? 0;
  //                   // });
  //                 },
  //               ),
  //               TextFormField(
  //                 style: TextStyle(fontFamily: 'Montserrat'),
  //                 readOnly: true,
  //                 initialValue: _uomController.text,
  //                 textAlign: TextAlign.left,
  //                 decoration: InputDecoration(
  //                   labelText: 'UoM',
  //                   labelStyle: TextStyle(fontFamily: 'Montserrat'),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 8.0,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: <Widget>[
  //                   RaisedButton(
  //                       color: Colors.white,
  //                       onPressed: () =>
  //                           Navigator.of(context).pop(_qtyController.text),
  //                       child: Text('Cancel')),
  //                   RaisedButton(
  //                       color: Colors.white,
  //                       onPressed: () =>
  //                           Navigator.of(context).pop(_qtyController.text),
  //                       child: Text('Save'))
  //                 ],
  //               ),
  //             ],
  //           ));
  // }

  submitBtn() {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => buildAlertDialog(context,
    //             title: 'Document Created',
    //             content: 'successfully created !',
    //             proceedText: 'OK', proceedCallback: () {
    //           Navigator.pop(context);
    //           Navigator.pop(context);
    //           Navigator.pop(context);
    //         })).then((_) {
    //   _resetForm();
    // });
  }

  void _resetForm() {
    setState(() {
      _documentNoController.text = '';
      _locationToController.text = '';
      _prodnameController.text = '';
      _uomController.text = '';
      _locationController.text = '';
      wh = null;
      listLine = [];
    });
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
}
