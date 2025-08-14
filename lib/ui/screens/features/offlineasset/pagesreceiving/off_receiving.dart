// import 'dart:convert';
// import 'package:barcode_scan/barcode_scan.dart';
// import 'package:eam_mobile/business_logic/cubit/asset_trfrcv_cubit.dart';
// import 'package:eam_mobile/business_logic/models/assetrequest_model.dart';
// import 'package:eam_mobile/business_logic/models/assetrequestline_model.dart';
// import 'package:eam_mobile/business_logic/utils/color.dart';
// import 'package:eam_mobile/model/assettrf_model.dart';
// import 'package:eam_mobile/widgets/dialog_util.dart';
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class OfflineAssetRcv extends StatefulWidget {
//   @override
//   _OfflineAssetRcvState createState() => _OfflineAssetRcvState();
// }

// class _OfflineAssetRcvState extends State<OfflineAssetRcv> {
//   List data;
//   AssetTrfData modeldata;
//   TextEditingController _documentNoController = TextEditingController();
//   TextEditingController _locationController = TextEditingController();
//   TextEditingController _prodnameController = TextEditingController();
//   TextEditingController _locationToController = TextEditingController();
//   TextEditingController _qtyController = TextEditingController();
//   TextEditingController _uomController = TextEditingController();
//   TextEditingController _snController = TextEditingController();
//   List<AssetTrfData> asset = <AssetTrfData>[];
//   AssetTransferReceivingCubit assetReq;
//   List<AssetRequest> assetTrfHeader;
//   List<AssetRequestLine> assetTrfLine;
//   var wh, by;
//   var isSelected = false;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _documentNoController.dispose();
//     _locationController.dispose();
//     _locationToController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: Builder(
//             builder: (context) => IconButton(
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 color: Colors.white,
//               ),
//               onPressed: () => backButtonDrawer(),
//             ),
//           ),
//           title: Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'Asset Receiving',
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   fontFamily: 'Oswald',
//                   letterSpacing: 1,
//                   color: purewhiteTheme),
//             ),
//           ),
//         ),
//         backgroundColor: Colors.grey[200],
//         bottomNavigationBar: Stack(
//           children: [
//             new Container(
//               height: 50.0,
//               child: Container(
//                 height: double.infinity,
//                 child: RaisedButton(
//                   color: greenButton,
//                   onPressed: () async {
//                     await submitBtn();
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Image(
//                       //     width: 20,
//                       //     height: 20,
//                       //     image: AssetImage('assets/sendbuttonwhite.png')),
//                       Icon(
//                         EvaIcons.paperPlane,
//                         color: purewhiteTheme,
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       Text(
//                         "SUBMIT",
//                         style: TextStyle(
//                           fontSize: 16,
//                           letterSpacing: 1,
//                           fontFamily: 'Oswald',
//                           color: purewhiteTheme,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: BlocListener<AssetTransferReceivingCubit,
//             AssetTransferReceivingState>(
//           listener: (context, state) {
//             if (state is AssetTransferLoadData) {
//               setState(() {
//                 assetTrfHeader = state.assetTrfHeader;
//                 assetTrfLine = state.assetTrfLine;
//                 _locationController.text = assetTrfHeader[0].locator.identifier;
//                 _locationToController.text =
//                     assetTrfHeader[0].locatorTo.identifier;
//               });
//             } else if (state is AssetSerno) {
//               setState(() {
//                 _snController.text = state.serno;
//               });
//             } else if (state is AssetNotFound) {
//               _showSnackBar(context, state.message, 'Error');
//             }
//           },
//           child: buildPage(),
//         ));
//   }

//   void _showSnackBar(BuildContext context, String message, String notify,
//       [Color color = Colors.red]) {
//     Scaffold.of(context).showSnackBar(SnackBar(
//       duration: Duration(days: 365),
//       action: SnackBarAction(
//           label: 'Close',
//           onPressed: () {
//             Scaffold.of(context).hideCurrentSnackBar();
//           }),
//       content: RichText(
//         text: TextSpan(
//           children: <TextSpan>[
//             TextSpan(text: notify),
//             TextSpan(text: '. Click '),
//             TextSpan(
//                 text: 'here',
//                 style: TextStyle(
//                   color: Colors.white,
//                   decoration: TextDecoration.underline,
//                 ),
//                 recognizer: TapGestureRecognizer()
//                   ..onTap = () {
//                     showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (context) => buildAlertDialog(context,
//                                 title: notify,
//                                 content: message,
//                                 proceedText: 'OK', proceedCallback: () {
//                               Navigator.pop(context);
//                             }));
//                   }),
//             TextSpan(text: ' for details.')
//           ],
//         ),
//       ),
//       backgroundColor: color,
//     ));
//   }

//   submitBtn() {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => buildAlertDialog(context,
//                 title: 'Document Created',
//                 content: 'successfully created !',
//                 proceedText: 'OK', proceedCallback: () {
//               Navigator.pop(context);
//             })).then((_) {
//       _resetForm();
//     });
//   }

//   void backButtonDrawer() {
//     showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (ctx) => buildAlertDialog(ctx,
//             title: 'Warning',
//             content: 'Do you really want to exit?',
//             cancelText: 'No',
//             cancelCallback: () {
//               Navigator.of(ctx).pop(false);
//             },
//             proceedText: 'Yes',
//             proceedCallback: () {
//               Navigator.pop(ctx, true);
//               Navigator.pop(ctx, true);
//             }));
//   }

//   Widget buildPage() {
//     return Column(children: [
//       Card(
//           color: purewhiteTheme,
//           child: Padding(
//             padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
//             child: Column(
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Padding(
//                         padding: EdgeInsets.only(top: 20),
//                         child: Icon(Icons.receipt,
//                             color: Theme.of(context).primaryColor)),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Expanded(
//                       child: TextField(
//                         controller: _documentNoController,
//                         textInputAction: TextInputAction.go,
//                         onSubmitted: (value) => loadDocument(value),
//                         decoration: InputDecoration(
//                             isDense: false,
//                             labelText: 'Document No.',
//                             labelStyle: TextStyle(
//                               color: pureblackTheme,
//                               fontSize: 12,
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: pureblackTheme),
//                             ),
//                             suffixIcon: IconButton(
//                               onPressed: () async {
//                                 ScanResult value = await BarcodeScanner.scan();
//                                 setState(() {
//                                   _documentNoController = TextEditingController(
//                                       text: value.rawContent);
//                                   FocusScope.of(context).unfocus();
//                                   loadDocument(value.rawContent);
//                                 });
//                               },
//                               icon: Icon(
//                                 Icons.camera_alt,
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                             )),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20),
//                       child: Icon(
//                         EvaIcons.home,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     ),
//                     SizedBox(width: 20),
//                     Expanded(
//                         child: TextField(
//                             controller: _locationController,
//                             textAlign: TextAlign.left,
//                             readOnly: true,
//                             decoration: InputDecoration(
//                               labelText: 'Location',
//                               labelStyle: TextStyle(
//                                 color: pureblackTheme,
//                                 fontSize: 12,
//                               ),
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(color: pureblackTheme),
//                               ),
//                             ),
//                             style: TextStyle(
//                               color: pureblackTheme,
//                               fontSize: 14,
//                               // fontFamily: 'Montserrat'
//                             ))),
//                     SizedBox(
//                       width: 15,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20),
//                       child: Icon(
//                         EvaIcons.home,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     ),
//                     SizedBox(width: 20),
//                     Expanded(
//                         child: TextField(
//                             controller: _locationToController,
//                             textAlign: TextAlign.left,
//                             readOnly: true,
//                             decoration: InputDecoration(
//                               labelText: 'Location To',
//                               labelStyle: TextStyle(
//                                 color: pureblackTheme,
//                                 fontSize: 12,
//                               ),
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide(color: pureblackTheme),
//                               ),
//                             ),
//                             style: TextStyle(
//                               color: pureblackTheme,
//                               fontSize: 14,
//                               // fontFamily: 'Montserrat'
//                             ))),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//               ],
//             ),
//           )),
//       SingleChildScrollView(
//         physics: ScrollPhysics(),
//         child: Column(
//           children: <Widget>[
//             Container(
//                 padding: EdgeInsets.all(10),
//                 child: ListView.builder(
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: assetTrfLine == null ? 0 : assetTrfLine.length,
//                     itemBuilder: (BuildContext context, int position) {
//                       var assetTrfLine = this.assetTrfLine[position];
//                       return Card(
//                           elevation: 3,
//                           color: purewhiteTheme,
//                           child: Padding(
//                             padding: EdgeInsets.all(2),
//                             child: Stack(children: <Widget>[
//                               Padding(
//                                 padding: EdgeInsets.only(top: 10),
//                                 child: Checkbox(
//                                     value: isSelected,
//                                     onChanged: (value) =>
//                                         setState(() => isSelected = value)),
//                               ),
//                               Padding(
//                                   padding: EdgeInsets.only(left: 30),
//                                   child: ListTile(
//                                     onTap: () async {
//                                       var quantity = await _showQuickDetail(
//                                           context, assetTrfLine.qtyEntered);
//                                       setState(() {
//                                         _qtyController.text = quantity;
//                                       });
//                                     },
//                                     dense: true,
//                                     title: Text(assetTrfLine.asset.identifier),
//                                     subtitle: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         Text('Qty : ' +
//                                             assetTrfLine.qtyEntered.toString()),
//                                         SizedBox(
//                                           width: 30,
//                                         ),
//                                         Text(
//                                           'Serial No: ${_snController.text}',
//                                           overflow: TextOverflow.clip,
//                                         )
//                                       ],
//                                     ),
//                                     trailing: IconButton(
//                                       icon: Icon(FontAwesomeIcons.qrcode),
//                                       onPressed: () async {
//                                         await getSerNo(assetTrfLine.asset.id);
//                                       },
//                                     ),
//                                   ))
//                             ]),
//                           ));
//                     }))
//           ],
//         ),
//       )
//     ]);
//   }

//   // List<DropdownMenuItem> _buildWH(BuildContext context, List<AssetTrfData> wh) {
//   //   return wh
//   //       .map((wh) => DropdownMenuItem(
//   //             value: wh.warehouse,
//   //             child: Text(
//   //               wh.warehouse,
//   //               overflow: TextOverflow.ellipsis,
//   //               style: TextStyle(color: pureblackTheme),
//   //             ),
//   //           ))
//   //       .toList();
//   // }

//   Future<String> loadDocument(var idDocument) async {
//     assetReq = BlocProvider.of<AssetTransferReceivingCubit>(context);
//     await assetReq.getData(idDocument);
//     return 'success';
//   }

//   Future<void> getSerNo(var assetId) async {
//     assetReq = BlocProvider.of<AssetTransferReceivingCubit>(context);
//     await assetReq.getSerno(assetId);
//     return 'success';
//   }

//   Future<String> _showQuickDetail(BuildContext context, double qty) {
//     double initialvalue = double.parse(_qtyController.text);
//     return showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (context) => SimpleDialog(
//               title: Text(
//                 'Line Detail',
//                 style: TextStyle(fontFamily: 'Oswald', letterSpacing: 1),
//               ),
//               contentPadding: const EdgeInsets.only(
//                   left: 24.0, top: 12.0, right: 24.0, bottom: 16.0),
//               children: <Widget>[
//                 TextFormField(
//                   readOnly: true,
//                   initialValue: _prodnameController.text,
//                   style: TextStyle(fontFamily: 'Montserrat'),
//                   textAlign: TextAlign.left,
//                   decoration: InputDecoration(
//                     labelText: 'Product Name',
//                     labelStyle: TextStyle(fontFamily: 'Montserrat'),
//                   ),
//                 ),
//                 TextFormField(
//                   readOnly: true,
//                   initialValue: qty.toString(),
//                   style: TextStyle(fontFamily: 'Montserrat'),
//                   textAlign: TextAlign.left,
//                   decoration: InputDecoration(
//                     labelText: 'Quantity',
//                     labelStyle: TextStyle(fontFamily: 'Montserrat'),
//                   ),
//                 ),
//                 TextField(
//                   onTap: () => _qtyController.selection = TextSelection(
//                       baseOffset: 0,
//                       extentOffset: _qtyController.value.text.length),
//                   decoration: InputDecoration(
//                     counterText: '',
//                     labelText: 'Input Quantity',
//                     labelStyle: TextStyle(fontFamily: 'Montserrat'),
//                   ),
//                   controller: _qtyController,
//                   style: TextStyle(fontFamily: 'Montserrat'),
//                   keyboardType: TextInputType.number,
//                   autofocus: true,
//                   onChanged: (value) {
//                     if (double.tryParse(value) < 0) {
//                       qty = (initialvalue);
//                       _qtyController.value = TextEditingValue(
//                           text: initialvalue.toString(),
//                           selection: TextSelection.fromPosition(TextPosition(
//                               offset: initialvalue.toString().length)));
//                       Scaffold.of(context).showSnackBar(new SnackBar(
//                           backgroundColor: Colors.red,
//                           content: new Text("Quantity can't more than it")));
//                     } else {
//                       _qtyController = double.tryParse(value).toString() ?? 0;
//                     }
//                     // setState(() {
//                     //   shipmentLine.quantity =
//                     //       double.tryParse(value).toString() ?? 0;
//                     // });
//                   },
//                 ),
//                 TextFormField(
//                   style: TextStyle(fontFamily: 'Montserrat'),
//                   readOnly: true,
//                   initialValue: _uomController.text,
//                   textAlign: TextAlign.left,
//                   decoration: InputDecoration(
//                     labelText: 'UoM',
//                     labelStyle: TextStyle(fontFamily: 'Montserrat'),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 8.0,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: <Widget>[
//                     RaisedButton(
//                         color: Colors.white,
//                         onPressed: () =>
//                             Navigator.of(context).pop(_qtyController.text),
//                         child: Text('Cancel')),
//                     RaisedButton(
//                         color: Colors.white,
//                         onPressed: () =>
//                             Navigator.of(context).pop(_qtyController.text),
//                         child: Text('Save'))
//                   ],
//                 ),
//               ],
//             ));
//   }

//   void _resetForm() {
//     setState(() {
//       _documentNoController.text = '';
//       _locationToController.text = '';
//       _prodnameController.text = '';
//       _uomController.text = '';
//       _locationController.text = '';
//       wh = null;
//       asset = [];
//     });
//   }
// }
