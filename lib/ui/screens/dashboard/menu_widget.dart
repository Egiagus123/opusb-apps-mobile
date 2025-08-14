// import 'package:apps_mobile/business_logic/cubit/asset_offlne_cubit.dart';
// import 'package:apps_mobile/ui/screens/features/assetaudit/assetauditinitial.dart';
// import 'package:apps_mobile/ui/screens/features/assetreceiving/form/assetrcv_form.dart';
// import 'package:apps_mobile/ui/screens/features/assettracking/form/assettracking.dart';
// import 'package:apps_mobile/ui/screens/features/assettrf/form/assettrf_form.dart';
// import 'package:apps_mobile/ui/screens/features/offlineasset/assetshipment/offline_shipment.dart';
// import 'package:apps_mobile/ui/screens/features/offlineasset/form/off_receiving_form.dart';
// import 'package:apps_mobile/ui/screens/features/offlineasset/form/off_trf_form.dart';
// import 'package:apps_mobile/ui/screens/features/workorder/form/workorder_form.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class MenuWidget extends StatelessWidget {
//   final Function? updateTabFunction;
//   final List<Map<String, dynamic>> menus = [
//     // {
//     //   'title': 'Material',
//     //   'title2': 'Receipt',
//     //   'icon': 'assets/iconsmenu/mr.png',
//     //   'color': Colors.cyan[400],
//     //   'page': 'MaterialReceiptPage()'
//     // },
//     // {
//     //   'title': 'Move',
//     //   'title2': 'From',
//     //   'icon': 'assets/iconsmenu/imf.png',
//     //   'color': Colors.lime,
//     //   'page': ' IMFPage()'
//     // },
//     {
//       'title': 'Asset',
//       'title2': 'Transfer',
//       'icon': 'assets/iconsmenu/imt.png',
//       'color': Colors.green,
//       'page': AssetTrfForm()
//     },
//     {
//       'title': 'Asset',
//       'title2': 'Receiving',
//       'icon': 'assets/iconsmenu/ship.png',
//       'color': Colors.blue[400],
//       'page': AssetRcvForm()
//     },
//     {
//       'title': 'Assets',
//       'title2': 'Tracking',
//       'icon': 'assets/iconsmenu/PI.png',
//       'color': Colors.brown,
//       'page': AssetTracking(),
//     },

//     {
//       'title': 'Offline',
//       'title2': 'Transfer',
//       'icon': 'assets/iconsmenu/ship.png',
//       'color': Colors.pink[400],
//       'page': OfflineAssetTrfForm()
//     },
//     {
//       'title': 'Offline',
//       'title2': 'Receiving',
//       'icon': 'assets/iconsmenu/ship.png',
//       'color': Colors.yellow[900],
//       'page': OfflineAssetRcvForm()
//     },
//   ];
//   final List<Map<String, dynamic>> menus2 = [
//     {
//       'title': 'Offline',
//       'title2': 'Trx',
//       'icon': 'assets/iconsmenu/stockoh.png',
//       'color': Colors.indigo,
//       'page': BlocProvider<AssetOfflineCubit>(
//         create: (BuildContext context) => AssetOfflineCubit(),
//         child: OfflineTranscationList(),
//       )
//     },
//     {
//       'title': 'Asset',
//       'title2': 'Audit',
//       'icon': 'assets/iconsmenu/Shipment.png',
//       'color': Colors.orange,
//       'page': AssetAuditInitial()
//     },
//     {
//       'title': 'Work',
//       'title2': 'Order',
//       'icon': 'assets/iconsmenu/workord.png',
//       'color': Colors.blue,
//       'page': WorkOrderForm()
//     },
//     // {
//     //   'title': 'Order',
//     //   'title2': '',
//     //   'icon': 'assets/iconsmenu/order.png',
//     //   'color': Colors.indigo,
//     //   'page': ''
//     // },
//     // {
//     //   'title': 'Stock',
//     //   'title2': 'On Hand',
//     //   'icon': 'assets/iconsmenu/Shipment.png',
//     //   'color': Colors.purple[400],
//     //   'page': ''
//     // },
//   ];

//   MenuWidget({Key? key, this.updateTabFunction}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: menus.map((e) {
//               return Container(
//                 width: (69 / 812.0) * MediaQuery.of(context).size.height,
//                 height: 95,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       MaterialButton(
//                         child: ImageIcon(
//                           AssetImage(e['icon']),
//                           size: 32,
//                           color: Colors.white,
//                         ),
//                         shape: CircleBorder(),
//                         padding: EdgeInsets.all(8),
//                         color: e['color'],
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => e['page']));
//                         },
//                       ),
//                       SizedBox(
//                         height: 4,
//                       ),
//                       Text(
//                         e['title'],
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodySmall!
//                             .copyWith(fontSize: 11),
//                       ),
//                       Text(
//                         e['title2'],
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodySmall!
//                             .copyWith(fontSize: 11),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: menus2.map((e) {
//               return Container(
//                 width: (69 / 812.0) * MediaQuery.of(context).size.height,
//                 height: 80,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       MaterialButton(
//                         child: ImageIcon(
//                           AssetImage(e['icon']),
//                           size: 32,
//                           color: Colors.white,
//                         ),
//                         shape: CircleBorder(),
//                         padding: EdgeInsets.all(8),
//                         color: e['color'],
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => e['page']));
//                         },
//                       ),
//                       SizedBox(
//                         height: 4,
//                       ),
//                       Text(
//                         e['title'],
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodySmall!
//                             .copyWith(fontSize: 11),
//                       ),
//                       Text(
//                         e['title2'],
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodySmall!
//                             .copyWith(fontSize: 11),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }
