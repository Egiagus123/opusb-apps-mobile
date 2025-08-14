import 'package:apps_mobile/business_logic/models/edittimeentry.dart';
import 'package:apps_mobile/business_logic/models/timeentry.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:date_field/date_field.dart';
import 'package:apps_mobile/business_logic/cubit/woservice_cubit.dart';
import 'package:apps_mobile/business_logic/models/bplocation.dart';
import 'package:apps_mobile/business_logic/models/businesspartner.dart';
import 'package:apps_mobile/business_logic/models/priority.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/models/updatewostatus_model.dart';
import 'package:apps_mobile/business_logic/models/woservice_model.dart';
import 'package:apps_mobile/business_logic/models/wostatus.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/ui/screens/features/workorder/pages/workorder.dart';
import 'package:apps_mobile/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WORequestView extends StatefulWidget {
  final WOServiceModel woservicemodeldata;
  WORequestView(this.woservicemodeldata);

  @override
  _WORequestViewState createState() {
    return _WORequestViewState(this.woservicemodeldata);
  }
}

class _WORequestViewState extends State<WORequestView> {
  TextEditingController? _documentNoController = TextEditingController();
  TextEditingController? _locationController = TextEditingController();
  TextEditingController? _locationToController = TextEditingController();

  TextEditingController? description = TextEditingController();
  TextEditingController? actualhour = TextEditingController();
  TextEditingController? qtydelivered = TextEditingController();
  WOServiceModel? woservicemodeldata;

  _WORequestViewState(this.woservicemodeldata);

  List<WOStatusModel>? status = [];
  List<PriorityModel>? priority = [];
  List<BusinessPartnerModel>? bpartner = [];
  List<BusinessPartnerModel>? bpartnerdetail = [];

  List<BPLocationModel>? bplocation = [];

  List<WOServiceModel>? woservicemodel = [];
  List<TimeEntryModel>? timeentry = [];

  var location;
  var wostatus;
  var prioritydata;
  var bpdata;

  String? locationdate;
  String? wostatusdata;
  String? prioritydatanew;
  String? bpdatanew;
  String? startdate;
  String? enddate;
  WOServiceCubit? woServiceCubit;

  var isSelected = false;
  @override
  void initState() {
    super.initState();
    loadwostatus();
    loadwotimeentry();
  }

  @override
  void dispose() {
    _documentNoController!.dispose();
    _locationController!.dispose();
    _locationToController!.dispose();
    super.dispose();
  }

  Future<String> loadwostatus() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit!.getWOStatus();
    return 'success';
  }

  Future<String> loadwotimeentry() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit!.getTimeEntry(woservicemodeldata!.bhpWOServiceID.id);
    return 'success';
  }

  updatewostatus(data) async {
    await BlocProvider.of<WOServiceCubit>(context).updatewostatus(data);
  }

  edittimeentry(data, int timeentryid) async {
    await BlocProvider.of<WOServiceCubit>(context)
        .editTimeEntry(data, timeentryid);
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
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          title: Text(
            'Detail Work Order',
            style: TextStyle(
                fontFamily: 'Oswald',
                letterSpacing: 1,
                color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      body: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0), // here the desired height
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Color(0xffEAEAEA),
                bottom: new TabBar(
                  indicatorColor: Colors.grey,
                  labelColor: Colors.white,
                  indicatorWeight: 1,
                  // indicatorColor: blackTheme,
                  unselectedLabelColor: Colors.grey,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor),
                  tabs: <Widget>[
                    // new Tab(
                    //   text: 'Work Order',
                    // ),
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // border: Border.all(color: bluepos)
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // border: Border.all(color: bluepos)
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Status',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // border: Border.all(color: bluepos)
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Time Entry',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.grey[200],
            body: BlocConsumer<WOServiceCubit, WOServiceState>(
              builder: (context, state) {
                return tabBar(woservicemodeldata!);
              },
              listener: (context, state) {},
            )),
      ),
    );
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

  TextEditingController controller = new TextEditingController();
  Widget tabBar(WOServiceModel woservice) {
    return TabBarView(
      children: <Widget>[
        new Scaffold(
          backgroundColor: Colors.grey[200],
          body: BlocConsumer<WOServiceCubit, WOServiceState>(
            builder: (context, state) {
              if (state is WOServiceLoadInProgress) {
                return LoadingIndicator();
              }
              return buildPageWO(woservice);
            },
            listener: (context, state) {
              if (state is WOStatusSuccess) {
                status = state.wostatus;
              } else if (state is TimeEntrySuccess) {
                timeentry = state.timeentry;
              }
            },
          ),
        ),
        new Scaffold(
          backgroundColor: Colors.grey[200],
          body: BlocConsumer<WOServiceCubit, WOServiceState>(
            builder: (context, state) {
              if (state is WOServiceLoadInProgress) {
                return LoadingIndicator();
              }
              return buildPageWOStatus(woservice);
            },
            listener: (context, state) {
              if (state is WOStatusSuccess) {
                status = state.wostatus;
              }
              if (state is UpdateWOStatusSuccess) {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => BlocProvider<WOServiceCubit>(
                            create: (BuildContext context) => WOServiceCubit(),
                            child: WorkOrder())));
              }
            },
          ),
        ),
        new Scaffold(
          backgroundColor: Colors.grey[200],
          body: BlocConsumer<WOServiceCubit, WOServiceState>(
            builder: (context, state) {
              if (state is WOServiceLoadInProgress) {
                return LoadingIndicator();
              }
              return buildPageTimeEntry(woservice);
            },
            listener: (context, state) {
              if (state is WOStatusSuccess) {
                status = state.wostatus;
              }
              if (state is UpdateTimeEntrySuccess) {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => BlocProvider<WOServiceCubit>(
                            create: (BuildContext context) => WOServiceCubit(),
                            child: WorkOrder())));
              }
            },
          ),
        ),
      ],
    );
  }

  onSearchTextChanged(String text) async {
    bpartner!.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    bpartnerdetail!.forEach((bpartnerdetail) {
      if (bpartnerdetail.name.contains(text) ||
          bpartnerdetail.name.contains(text)) bpartner!.add(bpartnerdetail);
    });

    setState(() {});
  }

  Widget buildPageWO(WOServiceModel woservice) {
    String tempstartDate = woservice.startDate;
    DateFormat dateFormat = DateFormat("MM/dd/yyyy");
    DateTime inputstart = dateFormat.parse(tempstartDate);

    DateFormat dateFormatwib = DateFormat("MM/dd/yyyy");

    print("coba aha ${inputstart.month} ${inputstart.day}");

    // DateTime date = dateFormatwib.parse(tempstartDate);
    // print('date adalah $date');

    String tempendDate = woservice.endDate;

    DateTime inputend = dateFormat.parse(tempendDate);

    return ListView(children: [
      Card(
        color: purewhiteTheme,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Row(
                    children: [
                      Text(
                        'Unit Number',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        woservicemodeldata!.bhpinstallbaseid.identifier!,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Row(
                  children: [
                    Text(
                      'Customer',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 45,
                    ),
                    Text(
                      woservicemodeldata!.bpartnerid.identifier!,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Row(
                  children: [
                    Text(
                      'Location',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      woservicemodeldata!.bparnertlocation.identifier!,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Row(
                  children: [
                    Text(
                      'Assign To',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 43,
                    ),
                    Text(
                      woservicemodeldata!.bhpEmployeeGroupID.identifier!,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Row(
                  children: [
                    Text(
                      'Priority',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 58,
                    ),
                    Text(
                      woservicemodeldata!.priorityRule.identifier!,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Start Date',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: DateTimeFormField(
                  initialValue: inputstart,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'End Date',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: DateTimeFormField(
                  initialValue: inputend,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
    ]);
  }

  Widget coba() {
    return Column(
      children: [
        Container(
          width: 360,
          height: 965,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 20,
                top: 141,
                child: Container(
                  width: 320,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date',
                              style: TextStyle(
                                color: Color(0xFF1B1919),
                                fontSize: 16,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 153,
                              height: 41,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFF1995C5)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 17,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Choose Date',
                                                  style: TextStyle(
                                                    color: Color(0xFF1B1919),
                                                    fontSize: 14,
                                                    fontFamily: 'Lato',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(),
                                    child: FlutterLogo(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status',
                              style: TextStyle(
                                color: Color(0xFF1B1919),
                                fontSize: 16,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 320,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFF1995C5)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 24,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Priority',
                              style: TextStyle(
                                color: Color(0xFF1B1919),
                                fontSize: 16,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 320,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFF1995C5)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 24,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer',
                              style: TextStyle(
                                color: Color(0xFF1B1919),
                                fontSize: 16,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 320,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFF1995C5)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 24,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: TextStyle(
                                color: Color(0xFF1B1919),
                                fontSize: 16,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 320,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFF1995C5)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 24,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Container(
                        padding: const EdgeInsets.only(right: 1),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 255,
                              child: Text(
                                'Unit No.',
                                style: TextStyle(
                                  color: Color(0xFF1B1919),
                                  fontSize: 16,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 56,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1, color: Color(0xFF1995C5)),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Container(
                                    width: 45,
                                    height: 45,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(),
                                    child: FlutterLogo(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Container(
                        width: 320,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Equipment',
                              style: TextStyle(
                                color: Color(0xFF1B1919),
                                fontSize: 16,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 320,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFF1995C5)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Date',
                              style: TextStyle(
                                color: Color(0xFF1B1919),
                                fontSize: 16,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 153,
                              height: 41,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFF1995C5)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 17,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Choose Date',
                                                  style: TextStyle(
                                                    color: Color(0xFF1B1919),
                                                    fontSize: 14,
                                                    fontFamily: 'Lato',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(),
                                    child: FlutterLogo(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 871,
                child: Container(
                  width: 360,
                  height: 94,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 360,
                          height: 94,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 23,
                        child: Container(
                          width: 320,
                          height: 48,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 320,
                                  height: 48,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF00ADEF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 138.50,
                                top: 14,
                                child: Text(
                                  'Search',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 360,
                  height: 42,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 360,
                          height: 42,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        top: 12,
                        child: Container(
                          width: 54,
                          height: 18,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(width: 54, height: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 242,
                        top: 12,
                        child: Container(
                          width: 18,
                          height: 18,
                          padding: const EdgeInsets.all(1.50),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://via.placeholder.com/15x15"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 305,
                        top: 14.47,
                        child: Container(
                          width: 18,
                          height: 21.71,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 3.10, vertical: 3.74),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 11.80,
                                height: 14.23,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://via.placeholder.com/12x14"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 284,
                        top: 12,
                        child: Container(
                          width: 18,
                          height: 18,
                          padding: const EdgeInsets.only(
                            top: 2.95,
                            left: 1.20,
                            right: 1.38,
                            bottom: 3.80,
                          ),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 15.42,
                                height: 11.25,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://via.placeholder.com/15x11"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 263,
                        top: 12,
                        child: Container(
                          width: 18,
                          height: 18,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 326,
                        top: 14.47,
                        child: Container(
                          width: 18,
                          height: 21.71,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1.50, vertical: 4.52),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 42,
                child: Container(
                  width: 360,
                  height: 79,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 360,
                          height: 79,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Filter Work Order',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF4199BC),
                                  fontSize: 18,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 19,
                        top: 21,
                        child: Container(
                          width: 36,
                          height: 36,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: ShapeDecoration(
                                          color: Color(0xFF00ADEF),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPageWOStatus(WOServiceModel woservice) {
    String tempstartDate = woservice.dateTrx;
    DateFormat dateFormat = DateFormat("MM/dd/yyyy");
    DateTime inputdatetrx = dateFormat.parse(tempstartDate);
    startdate = woservicemodeldata!.dateTrx;
    return ListView(children: [
      Card(
        color: purewhiteTheme,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Status Change Date',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Container(
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: Theme.of(context).primaryColor)
                      // border: Border.all(color: bluepos)
                      ),
                  child: DateTimeFormField(
                    initialValue: inputdatetrx,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    validator: (e) =>
                        (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                    onDateSelected: (DateTime value) {
                      print(value);
                      if (value != null) {
                        // your dateTime object
                        DateFormat dateFormat = DateFormat(
                            "MM/dd/yyyy"); // how you want it to be formatted
                        String startdatesdds = dateFormat.format(value);
                        startdate = startdatesdds;
                      } else {
                        startdate = woservicemodeldata!.dateTrx;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: status!.isNotEmpty
                      ? Text(
                          'WO Status',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        )
                      : SizedBox(
                          height: 1,
                        ),
                  subtitle: status!.isNotEmpty
                      ? Container(
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(
                                  color: Theme.of(context).primaryColor)
                              // border: Border.all(color: bluepos)
                              ),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            // value: wostatus,
                            items: _buildStatus(context, status!),
                            hint: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  woservicemodeldata!.wOStatus.identifier!,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),

                            onChanged: (changedValue) {
                              setState(() {
                                wostatus = changedValue;
                              });
                            },
                          ),
                        )
                      : Text("")),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 190),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      UpdateWOStatusModel datawostatus = UpdateWOStatusModel(
                          date: startdate!,
                          bhpWOServiceID: Reference(
                              id: woservicemodeldata!.bhpWOServiceID.id),
                          wOStatus: wostatus);

                      // ignore: avoid_print
                      print(datawostatus);
                      updatewostatus(datawostatus);
                    },
                    // {Navigator.pop(context, true), LoadingIndicator()},

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Update',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
    ]);
  }

  var actualdate;

  Widget buildPageTimeEntry(WOServiceModel woservice) {
    String tempstartDate = timeentry!.first.startDate;
    String tempendDate = timeentry!.first.endDate;
    String tempactualDate =
        timeentry!.first.actualDate != null ? timeentry!.first.actualDate : "";
    DateFormat dateFormat = DateFormat("MM/dd/yyyy");
    DateTime inputdatetrx = dateFormat.parse(tempstartDate);
    DateTime inputenddate = dateFormat.parse(tempendDate);

    DateFormat dateFormatnew = DateFormat("MM/dd/yyyy");
    DateTime inputactualdate;

    if (tempactualDate == '') {
      inputactualdate = DateTime.now();
    } else {
      inputactualdate = dateFormatnew.parse(tempactualDate);
    }

    // startdate = woservicemodeldata.dateTrx;
    return ListView(children: [
      Card(
        color: purewhiteTheme,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                children: [],
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Activity Report',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: TextFormField(
                  enabled: true,
                  controller: description,
                  decoration: InputDecoration(hintText: ''),
                  keyboardType: TextInputType.emailAddress,
                  // hint: Text('Choose'),

                  onChanged: (changedValue) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Employee Group',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffEAEAEA),
                    // border: Border.all(color: bluepos)
                  ),
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: timeentry!.first.bhpEmployeeGroupID.identifier,
                      hintStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // keyboardType: TextInputType.emailAddress,
                    // hint: Text('Choose'),

                    onChanged: (changedValue) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Employee',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffEAEAEA),
                    // border: Border.all(color: bluepos)
                  ),
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: timeentry!.first.bhpEmployeeID.identifier,
                      hintStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // hint: Text('Choose'),

                    onChanged: (changedValue) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Start Date',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffEAEAEA),
                    // border: Border.all(color: bluepos)
                  ),
                  child: DateTimeFormField(
                    enabled: false,
                    initialValue: inputdatetrx,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    validator: (e) =>
                        (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                    onDateSelected: (DateTime value) {
                      print(value);
                      if (value != null) {
                        // your dateTime object
                        DateFormat dateFormat = DateFormat(
                            "MM/dd/yyyy"); // how you want it to be formatted
                        String startdatesdds = dateFormat.format(value);
                        startdate = startdatesdds;
                      } else {
                        startdate = woservicemodeldata!.dateTrx;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text(
                    'End Date',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffEAEAEA),
                      // border: Border.all(color: bluepos)
                    ),
                    child: DateTimeFormField(
                      initialValue: inputenddate,
                      enabled: false,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                      ),
                      autovalidateMode: AutovalidateMode.always,
                      validator: (e) => (e?.day ?? 0) == 1
                          ? 'Please not the first day'
                          : null,
                      onDateSelected: (DateTime value) {
                        print(value);
                        if (value != null) {
                          // your dateTime object
                          DateFormat dateFormat = DateFormat(
                              "MM/dd/yyyy"); // how you want it to be formatted
                          String startdatesdds = dateFormat.format(value);
                          startdate = startdatesdds;
                        } else {
                          startdate = woservicemodeldata!.dateTrx;
                        }
                      },
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Estimate Hours',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Hour(s)',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffEAEAEA),
                    // border: Border.all(color: bluepos)
                  ),
                  child: TextFormField(
                    enabled: false,
                    controller: actualhour,
                    decoration: InputDecoration(
                        hintText: NumberFormat("####", "id_ID")
                            .format(timeentry!.first.qtyEntered)),
                    keyboardType: TextInputType.emailAddress,
                    // hint: Text('Choose'),

                    onChanged: (changedValue) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Actual End Date and Time',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border:
                          Border.all(color: Theme.of(context).primaryColor)),
                  child: DateTimeFormField(
                    enabled: true,
                    initialValue: inputactualdate,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    validator: (e) =>
                        (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                    onDateSelected: (DateTime value) {
                      print(value);
                      if (value != null) {
                        // your dateTime object
                        DateFormat dateFormat = DateFormat(
                            "MMM dd, yyyy h:m:s a"); // how you want it to be formatted
                        String startdatesdds = dateFormat.format(value);

                        actualdate =
                            "$startdatesdds ${inputactualdate.timeZoneName}";

                        print(actualdate);
                      } else {
                        startdate = woservicemodeldata!.dateTrx;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Actual Hours',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Hour(s)',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Container(
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: Theme.of(context).primaryColor)
                      // border: Border.all(color: bluepos)
                      ),
                  child: TextFormField(
                    enabled: true,
                    controller: qtydelivered,
                    decoration: InputDecoration(
                        hintText: NumberFormat("####", "id_ID")
                            .format(timeentry!.first.qtyDelivered)),
                    keyboardType: TextInputType.emailAddress,
                    // hint: Text('Choose'),

                    onChanged: (changedValue) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      print("coba aha $actualdate ${qtydelivered!.text}");

                      print(actualdate);
                      EditTimeEntry edittimeentrydata = EditTimeEntry(
                          description: description!.text,
                          actualDate: "$actualdate",
                          qtyDelivered: double.parse(qtydelivered!.text));

                      // ignore: avoid_print
                      print('coba aha 2 $edittimeentry');
                      edittimeentry(edittimeentrydata,
                          timeentry!.first.bhpResourceAssignmentID.id);
                    },
                    // {Navigator.pop(context, true), LoadingIndicator()},

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Update',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
    ]);
  }

  List<DropdownMenuItem> _buildStatus(
      BuildContext context, List<WOStatusModel> wostatus) {
    // issave = true;
    return wostatus
        .map((wostatus) => DropdownMenuItem(
              value: wostatus.value,
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    wostatus.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              onTap: () {},
            ))
        .toList();
  }
}
