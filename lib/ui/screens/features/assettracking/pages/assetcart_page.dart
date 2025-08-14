import 'dart:convert';
import 'package:apps_mobile/business_logic/cubit/asset_tracking_cubit.dart';
import 'package:apps_mobile/business_logic/models/installbase_model.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/features/core/component/color.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/model/data.dart';
import 'package:apps_mobile/services/assettracking/asset_tracking_service.dart';
import 'package:apps_mobile/ui/screens/features/assettracking/pages/assetcart_detail.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:apps_mobile/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../service_locator.dart';

class AssetCartPage extends StatefulWidget {
  final String sn, status;
  final int location;

  AssetCartPage(this.sn, this.status, this.location);
  @override
  _AssetCartPageState createState() {
    return _AssetCartPageState(this.sn, this.status, this.location);
  }
}

class _AssetCartPageState extends State<AssetCartPage> {
  bool selected1 = false;
  bool selected2 = false;
  String sn, status;
  int location;
  var serno;
  List? data;
  Data? modeldata;
  _AssetCartPageState(this.sn, this.status, this.location);
  AssetTrackingCubit? assetTrackingCubit;
  List<InstallBaseModel>? loadList = [];
  List<InstallBaseModel>? loadListnew = [];

  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  bool short = true;

  Future<String> loadinitData() async {
    assetTrackingCubit = BlocProvider.of<AssetTrackingCubit>(context);
    await assetTrackingCubit!.getListDataAsset(sn, status, location);
    return 'success';
  }

  @override
  void initState() {
    super.initState();
    loadinitData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0), // here the desired height
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
                        onTap: () => Navigator.pop(context, true)),
                  ],
                ),
              ],
            ),
            title: Text(
              'Equipment',
              style: TextStyle(
                  fontFamily: 'Oswald',
                  letterSpacing: 1,
                  color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: BlocConsumer<AssetTrackingCubit, AssetTrackingState>(
            builder: (context, state) {
              if (state is AssetTrackingLoadInstallBase) {
                this.loadList = state.installBase;
                if (loadListnew!.isEmpty) {
                  this.loadListnew = loadList;
                }
                return Container(
                    padding: EdgeInsets.all(5), child: buildPage());
              } else if (state is AssetTrackigInProgress) {
                return LoadingIndicator();
              } else {
                return buildPage();
              }
            },
            listener: (context, state) {}));
  }

  Widget _dropdownshort() {
    return Container(
      // width: 20,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: const Color(0xffF8F9F9)
        // const Color(0xffF8F9F9)
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: (() {
              if (!short) {
                setState(() {
                  short = true;
                });

                loadListnew!.toList();
                setState(() {
                  buildPage();
                });
              } else {
                setState(() {
                  short = false;
                });
                loadListnew!.reversed.toList();
                setState(() {
                  buildPage();
                });
              }

              // Navigator.pushReplacementNamed(context, '/customer');
            }),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/short.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget viewfilter({Widget? filter, Widget? short}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 17,
        ),
        Expanded(flex: 1, child: short!),
        Expanded(flex: 3, child: Container()),
      ],
    );
  }

  Widget buildPage() {
    return Column(
      children: [
        // Container(
        //   width: 450,
        //   child: Card(
        //     color: Color(0xffF8F9F9),
        //     child: new ListTile(
        //       leading: const Icon(Icons.search),
        //       title: new TextField(
        //           controller: controller,
        //           decoration: const InputDecoration(
        //               hintText: 'Search by Work Order Number',
        //               border: InputBorder.none),
        //           onChanged: (value) {
        //             setState(() {
        //               _searchResult = value;
        //               loadListnew = loadList
        //                   .where((equipment) =>
        //                       equipment.documentNo.contains(_searchResult) ||equipment.serNo.contains(_searchResult) )
        //                   .toList();
        //             });
        //           }),
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 18,
        ),
        viewfilter(short: _dropdownshort()),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: loadListnew == null ? 0 : loadListnew!.length,
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext ctx, int position) {
              final shortitem =
                  short ? loadListnew!.reversed.toList() : loadList;

              var docno = shortitem![position].documentNo == null
                  ? ''
                  : shortitem[position].documentNo;
              var asset = shortitem[position].description == null
                  ? ''
                  : shortitem[position].description;
              var serno = shortitem[position].serNo == null
                  ? ''
                  : shortitem[position].serNo;
              var status = shortitem[position].status.identifier == null
                  ? ''
                  : shortitem[position].status.identifier;
              return InkWell(
                onTap: () async {
                  var photo = await sl<AssetTrackingService>()
                      .getphoto(shortitem[position].id);
                  Base64Codec base64 = Base64Codec();
                  var decodephoto =
                      photo == "null" ? null : base64.decode(photo);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              BlocProvider<AssetTrackingCubit>(
                                  create: (BuildContext context) =>
                                      AssetTrackingCubit(),
                                  child: AssetCartDetail(
                                      shortitem[position], decodephoto))));
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 430,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        // const Color(0xffF8F9F9)
                        border: Border.all(color: Colors.grey, width: 1.5),
                      ),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 190,
                                ),
                                status == 'Available'
                                    ? Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: 100,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color(0xffEEFFE6)
                                                .withOpacity(0.5),
                                            // const Color(0xffF8F9F9)
                                            border: Border.all(
                                                color: Color(0xff6EE789),
                                                width: 1.5),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '$status',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: 'Poppins',
                                                        fontSize: 13,
                                                        color:
                                                            Color(0xff18A116)),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                status == 'Down - On Shop' ||
                                        status == 'Down - On Site'
                                    ? Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: 100,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color(0xffFFF8DE)
                                                .withOpacity(0.5),
                                            // const Color(0xffF8F9F9)
                                            border: Border.all(
                                                color: Color(0xffF9D988),
                                                width: 1.5),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '$status',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 13,
                                                        color:
                                                            Color(0xffE98427)),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                status != 'Down - On Shop' &&
                                        status != 'Down - On Site' &&
                                        status != 'Available'
                                    ? Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: 100,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color(0xffD3D3D3)
                                                .withOpacity(0.2),
                                            // const Color(0xffD3D3D3)
                                            border: Border.all(
                                                color: const Color(0xffD3D3D3),
                                                width: 1.5),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '$status',
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 500,
                                  child: Text(
                                    asset,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.normal,
                                        color: blackTheme
                                        // const Color(0xff959798)
                                        ),
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                )
                              ],
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        docno,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.normal,
                                            color: const Color(0xff959798)),
                                      ),
                                      // Text(datetime),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        serno,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.normal,
                                            color: const Color(0xff959798)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.pin_drop_outlined,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                shortitem[position]
                                                                .locator
                                                                .identifier ==
                                                            null ||
                                                        shortitem[position]
                                                            .locator
                                                            .identifier!
                                                            .isEmpty ||
                                                        shortitem[position]
                                                                .locator
                                                                .identifier ==
                                                            "<0>"
                                                    ? ""
                                                    : shortitem[position]
                                                        .locator
                                                        .identifier!,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Poppins',
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: const Color(
                                                        0xff959798)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ),
              );
            },
          ),
        ),
      ],
    );
  }
}
