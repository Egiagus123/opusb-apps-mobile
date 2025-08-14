// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'package:apps_mobile/business_logic/cubit/asset_tracking_cubit.dart';
import 'package:apps_mobile/business_logic/cubit/woservice_cubit.dart';
import 'package:apps_mobile/business_logic/models/installbase_model.dart';
import 'package:apps_mobile/business_logic/models/recentitem.dart';
import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/business_logic/utils/size_config.dart';
import 'package:apps_mobile/services/assettracking/asset_tracking_service.dart';
import 'package:apps_mobile/services/woservice/woservice_service.dart';
import 'package:apps_mobile/ui/screens/dashboard/watchlist.dart';
import 'package:apps_mobile/ui/screens/features/MeterReading/meterreadingheader.dart';
import 'package:apps_mobile/ui/screens/features/assetreceiving/form/assetrcv_form.dart';
import 'package:apps_mobile/ui/screens/features/assettracking/form/assettracking.dart';
import 'package:apps_mobile/ui/screens/features/assettracking/pages/assetcart_detail.dart';
import 'package:apps_mobile/ui/screens/features/assettrf/form/assettrf_form.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/form/off_trf_form.dart';
import 'package:apps_mobile/ui/screens/features/pmlist/pmlistform.dart';
import 'package:apps_mobile/ui/screens/features/workorder/form/workorder_form.dart';
import 'package:apps_mobile/ui/screens/features/workorderissue/woissuesaveheader.dart';
import 'package:apps_mobile/ui/screens/features/workorderrequest/form/workorderrequest_form.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'chart.dart';
import '../../../service_locator.dart';
import 'chart.dart';
import 'greeting_widget.dart';

