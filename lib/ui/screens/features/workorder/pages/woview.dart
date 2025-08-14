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

class WOView extends StatefulWidget {
  final WOServiceModel woservicemodeldata;
  WOView(this.woservicemodeldata);

  @override
  _WOViewState createState() {
    return _WOViewState(this.woservicemodeldata);
  }
}

class _WOViewState extends State<WOView> {
  TextEditingController _documentNoController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _locationToController = TextEditingController();

  TextEditingController description = TextEditingController();
  TextEditingController actualhour = TextEditingController();
  TextEditingController qtydelivered = TextEditingController();
  WOServiceModel woservicemodeldata;
  _WOViewState(this.woservicemodeldata);

  List<WOStatusModel> status = [];
  List<PriorityModel> priority = [];
  List<BusinessPartnerModel> bpartner = [];
  List<BusinessPartnerModel> bpartnerdetail = [];

  List<BPLocationModel> bplocation = [];

  List<WOServiceModel> woservicemodel = [];
  List<TimeEntryModel> timeentry = [];

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
    _documentNoController.dispose();
    _locationController.dispose();
    _locationToController.dispose();
    super.dispose();
  }

  Future<String> loadwostatus() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit!.getWOStatus();
    return 'success';
  }

  Future<String> loadwotimeentry() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit!.getTimeEntry(woservicemodeldata.bhpWOServiceID.id);
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
                return tabBar(woservicemodeldata);
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
    bpartner.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    bpartnerdetail.forEach((bpartnerdetail) {
      if (bpartnerdetail.name.contains(text) ||
          bpartnerdetail.name.contains(text)) bpartner.add(bpartnerdetail);
    });

    setState(() {});
  }

  Widget buildPageWO(WOServiceModel woservice) {
    String tempstartDate = woservice.startDate;
    DateFormat dateFormat = DateFormat("MM/dd/yyyy");
    DateTime inputstart = dateFormat.parse(tempstartDate);

    String tempendDate = woservice.endDate;

    DateTime inputend = dateFormat.parse(tempendDate);
    final _dateController = TextEditingController(
      text: '  ${DateFormat('dd/MM/yyyy').format(inputstart)}',
    );

    return ListView(children: [
      Card(
        color: purewhiteTheme,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
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
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xffEAEAEA),
                          // border: Border.all(color: Theme.of(context).primaryColor)
                          // border: Border.all(color: bluepos)
                        ),
                        child: DateTimeFormField(
                          initialValue: inputstart,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 12, top: 8, bottom: 8),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ListTile(
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
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xffEAEAEA),
//                      border: Border.all(color: Theme.of(context).primaryColor)
                          // border: Border.all(color: bluepos)
                        ),
                        child: DateTimeFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(left: 12, top: 8, bottom: 8),
                          ),
                          initialValue: inputend,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Document Type',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffEAEAEA),
                            border: Border.all(color: Colors.white)),
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 12, top: 8, bottom: 8),
                              border: InputBorder.none,
                              hintText:
                                  woservicemodeldata.cDocTypeID.identifier),
                          keyboardType: TextInputType.emailAddress,
                          // hint: Text('Choose'),
                          onChanged: (changedValue) {
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Unit Number',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffEAEAEA),
                            border: Border.all(color: Colors.white)),
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 12, top: 8, bottom: 8),
                              border: InputBorder.none,
                              hintText: woservicemodeldata
                                  .bhpinstallbaseid.identifier),
                          keyboardType: TextInputType.emailAddress,
                          // hint: Text('Choose'),
                          onChanged: (changedValue) {
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Location',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffEAEAEA),
                            border: Border.all(color: Colors.white)),
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 12, top: 8, bottom: 8),
                              border: InputBorder.none,
                              hintText: woservicemodeldata
                                          .bparnertlocation.identifier !=
                                      "<0>"
                                  ? woservicemodeldata
                                      .bparnertlocation.identifier
                                  : ""),
                          keyboardType: TextInputType.emailAddress,
                          // hint: Text('Choose'),
                          onChanged: (changedValue) {
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Priority',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffEAEAEA),
                            border: Border.all(color: Colors.white)),
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 12, top: 8, bottom: 8),
                              border: InputBorder.none,
                              hintText:
                                  woservicemodeldata.priorityRule.identifier),
                          keyboardType: TextInputType.emailAddress,
                          // hint: Text('Choose'),
                          onChanged: (changedValue) {
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Work Order Description',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Container(
                        height: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xffEAEAEA),
                            border: Border.all(color: Colors.white)),
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 12, top: 8, bottom: 8),
                              border: InputBorder.none,
                              hintText: woservicemodeldata.description),
                          keyboardType: TextInputType.emailAddress,
                          // hint: Text('Choose'),
                          onChanged: (changedValue) {
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
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

  Widget buildPageWOStatus(WOServiceModel woservice) {
    String tempstartDate = woservice.dateTrx;
    DateFormat dateFormat = DateFormat("MM/dd/yyyy");
    DateTime inputdatetrx = dateFormat.parse(tempstartDate);
    startdate = woservicemodeldata.dateTrx;
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
                    fontSize: 14,
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
                      contentPadding:
                          EdgeInsets.only(left: 10, top: 8, bottom: 8),
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.event_note),
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    validator: (e) =>
                        (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                    onDateSelected: (DateTime value) {
                      print(value);
                      // your dateTime object
                      DateFormat dateFormat = DateFormat(
                          "MM/dd/yyyy"); // how you want it to be formatted
                      String startdatesdds = dateFormat.format(value);
                      startdate = startdatesdds;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: status.isNotEmpty
                      ? Text(
                          'WO Status',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        )
                      : SizedBox(
                          height: 1,
                        ),
                  subtitle: status.isNotEmpty
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
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            isExpanded: true,
                            // value: wostatus,
                            items: _buildStatus(context, status),
                            hint: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  woservicemodeldata.wOStatus.identifier!,
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
                height: 200,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      UpdateWOStatusModel datawostatus = UpdateWOStatusModel(
                          date: startdate!,
                          bhpWOServiceID: Reference(
                              id: woservicemodeldata.bhpWOServiceID.id),
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
    String tempstartDate = timeentry.first.startDate;
    String tempendDate = timeentry.first.endDate;
    String tempactualDate =
        timeentry.first.actualDate.isNotEmpty ? timeentry.first.actualDate : "";
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
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 12, top: 8, bottom: 8),
                      border: InputBorder.none,
                      hintText: ''),
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
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffEAEAEA),
                    // border: Border.all(color: bluepos)
                  ),
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 12, top: 8, bottom: 8),
                      border: InputBorder.none,
                      hintText:
                          timeentry.first.bhpEmployeeGroupID.identifier!.isEmpty
                              ? ""
                              : timeentry.first.bhpEmployeeGroupID.identifier,
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
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffEAEAEA),
                    // border: Border.all(color: bluepos)
                  ),
                  child: TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 12, top: 8, bottom: 8),
                      border: InputBorder.none,
                      hintText:
                          timeentry.first.bhpEmployeeID.identifier!.isEmpty
                              ? ""
                              : timeentry.first.bhpEmployeeID.identifier,
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
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffEAEAEA),
                    // border: Border.all(color: bluepos)
                  ),
                  child: DateTimeFormField(
                    enabled: false,
                    initialValue: inputdatetrx,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 12, top: 8, bottom: 8),
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: InputBorder.none,
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
                        startdate = woservicemodeldata.dateTrx;
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
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xffEAEAEA),
                      // border: Border.all(color: bluepos)
                    ),
                    child: DateTimeFormField(
                      initialValue: inputenddate,
                      enabled: false,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 12, top: 8, bottom: 8),
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: InputBorder.none,
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
                          startdate = woservicemodeldata.dateTrx;
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
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffEAEAEA),
                    // border: Border.all(color: bluepos)
                  ),
                  child: TextFormField(
                    enabled: false,
                    controller: actualhour,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(left: 12, top: 8, bottom: 8),
                        hintText: NumberFormat("####", "id_ID")
                            .format(timeentry.first.qtyEntered)),
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
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border:
                          Border.all(color: Theme.of(context).primaryColor)),
                  child: DateTimeFormField(
                    enabled: true,
                    initialValue: inputactualdate,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 12, top: 8, bottom: 8),
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: InputBorder.none,
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
                        startdate = woservicemodeldata.dateTrx;
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
                        contentPadding:
                            EdgeInsets.only(left: 12, top: 8, bottom: 8),
                        border: InputBorder.none,
                        hintText: NumberFormat("####", "id_ID")
                            .format(timeentry.first.qtyDelivered)),
                    keyboardType: TextInputType.number,
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
                      print("coba aha $tempactualDate ${qtydelivered.text}");

                      print(actualdate);
                      EditTimeEntry edittimeentrydata = EditTimeEntry(
                          description: description.text,
                          actualDate: "$actualdate",
                          qtyDelivered: double.parse(qtydelivered.text));

                      // ignore: avoid_print
                      print('coba aha 2 $edittimeentry');
                      edittimeentry(edittimeentrydata,
                          timeentry.first.bhpResourceAssignmentID.id);
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
