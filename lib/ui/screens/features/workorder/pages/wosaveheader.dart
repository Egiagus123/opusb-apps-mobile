// ignore_for_file: unused_local_variable, deprecated_member_use, unnecessary_new, prefer_const_constructors, sized_box_for_whitespace, unnecessary_this, avoid_unnecessary_containers, unnecessary_string_interpolations, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:apps_mobile/business_logic/cubit/woservice_cubit.dart';
import 'package:apps_mobile/business_logic/models/bplocation.dart';
import 'package:apps_mobile/business_logic/models/businesspartner.dart';
import 'package:apps_mobile/business_logic/models/doctypewo.dart';
import 'package:apps_mobile/business_logic/models/employeegroup.dart';
import 'package:apps_mobile/business_logic/models/equipment_model.dart';
import 'package:apps_mobile/business_logic/models/priority.dart';
import 'package:apps_mobile/business_logic/models/woservice_model.dart';
import 'package:apps_mobile/business_logic/models/wostatus.dart';
import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/features/core/base/widgets/loading_indicator.dart';
import 'package:apps_mobile/ui/screens/features/workorder/form/workorder_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_field/date_field.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/models/savewoservice_model.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/ui/screens/features/workorder/pages/workorder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class WorkOrderSavePage extends StatefulWidget {
  const WorkOrderSavePage({Key? key}) : super(key: key);

  @override
  WorkOrderSavePageState createState() => WorkOrderSavePageState();
}