class DashboardBody extends StatefulWidget {
  static String routeName = "/dashboard";
  @override
  _DashboardBodyState createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody>
    with WidgetsBindingObserver {
  Future<String> loadinitDataRecentItem() async {
    List<RecentItem> recentitemdata =
        await sl<WOServiceService>().getRecentItem();

    print(recentitemdata);
    setState(() {
      Context().recentitem = recentitemdata;
    });

    return 'success';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadinitDataRecentItem();
  }

  TextEditingController _sernoTextController = TextEditingController();
  var serno;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2));
      },
      child: ListView(
        children: [
          Stack(
            children: [
              Stack(
                // padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  GreetingWidget(),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    height: SizeConfig.screenHeight * 0.4,
                    width: SizeConfig.screenWidth * 1,
                    child: Image.asset(
                      "assets/segitigacomponent.png",
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              width: SizeConfig.screenWidth * 0.7,
                              // height: 45, // Mengatur lebar TextField
                              child: TextField(
                                cursorWidth: 0.1,
                                controller: _sernoTextController,
                                decoration: InputDecoration(
                                  hintText: '   Search Asset',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                  ),
                                  prefixIcon:
                                      Icon(Icons.search, color: grayField),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.qr_code_scanner,
                                        color: grayField
                                        // Theme.of(context).primaryColor
                                        ),
                                    onPressed: () async {
                                      String? value = await scanBarcode(
                                          context); // Ganti FlutterBarcodeScanner dengan scanBarcode(context)

                                      setState(() {
                                        _sernoTextController =
                                            TextEditingController(text: value);
                                        FocusScope.of(context).unfocus();
                                        serno = value;
                                      });

                                      print(_sernoTextController.text);

                                      List<InstallBaseModel> loadInstallBase =
                                          await sl<AssetTrackingService>()
                                              .getListDataAsset(
                                                  _sernoTextController.text,
                                                  null,
                                                  null);

                                      var photo =
                                          await sl<AssetTrackingService>()
                                              .getphoto(
                                                  loadInstallBase.first.id);
                                      Base64Codec base64 = Base64Codec();
                                      var decodephoto = photo == "null"
                                          ? null
                                          : base64.decode(photo);
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider<
                                                          AssetTrackingCubit>(
                                                      create: (BuildContext
                                                              context) =>
                                                          AssetTrackingCubit(),
                                                      child: AssetCartDetail(
                                                          loadInstallBase.first,
                                                          decodephoto))));
                                    },
                                  ),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        17.0), // Sudut melengkung
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .primaryColor), // Warna border
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12.0), // Padding vertikal
                                  filled: true,
                                  fillColor:
                                      Colors.white, // Warna latar belakang
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth * 0.01,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue[600],
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13, horizontal: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              print(_sernoTextController.text);
                              List<InstallBaseModel> loadInstallBase =
                                  await sl<AssetTrackingService>()
                                      .getListDataAsset(
                                          _sernoTextController.text,
                                          null,
                                          null);

                              var photo = await sl<AssetTrackingService>()
                                  .getphoto(loadInstallBase.first.id);
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
                                                  loadInstallBase.first,
                                                  decodephoto))));
                            },
                            // {Navigator.pop(context, true), LoadingIndicator()},

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Cari',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: SizeConfig.screenHeight * 0.58,
                            width: SizeConfig.screenWidth * 0.8,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    // Theme.of(context).primaryColor,
                                    // Color(0xFF81D1F0)
                                    Colors.white70, Colors.white
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomRight),

                              shape: BoxShape.rectangle,
                              // color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text("My Menus",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Montserrat',
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        InkWell(
                                          child: Container(
                                            height:
                                                SizeConfig.screenHeight * 0.08,
                                            width:
                                                SizeConfig.screenHeight * 0.08,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    // Theme.of(context).primaryColor,
                                                    // Color(0xFF81D1F0)
                                                    Color(0xFFBBDEFB),
                                                    Color(0XffFFFFFF)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomLeft),

                                              shape: BoxShape.rectangle,
                                              // color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.04),
                                              child: SizedBox(
                                                child: Image.asset(
                                                  "assets/delivery1.png",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    WorkOrderForm(),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          ' Work\nOrder',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          child: Container(
                                            height:
                                                SizeConfig.screenHeight * 0.08,
                                            width:
                                                SizeConfig.screenHeight * 0.08,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    // Theme.of(context).primaryColor,
                                                    // Color(0xFF81D1F0)
                                                    Color(0xFFBBDEFB),
                                                    Color(0XffFFFFFF)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomLeft),

                                              shape: BoxShape.rectangle,
                                              // color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.04),
                                              child: SizedBox(
                                                child: Image.asset(
                                                  "assets/Group7774.png",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    WorkOrderRequestForm(),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '    Work\n  Request',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          child: Container(
                                            height:
                                                SizeConfig.screenHeight * 0.08,
                                            width:
                                                SizeConfig.screenHeight * 0.08,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    // Theme.of(context).primaryColor,
                                                    // Color(0xFF81D1F0)
                                                    Color(0xFFBBDEFB),
                                                    Color(0XffFFFFFF)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomLeft),

                                              shape: BoxShape.rectangle,
                                              // color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.04),
                                              child: SizedBox(
                                                child: Image.asset(
                                                  "assets/receiver1.png",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    WorkOrderIssueSavePage(),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          ' WO\nIssue',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        InkWell(
                                          child: Container(
                                            height:
                                                SizeConfig.screenHeight * 0.08,
                                            width:
                                                SizeConfig.screenHeight * 0.08,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    // Theme.of(context).primaryColor,
                                                    // Color(0xFF81D1F0)
                                                    Color(0xFFBBDEFB),
                                                    Color(0XffFFFFFF)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomLeft),

                                              shape: BoxShape.rectangle,
                                              // color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.04),
                                              child: SizedBox(
                                                child: Image.asset(
                                                  "assets/shopping1.png",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AssetRcvForm(),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '   Asset\nReceiving',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          child: Container(
                                            height:
                                                SizeConfig.screenHeight * 0.08,
                                            width:
                                                SizeConfig.screenHeight * 0.08,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    // Theme.of(context).primaryColor,
                                                    // Color(0xFF81D1F0)
                                                    Color(0xFFBBDEFB),
                                                    Color(0XffFFFFFF)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomLeft),

                                              shape: BoxShape.rectangle,
                                              // color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.04),
                                              child: SizedBox(
                                                child: Image.asset(
                                                  "assets/gps1.png",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AssetTracking(),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '    Asset\n  Tracking',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          child: Container(
                                            height:
                                                SizeConfig.screenHeight * 0.08,
                                            width:
                                                SizeConfig.screenHeight * 0.08,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    // Theme.of(context).primaryColor,
                                                    // Color(0xFF81D1F0)
                                                    Color(0xFFBBDEFB),
                                                    Color(0XffFFFFFF)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomLeft),

                                              shape: BoxShape.rectangle,
                                              // color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.04),
                                              child: SizedBox(
                                                child: Image.asset(
                                                  "assets/speedometer1.png",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        BlocProvider<
                                                                WOServiceCubit>(
                                                            create: (BuildContext
                                                                    context) =>
                                                                WOServiceCubit(),
                                                            child:
                                                                MeterReadingPage())));
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '  Meter\nReading',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        InkWell(
                                          child: Container(
                                            height:
                                                SizeConfig.screenHeight * 0.08,
                                            width:
                                                SizeConfig.screenHeight * 0.08,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    // Theme.of(context).primaryColor,
                                                    // Color(0xFF81D1F0)
                                                    Color(0xFFBBDEFB),
                                                    Color(0XffFFFFFF)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomLeft),

                                              shape: BoxShape.rectangle,
                                              // color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.04),
                                              child: SizedBox(
                                                child: Image.asset(
                                                  "assets/Group160.png",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OfflineAssetTrfForm(),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          ' Offline\nTransfer',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          child: Container(
                                            height:
                                                SizeConfig.screenHeight * 0.08,
                                            width:
                                                SizeConfig.screenHeight * 0.08,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    // Theme.of(context).primaryColor,
                                                    // Color(0xFF81D1F0)
                                                    Color(0xFFBBDEFB),
                                                    Color(0XffFFFFFF)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomLeft),

                                              shape: BoxShape.rectangle,
                                              // color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.04),
                                              child: SizedBox(
                                                child: Image.asset(
                                                  "assets/transfer1.png",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AssetTrfForm(),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '  Asset\nTransfer',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03,
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          child: Container(
                                            height:
                                                SizeConfig.screenHeight * 0.09,
                                            width:
                                                SizeConfig.screenHeight * 0.08,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    // Theme.of(context).primaryColor,
                                                    // Color(0xFF81D1F0)
                                                    Color(0xFFBBDEFB),
                                                    Color(0XffFFFFFF)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomLeft),

                                              shape: BoxShape.rectangle,
                                              // color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.04),
                                              child: SizedBox(
                                                child: Image.asset(
                                                  "assets/checklist1.png",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) => BlocProvider<
                                                            AssetTrackingCubit>(
                                                        create: (BuildContext
                                                                context) =>
                                                            AssetTrackingCubit(),
                                                        child: PMListForm())));
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'PM List',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                    ],
                  )
                ],
              ),
              Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 1.63,
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'WORK ORDER STATUS',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontFamily: 'Oswald'),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16),
                      //   child: DashboardNumber(),
                      // ),
                      // LineChartSample2(),
                      // BarChart(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: BarChart(),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'RECENT ITEMS',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontFamily: 'Oswald'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          elevation: 3,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: Context().recentitem.take(10).length,
                            itemBuilder: (BuildContext context, int position) {
                              return Column(
                                children: [
                                  ListTile(
                                    dense: true,
                                    // title: Text(wl.name),
                                    // title: Text('Movement Waiting Approval'),
                                    title: Text(
                                        "${Context().recentitem[position].name} : ${Context().recentitem[position].cDoctypeid.identifier} "),
                                    trailing: Text(
                                      (Context()
                                                      .recentitem[position]
                                                      .bhpwoserviceid ==
                                                  null
                                              ? Context()
                                                  .recentitem[position]
                                                  .bhpmeterreadingid
                                                  .identifier
                                              : Context()
                                                  .recentitem[position]
                                                  .bhpwoserviceid
                                                  .identifier) ??
                                          'Default Value', // Jika keduanya null, tampilkan "Default Value"
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      Divider(),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16),
                      //   child: Row(
                      //     children: [
                      //       SizedBox(
                      //         width: 20,
                      //       ),
                      //       Text(
                      //         'Articles & News',
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .headline6
                      //             .copyWith(fontFamily: 'Oswald'),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 16),
                      //   child: NewsWidget(),
                      // ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
