import 'package:apps_mobile/business_logic/cubit/woservice_cubit.dart';
import 'package:apps_mobile/business_logic/models/woservice_model.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/business_logic/utils/size_config.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/woservice/woservice_service.dart';
import 'package:apps_mobile/ui/screens/features/workorder/pages/wocompletion.dart';
import 'package:apps_mobile/ui/screens/features/workorder/pages/wofilter.dart';
import 'package:apps_mobile/ui/screens/features/workorder/pages/wosaveheader.dart';
import 'package:apps_mobile/ui/screens/features/workorder/pages/woview.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:apps_mobile/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WorkOrder extends StatefulWidget {
  static String routeName = "/workorder";
  @override
  _WorkOrderState createState() => _WorkOrderState();
}

class _WorkOrderState extends State<WorkOrder> {
  TextEditingController controller = TextEditingController();
  List<WOServiceModel> listservice = [];
  List<WOServiceModel> listservicenew = [];
  late WOServiceCubit woServiceCubit;
  int count = 0;
  int pageNo = 0;
  String _searchResult = '';
  String delivery = 'DELIVERY';
  bool short = true;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    loadinitData();
    // setNewData();
  }

  void setNewData() async {
    if (pageNo == 0) {
      setState(() {
        isloading = true;
      });
    }
    List<WOServiceModel> templistservice =
        await sl<WOServiceService>().getWOService_(pageNo);
    if (mounted) {
      if (templistservice.isNotEmpty) {
        setState(() {
          listservicenew.addAll(templistservice);
          pageNo++;
          Context().finalListWO = listservicenew;
        });
        setNewData();
      }
      if (pageNo == 1) {
        setState(() {
          isloading = false;
        });
      }
    } else {
      return;
    }
  }

  Future<String> loadinitData() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit.getWOService();
    return 'success';
  }

  List<WOServiceModel> itemsBetweenDates({
    List<WOServiceModel>? dates,
    List<WOServiceModel>? items,
    DateTime? start,
    DateTime? end,
  }) {
    assert(dates!.length == items!.length);

    var output = <WOServiceModel>[];
    for (var i = 0; i < dates!.length; i += 1) {
      String tempstartDate = dates[i].startDate;
      DateFormat dateFormat = DateFormat("MM/dd/yyyy");

      DateTime inputstart = dateFormat.parse(tempstartDate);

      String tempendDate = dates[i].endDate;

      DateTime inputend = dateFormat.parse(tempendDate);

      if (start != null && end != null) {
        if (inputstart.compareTo(start) >= 0 &&
            inputstart.compareTo(end) <= 0) {
          output.add(items![i]);
        } else if (inputend.compareTo(start) >= 0 &&
            inputend.compareTo(end) <= 0) {
          output.add(items![i]);
        }
      }
    }
    return output;
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
      backgroundColor: whiteTheme,
      body: BlocConsumer<WOServiceCubit, WOServiceState>(
        builder: (context, state) {
          if (state is WOServiceLoadInProgress || isloading == true) {
            return LoadingIndicator();
          } else if (state is WOServiceSuccess) {
            this.listservice = state.listservice;
            if (listservicenew.isEmpty) {
              this.listservicenew = listservice;
              print(listservicenew.length);
            }

            if (Context().wostatus != '') {
              listservicenew = listservicenew
                  .where((woservice) =>
                      woservice.wOStatus.id.contains(Context().wostatus))
                  .toList();
            }

            if (Context().priority != '') {
              listservicenew = listservicenew
                  .where((woservice) => woservice.priorityRule.identifier!
                      .contains(Context().priority))
                  .toList();
            }

            if (Context().bpwo > 0) {
              listservicenew = listservicenew
                  .where(
                      (woservice) => woservice.bpartnerid.id == Context().bpwo)
                  .toList();
            }

            if (Context().equipmentid > 0) {
              listservicenew = listservicenew
                  .where((woservice) =>
                      woservice.bhpinstallbaseid.id == Context().equipmentid)
                  .toList();
            }

            if (Context().bplocationwo > 0) {
              listservicenew = listservicenew
                  .where((woservice) =>
                      woservice.bparnertlocation.id == Context().bplocationwo)
                  .toList();
            }

            if (Context().startdate != null && Context().enddate != null) {
              listservicenew = itemsBetweenDates(
                  dates: listservicenew,
                  items: listservicenew,
                  start: Context().startdate,
                  end: Context().enddate);
            }

            return Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 0.01),
                child: buildbody());
          } else {
            return Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 0.01),
                child: buildbody());
          }
        },
        listener: (context, state) {},
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => BlocProvider<WOServiceCubit>(
                          create: (BuildContext context) => WOServiceCubit(),
                          child: WorkOrderSavePage())));
            },
            child: Container(
              height: 50,
              width: 50,
              child: Icon(
                Icons.add_box_rounded,
                size: 35,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildbody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  SizedBox(width: 20),
                  InkWell(
                    child: Container(
                      height: SizeConfig.screenHeight * 0.03,
                      width: SizeConfig.screenWidth * 0.08,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                  Container(
                    width: SizeConfig.screenWidth * 0.75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Work Order',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Montserrat',
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              viewfilter(filter: _dropdownfilter(), short: _dropdownshort()),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: listservicenew.isEmpty ? 0 : listservicenew.length,
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext ctx, int index) {
              final shortitem =
                  short ? listservicenew.reversed.toList() : listservicenew;

              String tempDate = shortitem[index].endDate;
              DateFormat dateFormat = DateFormat("MM/dd/yyyy");

              DateTime input = dateFormat.parse(tempDate);

              DateFormat dateFormatnew = DateFormat("MMM dd,yyyy");

              String datetime = dateFormatnew.format(input);
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => BlocProvider<WOServiceCubit>(
                              create: (BuildContext context) =>
                                  WOServiceCubit(),
                              child: WOView(shortitem[index]))));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth * 0.02),
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.screenHeight * 0.02,
                              horizontal: SizeConfig.screenWidth * 0.02),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: whiteTheme,
                            border: Border.all(color: Colors.grey, width: 1.5),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 150,
                                  ),
                                  shortitem[index].wOStatus.identifier ==
                                          'Completed'
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
                                                      '${shortitem[index].wOStatus.identifier}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily: 'Poppins',
                                                          color: Color(
                                                              0xff18A116)),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  shortitem[index].wOStatus.identifier ==
                                          'In Progress'
                                      ? Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: 100,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color(0xffF8DEFF)
                                                  .withOpacity(0.5),
                                              // const Color(0xffF8F9F9)
                                              border: Border.all(
                                                  color: Color(0xffDB88F9),
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
                                                      '${shortitem[index].wOStatus.identifier}',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Color(
                                                              0xffC32DD0)),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  shortitem[index].wOStatus.identifier !=
                                              'In Progress' &&
                                          shortitem[index]
                                                  .wOStatus
                                                  .identifier !=
                                              'Completed'
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
                                                  color:
                                                      const Color(0xffD3D3D3),
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
                                                      '${shortitem[index].wOStatus.identifier}',
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
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
                                  shortitem[index]
                                              .priorityRule
                                              .identifier
                                              .toString() ==
                                          'High'
                                      ? Container(
                                          width: 70,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: const Color(0xffFFE1E1)
                                                .withOpacity(0.5),
                                            // const Color(0xffFFE1E1)
                                            border: Border.all(
                                                color: const Color(0xffED6565),
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
                                                    shortitem[index]
                                                        .priorityRule
                                                        .identifier!,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: 'Poppins',
                                                        color: Colors.red),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  shortitem[index].priorityRule.identifier ==
                                          'Medium'
                                      ? Container(
                                          width: 70,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: const Color(0xffFFF8DE)
                                                .withOpacity(0.5),
                                            // const Color(0xffFFF8DE)
                                            border: Border.all(
                                                color: const Color(0xffF9D988),
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
                                                    shortitem[index]
                                                        .priorityRule
                                                        .identifier!,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: 'Poppins',
                                                        color: const Color(
                                                            0xffE98427)),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  shortitem[index].priorityRule.identifier !=
                                              'Medium' &&
                                          shortitem[index]
                                                  .priorityRule
                                                  .identifier !=
                                              'High'
                                      ? Container(
                                          width: 70,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: const Color(0xffEEFFE6)
                                                .withOpacity(0.5),
                                            // const Color(0xff18A116)
                                            border: Border.all(
                                                color: const Color(0xff6EE789),
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
                                                    shortitem[index]
                                                        .priorityRule
                                                        .identifier!,
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: const Color(
                                                            0xff18A116)),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              SizedBox(height: 2),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shortitem[index].documentNo,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff959798)),
                                  ),
                                  SizedBox(
                                      height:
                                          shortitem[index].description.isEmpty
                                              ? 0
                                              : 2),
                                  shortitem[index].description.isEmpty
                                      ? SizedBox()
                                      : Text(
                                          shortitem[index].description,
                                          softWrap: true,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Lato',
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff323233)),
                                        ),
                                  Divider(
                                    thickness: 2,
                                  )
                                ],
                              ),
                              SizedBox(height: 3),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    datetime,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.normal,
                                        color: const Color(0xff959798)),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    shortitem[index]
                                                .cDocTypeID
                                                .identifier!
                                                .isEmpty ||
                                            shortitem[index]
                                                    .cDocTypeID
                                                    .identifier! ==
                                                "<0>"
                                        ? ""
                                        : shortitem[index]
                                            .cDocTypeID
                                            .identifier!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.normal,
                                        color: const Color(0xff959798)),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    shortitem[index]
                                                .bhpinstallbaseid
                                                .identifier!
                                                .isEmpty ||
                                            shortitem[index]
                                                    .bhpinstallbaseid
                                                    .identifier! ==
                                                "<0>"
                                        ? ""
                                        : shortitem[index]
                                            .bhpinstallbaseid
                                            .identifier!,
                                    softWrap: true,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.normal,
                                        color: const Color(0xff959798)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                              builder: (context) =>
                                                  WOCompletionPage(
                                                      wono: shortitem[index]
                                                          .bhpWOServiceID
                                                          .identifier),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 120,
                                          child: shortitem[index]
                                                      .wOStatus
                                                      .identifier ==
                                                  'In Operation'
                                              ? Container(
                                                  width: 70,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Color(0xffEEFFE6)
                                                        .withOpacity(0.5),
                                                    // const Color(0xffF8F9F9)
                                                    border: Border.all(
                                                        color:
                                                            Color(0xff6EE789),
                                                        width: 1.5),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'To Completion',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color(
                                                                    0xff18A116)),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                        ),
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
                                          Container(
                                            width: 130,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.people_alt_outlined,
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Text(
                                                  shortitem[index]
                                                      .adUserID
                                                      .identifier!,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: const Color(
                                                          0xff959798)),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 40,
                                      ),
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
                                                shortitem[index].mLocatorID! ==
                                                        null
                                                    //     .identifier
                                                    //     .isEmpty ||
                                                    // shortitem[index]
                                                    //         .mLocatorID
                                                    //         .identifier ==
                                                    //     "<0>"
                                                    ? ""
                                                    : shortitem[index]
                                                        .mLocatorID
                                                        .identifier!,
                                                style: TextStyle(
                                                    fontSize: 15,
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
                          )

                          //  ListTile(
                          //   title:
                          //   subtitle:
                          // ),
                          ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget viewfilter({Widget? filter, Widget? short}) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.height * 0.05,
              // margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.012,
                ),
                child: TextField(
                  controller: controller,
                  onChanged: (value) {
                    setState(() {
                      _searchResult = value;
                      print(Context().finalListWO.length);
                      listservicenew = listservice
                          .where((woservice) => woservice.documentNo
                              .toUpperCase()
                              .contains(_searchResult.toUpperCase()))
                          .toList();
                      print(listservicenew.length);
                    });
                  },
                  decoration: InputDecoration(
                    // isDense: true,
                    isCollapsed: true,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search by Work Order Number',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          filter!,
          const SizedBox(
            width: 5,
          ),
          short!,
          // Expanded(flex: 2, child: Container()),
        ],
      ),
    );
  }

  Widget _dropdownshort() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: Center(
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            setState(() {
              short = !short;
              short
                  ? listservicenew.toList()
                  : listservicenew.reversed.toList();
              buildbody();
            });
          },
          child: Image.asset(
            'assets/short.png',
            width: 16,
            height: 16,
          ),
        ),
      ),
    );
  }

  Widget _dropdownfilter() {
    return Container(
      // Buat tinggi mengikuti isi konten dengan batas minimal
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.05,
        maxHeight: MediaQuery.of(context).size.height * 0.05,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: whiteTheme,
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // Agar ukuran sekecil mungkin sesuai isi
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero, // Hilangkan padding bawaan
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              Context().startdate = null;
              Context().enddate = null;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<WOServiceCubit>(
                    create: (context) => WOServiceCubit(),
                    child: WOFilter(
                      listWO: Context().finalListWO,
                      setListWO: (listWOFiltered) {
                        setState(() {
                          listservicenew = listWOFiltered;
                        });
                      },
                    ),
                  ),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icon-filter.jpg',
                  width: 20,
                  height: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  'Filter',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
