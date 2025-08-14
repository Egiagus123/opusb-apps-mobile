import 'package:apps_mobile/business_logic/cubit/woservice_cubit.dart';
import 'package:apps_mobile/business_logic/models/woservice_model.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/woservice/woservice_service.dart';
import 'package:apps_mobile/ui/screens/features/workorder/pages/wofilter.dart';
import 'package:apps_mobile/ui/screens/features/workorderrequest/pages/worequestdetail.dart';
import 'package:apps_mobile/ui/screens/features/workorderrequest/pages/worequestsaveheader.dart';
import 'package:apps_mobile/ui/screens/home/home_body.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:apps_mobile/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WorkOrderRequest extends StatefulWidget {
  static String routeName = "/workorder";
  @override
  _WorkOrderRequestState createState() => _WorkOrderRequestState();
}

class _WorkOrderRequestState extends State<WorkOrderRequest> {
  TextEditingController controller = TextEditingController();
  List<WOServiceModel> listservice = [];
  List<WOServiceModel> listservicenew = [];
  late WOServiceCubit woServiceCubit;
  int pageNo = 0;
  int count = 0;
  String _searchResult = '';
  String delivery = 'DELIVERY';
  bool short = true;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    // loadinitData();
    setNewData();
  }

  void setNewData() async {
    if (pageNo == 0) {
      setState(() {
        isloading = true;
      });
    }
    List<WOServiceModel> templistservice =
        await sl<WOServiceService>().getWOServiceRequest_(pageNo);

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
    await woServiceCubit.getWOServiceRequest();
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
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeBody(),
                  ));
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

            return Container(padding: EdgeInsets.all(5), child: buildbody());
          } else {
            return Container(padding: EdgeInsets.all(5), child: buildbody());
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
                          child: WorkOrderRequestSavePage())));
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
    print('ListSO Length >>> ${listservicenew.length}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.all(1),
          child: Container(
            width: 600,
            height: 220,
            color: Colors.white,
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
                    Container(
                      width: 330,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Work Request List',
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
                  height: 40,
                ),
                Container(
                  width: 450,
                  child: Card(
                    color: Color(0xffF8F9F9),
                    child: new ListTile(
                      leading: const Icon(Icons.search),
                      title: new TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                              hintText: 'Search by Work Order Number',
                              border: InputBorder.none),
                          onChanged: (value) {
                            setState(() {
                              _searchResult = value;
                              listservicenew = Context()
                                  .finalListWO
                                  .where((woservice) => woservice.documentNo
                                      .toUpperCase()
                                      .contains(_searchResult.toUpperCase()))
                                  .toList();
                            });
                          }),
                    ),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                viewfilter(filter: _dropdownfilter(), short: _dropdownshort())
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: listservicenew == null ? 0 : listservicenew.length,
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
                              child: WorkOrderRequestDetailPage(
                                  shortitem[index]))));
                },
                child: Column(
                  children: [
                    Container(
                      width: 430,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: whiteTheme,
                        // const Color(0xffF8F9F9)
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
                                width: 190,
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
                                                      color: Color(0xff18A116)),
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
                                                      color: Color(0xffC32DD0)),
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
                                      shortitem[index].wOStatus.identifier !=
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
                                        borderRadius: BorderRadius.circular(5),
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
                                        borderRadius: BorderRadius.circular(5),
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
                                        borderRadius: BorderRadius.circular(5),
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
                              // SizedBox(
                              //   width: 190,
                              // ),
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
                                  height: shortitem[index].description.isEmpty
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
                                    : shortitem[index].cDocTypeID.identifier!,
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
                                height: 50,
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
                                                  fontWeight: FontWeight.normal,
                                                  color:
                                                      const Color(0xff959798)),
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
                                            shortitem[index].mLocatorID! == null
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
                                                fontWeight: FontWeight.normal,
                                                color: const Color(0xff959798)),
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
                    SizedBox(
                      height: 10,
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

  Widget viewfilter({Widget? filter, Widget? short}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 17,
        ),
        Expanded(flex: 2, child: filter!),
        const SizedBox(
          width: 5,
        ),
        Expanded(flex: 1, child: short!),
        Expanded(flex: 3, child: Container()),
      ],
    );
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

                  listservicenew.toList();
                  setState(() {
                    buildbody();
                  });
                } else {
                  setState(() {
                    short = false;
                  });
                  listservicenew.reversed.toList();
                  setState(() {
                    buildbody();
                  });
                }

                // Navigator.pushReplacementNamed(context, '/customer');
              }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   width: 5,
                  // ),
                  Image.asset(
                    'assets/short.png',
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // Text(
                  //   'Sorting by WO number',
                  //   style: TextStyle(
                  //     color: Theme.of(context).primaryColor,
                  //     fontWeight: FontWeight.w600,
                  //     fontFamily: 'Montserrat',
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _dropdownfilter() {
    return Container(
      // width: 10,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: whiteTheme,
        // const Color(0xffF8F9F9),
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 1),
          TextButton(
            onPressed: (() {
              Context().startdate = null;
              Context().enddate = null;
              // Navigator.pushReplacementNamed(context, '/customer');
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => BlocProvider<WOServiceCubit>(
                          create: (BuildContext context) => WOServiceCubit(),
                          child: WOFilter(
                            listWO: Context().finalListWO,
                            setListWO: (listWOFiltered) {
                              setState(() {
                                listservicenew = listWOFiltered;
                              });
                            },
                          ))));
            }),
            child: Row(
              children: [
                Image.asset(
                  'assets/icon-filter.jpg',
                  scale: 1,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  width: 3,
                ),
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
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
