// ignore_for_file: unused_local_variable, deprecated_member_use, unnecessary_new, prefer_const_constructors, sized_box_for_whitespace, unnecessary_this, avoid_unnecessary_containers, unnecessary_string_interpolations, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:apps_mobile/business_logic/cubit/woservice_cubit.dart';
import 'package:apps_mobile/business_logic/models/bplocation.dart';
import 'package:apps_mobile/business_logic/models/businesspartner.dart';
import 'package:apps_mobile/business_logic/models/doctypewo.dart';
import 'package:apps_mobile/business_logic/models/employeegroup.dart';
import 'package:apps_mobile/business_logic/models/equipment_model.dart';
import 'package:apps_mobile/business_logic/models/meterdisplay.dart';
import 'package:apps_mobile/business_logic/models/priority.dart';
import 'package:apps_mobile/business_logic/models/woservice_model.dart';
import 'package:apps_mobile/business_logic/models/wostatus.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/features/core/base/widgets/loading_indicator.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/ui/screens/features/workorderrequest/form/workorderrequest_form.dart';
import 'package:apps_mobile/ui/screens/home/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkOrderRequestDetailPage extends StatefulWidget {
  final WOServiceModel woservicemodeldata;
  WorkOrderRequestDetailPage(this.woservicemodeldata);

  @override
  WorkOrderRequestDetailPageState createState() =>
      WorkOrderRequestDetailPageState(this.woservicemodeldata);
}

class WorkOrderRequestDetailPageState
    extends State<WorkOrderRequestDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _documentNoController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _locationToController = TextEditingController();
  TextEditingController _sernoTextController = TextEditingController();
  var serno;

  TextEditingController description = TextEditingController();
  TextEditingController startdatec = TextEditingController();
  List<WOStatusModel> status = [];
  List<PriorityModel> priority = [];
  List<BusinessPartnerModel> bpartner = [];
  List<BusinessPartnerModel> bpartnerdetail = [];
  List<BPLocationModel> bplocation = [];
  List<WOServiceModel> woservicemodel = [];
  List<DoctypeWOModel> doctypemodel = [];
  List<EmployeeGroupModel> employeegroup = [];
  List<EquipmentModel> equipment = [];
  List<MeterTypeModel> metertype = [];
  var location;
  var wostatus;
  var prioritydata;
  var bpdata;
  var employeegroupdata;
  var equipmentdata;
  var equipmentdatanew;
  var doctypedata;
  var metertypedata;

  String? locationdate;
  String? wostatusdata;
  String? prioritydatanew;
  String? bpdatanew;
  String? startdate;
  String? enddate;
  WOServiceCubit? woServiceCubit;
  bool issave = false;

  var isSelected = false;

  WOServiceModel woservicemodeldata;

  WorkOrderRequestDetailPageState(this.woservicemodeldata);

  @override
  void initState() {
    super.initState();
    loadEquipment();
  }

  @override
  void dispose() {
    _sernoTextController.dispose();
    super.dispose();
  }

  loadEquipment() async {
    await BlocProvider.of<WOServiceCubit>(context).getEquipment();
  }

  int activeIndex = 0;

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
            'Detail Work Request',
            style: TextStyle(
                fontFamily: 'Oswald',
                letterSpacing: 1,
                color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: BlocConsumer<WOServiceCubit, WOServiceState>(
        builder: (context, state) {
          if (state is WOServiceLoadInProgress) {
            return Center(child: LoadingIndicator());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0.1,
              vertical: 0.1,
            ),
            child: body(),
            // equipment.isNotEmpty ? body() : Container(),
          );
        },
        listener: (context, state) {
          if (state is WOStatusSuccess) {
            status = state.wostatus;
            print("status =$status");
            LoadingIndicator();
            // tabBar(woservice);
          }
          if (state is PrioritySuccess) {
            priority = state.priority;
            print("priority =$priority");
            LoadingIndicator();
          } else if (state is BPartnerSuccess) {
            bpartner = state.bpartner;
            print("bpartner =$bpartner");
            bpartnerdetail = bpartner;
            LoadingIndicator();
          } else if (state is DoctypeSuccess) {
            doctypemodel = state.doctype;
            print("doctypemodel =$doctypemodel");
            LoadingIndicator();
          } else if (state is EmployeeGroupSuccess) {
            employeegroup = state.employeegroup;
            print("employeegroup =$employeegroup");
            LoadingIndicator();
          } else if (state is BPLocationSuccess) {
            bplocation = state.bplocation;
            print("bplocation =$bplocation");
          } else if (state is EquipmentSuccess) {
            equipment = state.equipment;
            print("equipment =$equipment");
          } else if (state is MeterTypeSuccess) {
            metertype = state.metertype;
            print("metertype =$metertype");
          } else if (state is SaveWOServiceSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkOrderRequestForm(),
                  ));
            });
          }
        },
      ),
    );
  }

  Widget body() {
    List<EquipmentModel> equipmentdatabaru = equipment
        .where((i) => i.id == woservicemodeldata.bhpinstallbaseid.id)
        .toList();

    return ListView(children: [
      Card(
        color: purewhiteTheme,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 340),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Request Date',
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
                    // border:
                    //     Border.all(color: Theme.of(context).primaryColor)
                  ),
                  child: TextFormField(
                    enabled: false,
                    controller: startdatec..text = woservicemodeldata.startDate,
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
                  'Work Order Descriprion',
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
                    // border:
                    //     Border.all(color: Theme.of(context).primaryColor)
                  ),
                  child: TextFormField(
                    enabled: false,
                    controller: description
                      ..text = woservicemodeldata.description,
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
                  'Serial No',
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
                    // border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(border: InputBorder.none),
                    enabled: false,
                    controller: _sernoTextController
                      ..text = equipmentdatabaru.first.serNo,
                    onChanged: (changedValue) {
                      setState(() {
                        equipmentdata = changedValue;
                      });
                    },
                  ),
                ),
                trailing: equipmentdata == null
                    ? IconButton(
                        iconSize: 45,
                        icon: Icon(Icons.qr_code_scanner,
                            color: Theme.of(context).primaryColor),
                        onPressed: () async {},
                      )
                    : SizedBox(),
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
}
