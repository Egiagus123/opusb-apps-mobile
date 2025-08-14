// ignore_for_file: unused_local_variable, deprecated_member_use, unnecessary_new, prefer_const_constructors, sized_box_for_whitespace, unnecessary_this, avoid_unnecessary_containers, unnecessary_string_interpolations, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:apps_mobile/business_logic/cubit/woservice_cubit.dart';
import 'package:apps_mobile/business_logic/models/bplocation.dart';
import 'package:apps_mobile/business_logic/models/employeegroup.dart';
import 'package:apps_mobile/business_logic/models/equipment_model.dart';
import 'package:apps_mobile/business_logic/models/priority.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/ui/screens/features/workorderissue/woissuedetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:barcode_scan/barcode_scan.dart';
import 'package:date_field/date_field.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/ui/screens/features/workorder/pages/workorder.dart';
import 'package:intl/intl.dart';

class WorkOrderIssueSavePage extends StatefulWidget {
  const WorkOrderIssueSavePage({Key? key}) : super(key: key);

  @override
  WorkOrderIssueSavePageState createState() => WorkOrderIssueSavePageState();
}

class WorkOrderIssueSavePageState extends State<WorkOrderIssueSavePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // TextEditingController _documentNoController = TextEditingController();
  // TextEditingController _locationController = TextEditingController();
  // TextEditingController _locationToController = TextEditingController();
  // TextEditingController _sernoTextController = TextEditingController();
  // TextEditingController _selecteddate;
  // var serno;

  TextEditingController wono = TextEditingController();
  TextEditingController equipmentno = TextEditingController();
  TextEditingController description = TextEditingController();
  // List<WOStatusModel> status = [];
  // List<PriorityModel> priority = [];
  // List<BusinessPartnerModel> bpartner = [];
  // List<BusinessPartnerModel> bpartnerdetail = [];
  // List<BPLocationModel> bplocation = [];
  // List<WOServiceModel> woservicemodel = [];
  // List<DoctypeWOModel> doctypemodel = [];
  // List<EmployeeGroupModel> employeegroup = [];
  // List<EquipmentModel> equipment = [];
  // var location;
  // var wostatus;
  // var prioritydata;
  // var bpdata;
  // var employeegroupdata;
  // var equipmentdata;
  // var equipmentdatanew;
  // var doctypedata;

  // String locationdate;
  // String wostatusdata;
  // String prioritydatanew;
  // String bpdatanew;
  late String movementdate;
  // String enddate;
  // WOServiceCubit woServiceCubit;
  // bool issave = false;

  // var isSelected = false;

  @override
  void initState() {
    super.initState();
    // loadPriority();
    // loadBparner();
    // loadDoctype();
    // loadEmployeeGroup();
    // loadEquipment();
  }

  @override
  void dispose() {
    // _documentNoController.dispose();
    // _locationController.dispose();
    // _locationToController.dispose();
    // _sernoTextController.dispose();
    super.dispose();
  }

  // loadwostatus() async {
  //   await BlocProvider.of<WOServiceCubit>(context).getWOStatus();
  // }

  // loadPriority() async {
  //   await BlocProvider.of<WOServiceCubit>(context).getPriority();
  // }

  // loadBparner() async {
  //   await BlocProvider.of<WOServiceCubit>(context).getBPpartner();
  // }

  // loadBPLocation(int bpid) async {
  //   await BlocProvider.of<WOServiceCubit>(context).getBPLocation(bpid);
  // }

  // loadDoctype() async {
  //   await BlocProvider.of<WOServiceCubit>(context).getDoctype();
  // }

  // savewoservice(data) async {
  //   await BlocProvider.of<WOServiceCubit>(context).savewoservice(data);
  // }

  // loadEmployeeGroup() async {
  //   await BlocProvider.of<WOServiceCubit>(context).getEmployeeGroup();
  // }

  // loadEquipment() async {
  //   await BlocProvider.of<WOServiceCubit>(context).getEquipment();
  // }

  // int activeIndex = 0;
  // final controllercarousel = CarouselController();

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
                      onTap: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            title: Text(
              'Create WO Issue',
              style: TextStyle(
                  fontFamily: 'Oswald',
                  letterSpacing: 1,
                  color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: body()
        // BlocConsumer<WOServiceCubit, WOServiceState>(
        //   builder: (context, state) {
        //     if (state is WOServiceLoadInProgress) {
        //       return Center(child: LoadingIndicator());
        //     }
        //     return Padding(
        //       padding: const EdgeInsets.symmetric(
        //         horizontal: 0.1,
        //         vertical: 0.1,
        //       ),
        //       child: body(),
        //       // equipment.isNotEmpty ? body() : Container(),
        //     );
        //   },
        //   listener: (context, state) {
        //     // if (state is WOStatusSuccess) {
        //     //   status = state.wostatus;
        //     //   print("status =$status");
        //     //   return LoadingIndicator();
        //     //   // tabBar(woservice);
        //     // }
        //     // if (state is PrioritySuccess) {
        //     //   priority = state.priority;
        //     //   print("priority =$priority");
        //     //   return LoadingIndicator();
        //     // } else if (state is BPartnerSuccess) {
        //     //   bpartner = state.bpartner;
        //     //   print("bpartner =$bpartner");
        //     //   bpartnerdetail = bpartner;
        //     //   return LoadingIndicator();
        //     // } else if (state is DoctypeSuccess) {
        //     //   doctypemodel = state.doctype;
        //     //   print("doctypemodel =$doctypemodel");
        //     //   return LoadingIndicator();
        //     // } else if (state is EmployeeGroupSuccess) {
        //     //   employeegroup = state.employeegroup;
        //     //   print("employeegroup =$employeegroup");
        //     //   return LoadingIndicator();
        //     // } else if (state is BPLocationSuccess) {
        //     //   bplocation = state.bplocation;
        //     //   print("bplocation =$bplocation");
        //     // } else if (state is EquipmentSuccess) {
        //     //   equipment = state.equipment;
        //     //   print("equipment =$equipment");
        //     // } else if (state is SaveWOServiceSuccess) {
        //     //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     // Navigator.pushReplacement(
        //     //     context,
        //     //     MaterialPageRoute(
        //     //       builder: (context) => WorkOrderForm(),
        //     //     ));
        //     //   });
        //     // }
        //   },
        // ),
        );
  }

  Widget body() {
    return ListView(children: [
      Container(
        color: purewhiteTheme,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 70),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Work Order No.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Container(
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: Color(0xffEAEAEA),
                      border: Border.all(color: Theme.of(context).primaryColor)
                      // border: Border.all(color: bluepos)
                      ),
                  child: TextFormField(
                    controller: wono,
                    decoration:
                        InputDecoration(hintText: '', border: InputBorder.none),
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
                  'Equipment No.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Container(
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: Color(0xffEAEAEA),
                      border: Border.all(color: Theme.of(context).primaryColor)
                      // border: Border.all(color: bluepos)
                      ),
                  child: TextFormField(
                    controller: equipmentno,
                    decoration:
                        InputDecoration(hintText: '', border: InputBorder.none),
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
                  'Movement Date',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Container(
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: Color(0xffEAEAEA),
                      border: Border.all(color: Theme.of(context).primaryColor)
                      // border: Border.all(color: bluepos)
                      ),
                  child: DateTimeFormField(
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Icon(Icons.event_note,
                          color: Theme.of(context).primaryColor),
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
                        movementdate = startdatesdds;
                      } else {
                        movementdate;
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
                  'Description',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Container(
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: Color(0xffEAEAEA),
                      border: Border.all(color: Theme.of(context).primaryColor)
                      // border: Border.all(color: bluepos)
                      ),
                  child: TextFormField(
                    controller: description,
                    decoration:
                        InputDecoration(hintText: '', border: InputBorder.none),
                    keyboardType: TextInputType.emailAddress,
                    // hint: Text('Choose'),
                    onChanged: (changedValue) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 200,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Color(0xffEAEAEA),
                  border: Border.all(color: Theme.of(context).primaryColor)
                  // border: Border.all(color: bluepos)
                  ),
              width: double.infinity,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkOrderIssueDetailPage(),
                    ),
                  );
                },
                child: Text(
                  'To Details',
                  style: TextStyle(
                      fontFamily: 'Oswald',
                      letterSpacing: 1,
                      color: Theme.of(context).primaryColor),
                ),
                color: Colors.white,
                textColor: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => BlocProvider<AssetTrackingCubit>(
                  //         create: (BuildContext context) =>
                  //             AssetTrackingCubit(),
                  //         child: AssetCartPage(serno, stat, loc)),
                  //   ),
                  // );
                },
                child: Text(
                  'Submit',
                  style: TextStyle(fontFamily: 'Oswald', letterSpacing: 1),
                ),
                color: Theme.of(context).primaryColor,
                disabledColor: Colors.grey[400],
                textColor: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    ]);
  }

  Widget buildPageWOStatus() {
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
                subtitle: DateTimeFormField(
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
                      Context().startdate = value;
                    } else {
                      Context().startdate = null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // ListTile(
              //     contentPadding: EdgeInsets.all(0),
              //     title: status.isNotEmpty
              //         ? Text(
              //             'WO Status',
              //             style: TextStyle(
              //               fontFamily: 'Montserrat',
              //               fontSize: 12,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           )
              //         : SizedBox(
              //             height: 1,
              //           ),
              //     subtitle: status.isNotEmpty && !issave
              //         ? DropdownButtonFormField(
              //             isExpanded: true,
              //             value: wostatus,
              //             items: _buildStatus(context, status),
              //             // hint: Text('Choose'),
              //             onChanged: (changedValue) {
              //               setState(() {
              //                 wostatus = changedValue;
              //               });
              //             },
              //           )
              //         : Text("")),
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
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 100,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => BlocProvider<WOServiceCubit>(
                        create: (BuildContext context) => WOServiceCubit(),
                        child: WorkOrder()))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.save),
                Text('Save'),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    ]);
  }

  List<DropdownMenuItem> _buildequipment(
      BuildContext context, List<EquipmentModel> equipmentdata) {
    // if (_sernoTextController.text.isNotEmpty) {
    //   equipmentdata = [];
    //   // equipmentdata = equipmentdata.where((element) => false);
    // }
    return equipmentdata
        .map((equipmentdata) => DropdownMenuItem(
              value: equipmentdata.id,
              child: Text(
                equipmentdata.documentNo,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: pureblackTheme),
              ),
              onTap: () async {},
            ))
        .toList();
  }

  List<DropdownMenuItem> _buildempolyeegroup(
      BuildContext context, List<EmployeeGroupModel> employeegroup) {
    return employeegroup
        .map((employeegroup) => DropdownMenuItem(
              value: employeegroup.id,
              child: Text(
                employeegroup.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: pureblackTheme),
              ),
              onTap: () async {},
            ))
        .toList();
  }

  List<DropdownMenuItem> _buildLocation(
      BuildContext context, List<BPLocationModel> location) {
    return location
        .map(
          (location) => DropdownMenuItem(
            value: location.id,
            child: Text(
              location.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: pureblackTheme),
            ),
            onTap: () {},
          ),
        )
        .toList();
  }

  List<DropdownMenuItem> _buildPriority(
      BuildContext context, List<PriorityModel> prioritydata) {
    return prioritydata
        .map((prioritydata) => DropdownMenuItem(
              value: prioritydata.value,
              child: Text(
                prioritydata.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: pureblackTheme),
              ),
              onTap: () {},
            ))
        .toList();
  }

  // List<DropdownMenuItem> _buildBPartner(
  //     BuildContext context, List<BusinessPartnerModel> bpdata) {
  //   return bpdata
  //       .map((bpdata) => DropdownMenuItem(
  //             value: bpdata.id,
  //             child: Text(
  //               bpdata.name,
  //               overflow: TextOverflow.ellipsis,
  //               style: TextStyle(color: pureblackTheme),
  //             ),
  //             onTap: () async {
  //               await loadBPLocation(bpdata.id);
  //             },
  //           ))
  //       .toList();
  // }

  // List<DropdownMenuItem> _buildStatus(
  //     BuildContext context, List<WOStatusModel> wostatus) {
  //   issave = true;
  //   return wostatus
  //       .map((wostatus) => DropdownMenuItem(
  //             value: wostatus.value,
  //             child: Text(
  //               wostatus.name,
  //               overflow: TextOverflow.ellipsis,
  //               style: TextStyle(color: pureblackTheme),
  //             ),
  //             onTap: () {},
  //           ))
  //       .toList();
  // }

  // List<DropdownMenuItem> _buildDocType(
  //     BuildContext context, List<DoctypeWOModel> doctypedata) {
  //   return doctypedata
  //       .map((doctypedata) => DropdownMenuItem(
  //             value: doctypedata.id,
  //             child: Text(
  //               doctypedata.name,
  //               overflow: TextOverflow.ellipsis,
  //               style: TextStyle(color: pureblackTheme),
  //             ),
  //             onTap: () {
  //               if (doctypedata.name != null) {
  //                 // Context().wostatus = wostatus.value;
  //               } else {
  //                 // Context().wostatus = '';
  //               }
  //             },
  //           ))
  //       .toList();
  // }
}