class WorkOrderSavePageState extends State<WorkOrderSavePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _documentNoController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _locationToController = TextEditingController();
  TextEditingController _sernoTextController = TextEditingController();
  late TextEditingController _selecteddate;
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
  var location;
  var wostatus;
  var prioritydata;
  var bpdata;
  var employeegroupdata;
  var equipmentdata;
  var equipmentdatanew;
  var doctypedata;

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
    loadPriority();
    loadBparner();
    loadDoctype();
    loadEmployeeGroup();
    loadEquipment();
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

  savewoservice(data) async {
    await BlocProvider.of<WOServiceCubit>(context).savewoservice(data);
  }

  loadEmployeeGroup() async {
    await BlocProvider.of<WOServiceCubit>(context).getEmployeeGroup();
  }

  loadEquipment() async {
    await BlocProvider.of<WOServiceCubit>(context).getEquipment();
  }

  int activeIndex = 0;
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
            'Create Work Order',
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
          } else if (state is SaveWOServiceSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkOrderForm(),
                  ));
            });
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
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Container(
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            // color: Color(0xffEAEAEA),
                            border: Border.all(
                                color: Theme.of(context).primaryColor)
                            // border: Border.all(color: bluepos)
                            ),
                        child: DateTimeFormField(
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.black45),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor)),
                            suffixIcon: Icon(Icons.event_note,
                                color: Theme.of(context).primaryColor),
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
                              startdate;
                            }
                          },
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
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Container(
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            // color: Color(0xffEAEAEA),
                            border: Border.all(
                                color: Theme.of(context).primaryColor)
                            // border: Border.all(color: bluepos)
                            ),
                        child: DateTimeFormField(
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.black45),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor)),
                            suffixIcon: Icon(Icons.event_note,
                                color: Theme.of(context).primaryColor),
                          ),
                          autovalidateMode: AutovalidateMode.always,
                          validator: (e) => (e?.day ?? 0) == 1
                              ? 'Please not the first day'
                              : null,
                          onDateSelected: (DateTime value) {
                            print(value);
                            if (value != null) {
                              DateFormat dateFormat = DateFormat(
                                  "MM/dd/yyyy"); // how you want it to be formatted
                              String enddatenew = dateFormat.format(value);
                              enddate = enddatenew;
                            } else {
                              enddate;
                            }
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
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Work Order Description',
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
                height: 10,
              ),
              doctypemodel.isNotEmpty
                  ? ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Document Type',
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
                            border: Border.all(
                                color: Theme.of(context).primaryColor)
                            // border: Border.all(color: bluepos)
                            ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // isExpanded: true,
                            value: doctypedata,
                            items: _buildDocType(context, doctypemodel),
                            // hint: Text('Choose'),
                            onChanged: (changedValue) {
                              setState(() {
                                doctypedata = changedValue;
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 1,
                    ),
              SizedBox(
                height: 10,
              ),
              equipment.isNotEmpty && _sernoTextController.text.isEmpty
                  ? ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Unit Number',
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
                            border: Border.all(
                                color: Theme.of(context).primaryColor)
                            // border: Border.all(color: bluepos)
                            ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            value: equipmentdata,
                            items: _buildequipment(context, equipment),
                            // hint: Text('Choose'),
                            onChanged: (changedValue) {
                              setState(() {
                                equipmentdata = changedValue;
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 1,
                    ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Customer',
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
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      value: bpdata,
                      items: _buildBPartner(context, bpartner),
                      // hint: Text('Choose'),
                      onChanged: (changedValue) {
                        setState(() {
                          bpdata = changedValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              equipmentdata == null
                  ? ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Serial No.',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Container(
                        width: 100,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            // color: Color(0xffEAEAEA),
                            border: Border.all(
                                color: Theme.of(context).primaryColor)
                            // border: Border.all(color: bluepos)
                            ),
                        child: TextField(
                          // enabled: equipmentdata == null ? true : false,
                          controller: _sernoTextController,
                          onChanged: (value) {
                            equipmentdatanew = equipment
                                .where(
                                    (i) => i.serNo == _sernoTextController.text)
                                .toList();

                            setState(() {
                              this.serno = value;
                            });
                          },
                          style: TextStyle(fontFamily: 'Montserrat'),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                          ),
                          textInputAction: TextInputAction.go,
                          onSubmitted: (value) {
                            List<EquipmentModel> equipmentdatabaru = equipment
                                .where((i) => i.serNo == value)
                                .toList();

                            equipmentdatanew = equipmentdatabaru.first.id;
                            setState(() {
                              serno = value;
                            });
                          },
                        ),
                      ),
                      trailing: equipmentdata == null
                          ? IconButton(
                              icon: Icon(Icons.qr_code_scanner,
                                  size: 40,
                                  color: Theme.of(context).primaryColor),
                              onPressed: () async {
                                String? serno = await scanBarcode(
                                    context); // Menggunakan scanBarcode(context)

                                if (serno != 'Cancelled') {
                                  // Pastikan hasil pemindaian bukan 'Cancelled'
                                  setState(() {
                                    _sernoTextController =
                                        TextEditingController(text: serno);
                                    FocusScope.of(context).unfocus();

                                    // Update nilai serno
                                    this.serno = serno;

                                    // Filter peralatan berdasarkan nomor seri yang dipindai
                                    List<EquipmentModel> equipmentdatabaru =
                                        equipment
                                            .where((i) => i.serNo == serno)
                                            .toList();

                                    // Jika ditemukan peralatan yang sesuai, ambil ID peralatan pertama
                                    if (equipmentdatabaru.isNotEmpty) {
                                      equipmentdatanew =
                                          equipmentdatabaru.first.id;
                                    }
                                  });
                                } else {
                                  // Menangani jika pemindaian dibatalkan atau gagal
                                  print('Scan was cancelled or failed');
                                }
                              },
                            )
                          : SizedBox(),
                    )
                  : SizedBox(
                      height: 10,
                    ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Location',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Container(
                  width: 100,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: Color(0xffEAEAEA),
                      border: Border.all(color: Theme.of(context).primaryColor)
                      // border: Border.all(color: bluepos)
                      ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      value: location,
                      items: _buildLocation(context, bplocation),
                      // hint: Text('Choose'),
                      onChanged: (changedValue) {
                        setState(() {
                          location = changedValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              employeegroup.isNotEmpty
                  ? ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        'Assign To',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Container(
                        width: 100,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            // color: Color(0xffEAEAEA),
                            border: Border.all(
                                color: Theme.of(context).primaryColor)
                            // border: Border.all(color: bluepos)
                            ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            value: employeegroupdata,
                            items: _buildempolyeegroup(context, employeegroup),
                            // hint: Text('Choose'),
                            onChanged: (changedValue) {
                              setState(() {
                                employeegroupdata = changedValue;
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 1,
                    ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Priority',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Container(
                  width: 100,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: Color(0xffEAEAEA),
                      border: Border.all(color: Theme.of(context).primaryColor)
                      // border: Border.all(color: bluepos)
                      ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      value: prioritydata,
                      items: _buildPriority(context, priority),
                      // hint: Text('Choose'),
                      onChanged: (changedValue) {
                        setState(() {
                          prioritydata = changedValue;

                          if (prioritydata == 'Urgent') {
                            prioritydatanew = '1';
                          } else if (prioritydata == 'High') {
                            prioritydatanew = '3';
                          } else if (prioritydata == 'Medium') {
                            prioritydatanew = '5';
                          } else if (prioritydata == 'Low') {
                            prioritydatanew = '7';
                          } else if (prioritydata == 'Minor') {
                            prioritydatanew = '9';
                          }
                          print(
                              'prioritydatanew adalah =$prioritydata :$prioritydatanew');
                        });
                      },
                    ),
                  ),
                ),
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
              padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 150),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              SaveWOServiceModel datawoservice = SaveWOServiceModel(
                description: description.text,
                priorityRule: prioritydata,
                startDate: startdate,
                endDate: enddate,
                cBPartnerID: Reference(id: bpdata),
                cDoctypeid: Reference(id: doctypedata),
                bhpinstallbaseid: Reference(
                    id: _sernoTextController.text.isNotEmpty
                        ? equipmentdatanew
                        : equipmentdata),
                bplocationid: Reference(id: location),
                employeegroupid: Reference(id: employeegroupdata),
              );

              // ignore: avoid_print
              print(datawoservice);
              savewoservice(datawoservice);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Submit'),
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
                wostatus.name!,
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
}
