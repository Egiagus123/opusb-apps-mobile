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
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/models/saverecentitem.dart';
import 'package:apps_mobile/business_logic/models/saveworequest_model.dart';
import 'package:apps_mobile/business_logic/models/woservice_model.dart';
import 'package:apps_mobile/business_logic/models/wostatus.dart';
import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/features/core/base/widgets/loading_indicator.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/ui/screens/features/workorderrequest/form/workorderrequest_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_field/date_field.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/ui/screens/features/workorder/pages/workorder.dart';
import 'package:intl/intl.dart';

class WorkOrderRequestSavePage extends StatefulWidget {
  const WorkOrderRequestSavePage({Key? key}) : super(key: key);

  @override
  WorkOrderRequestSavePageState createState() =>
      WorkOrderRequestSavePageState();
}

class WorkOrderRequestSavePageState extends State<WorkOrderRequestSavePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _documentNoController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _locationToController = TextEditingController();
  TextEditingController _sernoTextController = TextEditingController();
  var serno;

  TextEditingController description = TextEditingController();
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

  late String locationdate;
  late String wostatusdata;
  late String prioritydatanew;
  late String bpdatanew;
  late String startdate;
  late String enddate;
  late WOServiceCubit woServiceCubit;
  bool issave = false;

  var isSelected = false;

  @override
  void initState() {
    super.initState();
    loadEquipment();
    loadMeterType();
    loadPriority();
    loadBparner();
    loadDoctype();
    loadEmployeeGroup();
  }

  @override
  void dispose() {
    _documentNoController.dispose();
    _locationController.dispose();
    _locationToController.dispose();
    _sernoTextController.dispose();
    super.dispose();
  }

  loadwostatus() async {
    await BlocProvider.of<WOServiceCubit>(context).getWOStatus();
  }

  loadPriority() async {
    await BlocProvider.of<WOServiceCubit>(context).getPriority();
  }

  loadBparner() async {
    await BlocProvider.of<WOServiceCubit>(context).getBPpartner();
  }

  loadBPLocation(int bpid) async {
    await BlocProvider.of<WOServiceCubit>(context).getBPLocation(bpid);
  }

  loadDoctype() async {
    await BlocProvider.of<WOServiceCubit>(context).getDoctype();
  }

  loadMeterType() async {
    await BlocProvider.of<WOServiceCubit>(context).getMeterType();
  }

  savewoservice(data) async {
    await BlocProvider.of<WOServiceCubit>(context).savewoservice(data);
  }

  saverecentitems(data) async {
    await BlocProvider.of<WOServiceCubit>(context).saverecentitems(data);
  }

  getrecentitems() async {
    await BlocProvider.of<WOServiceCubit>(context).getRecentItem();
  }

  loadWOService() async {
    await BlocProvider.of<WOServiceCubit>(context).getWOServiceID();
  }

  loadEmployeeGroup() async {
    await BlocProvider.of<WOServiceCubit>(context).getEmployeeGroup();
  }

  loadEquipment() async {
    await BlocProvider.of<WOServiceCubit>(context).getEquipment();
  }

  int activeIndex = 0;
  List<WOServiceModel> woservice = [];

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
            'Create Work Request',
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
            loadWOService();
          } else if (state is WOServiceSuccess) {
            woservice = state.listservice;
            SaveRecentItem data = SaveRecentItem(
              documentNo: woservice.first.documentNo,
              cDoctypeid: Reference(id: woservice.first.cDocTypeID.id),
              name: "WO Request",
              bHPWOServiceID: Reference(id: woservice.first.bhpWOServiceID.id),
            );

            saverecentitems(data);
          } else if (state is SaveRecentItemsSuccess) {
            getrecentitems();
          } else if (state is RecentItemsSuccess) {
            setState(() {
              Context().recentitem = state.recentitem;
            });

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkOrderRequestForm(),
                ));
          }
        },
      ),
    );
  }

  Widget body() {
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
                      // color: Color(0xffEAEAEA),
                      border:
                          Border.all(color: Theme.of(context).primaryColor)),
                  child: DateTimeFormField(
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      fillColor: Theme.of(context).primaryColor,
                      suffixIcon: Icon(
                        Icons.event_note,
                        color: Theme.of(context).primaryColor,
                      ),
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
                        startdate;
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
                      // color: Color(0xffEAEAEA),
                      border:
                          Border.all(color: Theme.of(context).primaryColor)),
                  child: TextFormField(
                    controller: description,

                    decoration: InputDecoration(
                      hintText: '',
                      border: InputBorder.none,
                    ),
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
                    // color: Color(0xffEAEAEA),
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                  child: TextFormField(
                    enabled: true,
                    controller: _sernoTextController,
                    decoration: InputDecoration(
                      hintText: '',
                      border: InputBorder.none,
                    ),
                    onFieldSubmitted: (changedValue) {
                      setState(() {
                        print("bugs $changedValue");
                        List<EquipmentModel> equipmentdatabaru = equipment
                            .where((i) => i.serNo == changedValue)
                            .toList();

                        equipmentdata = equipmentdatabaru.first.id;
                        print("bugs $equipmentdata");
                      });
                    },
                    onChanged: (changedValue) {
                      setState(() {
                        print("bugs $changedValue");
                        List<EquipmentModel> equipmentdatabaru = equipment
                            .where((i) => i.serNo == changedValue)
                            .toList();

                        equipmentdata = equipmentdatabaru.first.id;
                        print("bugs $equipmentdata");
                      });
                    },
                  ),
                ),
                trailing: (equipmentdata == null || equipmentdata == "")
                    ? IconButton(
                        iconSize: 40,
                        icon: Icon(Icons.qr_code_scanner,
                            color: Theme.of(context).primaryColor),
                        onPressed: () async {
                          // Scanning barcode
                          String? scanResult = await scanBarcode(
                              context); // Menggunakan scanBarcode(context)

                          setState(() {
                            _sernoTextController =
                                TextEditingController(text: scanResult);
                            FocusScope.of(context).unfocus();
                            serno = scanResult;

                            // Filter the equipment based on the scanned serial number
                            List<EquipmentModel> equipmentdatabaru = equipment
                                .where((i) => i.serNo == serno)
                                .toList();

                            if (equipmentdatabaru.isNotEmpty) {
                              equipmentdatanew = equipmentdatabaru.first.id;
                            }
                          });
                        },
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
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 150),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              SaveWORequestModel datawoservice = SaveWORequestModel(
                description: description.text,
                requestedDate: startdate,
                startDate: startdate,
                endDate: startdate,
                bhpinstallbaseid: Reference(
                    id:
                        //  1000063
                        equipmentdata == null || equipmentdata == ""
                            ? equipmentdatanew
                            : equipmentdata),
                cDoctypeid: Reference(id: 1001355),
                priorityRule: '5',
              );
              // ignore: avoid_print
              print(datawoservice);
              savewoservice(datawoservice);
            },
            // {Navigator.pop(context, true), LoadingIndicator()},

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Submit',
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
              ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: status.isNotEmpty
                      ? Text(
                          'WO Status',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : SizedBox(
                          height: 1,
                        ),
                  subtitle: status.isNotEmpty && !issave
                      ? DropdownButtonFormField(
                          isExpanded: true,
                          value: wostatus,
                          items: _buildStatus(context, status),
                          // hint: Text('Choose'),
                          onChanged: (changedValue) {
                            setState(() {
                              wostatus = changedValue;
                            });
                          },
                        )
                      : Text("")),
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
    if (_sernoTextController.text.isNotEmpty) {
      equipmentdata = [];
      // equipmentdata = equipmentdata.where((element) => false);
    }
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

  List<DropdownMenuItem> _buildBPartner(
      BuildContext context, List<BusinessPartnerModel> bpdata) {
    return bpdata
        .map((bpdata) => DropdownMenuItem(
              value: bpdata.id,
              child: Text(
                bpdata.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: pureblackTheme),
              ),
              onTap: () async {
                await loadBPLocation(bpdata.id);
              },
            ))
        .toList();
  }

  List<DropdownMenuItem> _buildStatus(
      BuildContext context, List<WOStatusModel> wostatus) {
    issave = true;
    return wostatus
        .map((wostatus) => DropdownMenuItem(
              value: wostatus.value,
              child: Text(
                wostatus.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: pureblackTheme),
              ),
              onTap: () {},
            ))
        .toList();
  }

  List<DropdownMenuItem> _buildDocType(
      BuildContext context, List<DoctypeWOModel> doctypedata) {
    return doctypedata
        .map((doctypedata) => DropdownMenuItem(
              value: doctypedata.id,
              child: Text(
                doctypedata.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: pureblackTheme),
              ),
              onTap: () {
                if (doctypedata.name != null) {
                  // Context().wostatus = wostatus.value;
                } else {
                  // Context().wostatus = '';
                }
              },
            ))
        .toList();
  }

  List<DropdownMenuItem> _buildMeterType(
      BuildContext context, List<MeterTypeModel> metertypedata) {
    return metertypedata
        .map((metertypedata) => DropdownMenuItem(
              value: metertypedata.id,
              child: Text(
                metertypedata.meterType.identifier!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: pureblackTheme),
              ),
              onTap: () {},
            ))
        .toList();
  }
}
