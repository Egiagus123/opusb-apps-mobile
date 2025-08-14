// ignore_for_file: unnecessary_null_comparison

import 'package:date_field/date_field.dart';
import 'package:apps_mobile/business_logic/cubit/woservice_cubit.dart';
import 'package:apps_mobile/business_logic/models/bplocation.dart';
import 'package:apps_mobile/business_logic/models/businesspartner.dart';
import 'package:apps_mobile/business_logic/models/doctypewo.dart';
import 'package:apps_mobile/business_logic/models/employeegroup.dart';
import 'package:apps_mobile/business_logic/models/equipment_model.dart';
import 'package:apps_mobile/business_logic/models/priority.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/models/savewoservice_model.dart';
import 'package:apps_mobile/business_logic/models/woservice_model.dart';
import 'package:apps_mobile/business_logic/models/wostatus.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/ui/screens/features/workorder/pages/workorder.dart';
import 'package:apps_mobile/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WOSaveHeader extends StatefulWidget {
  @override
  _WOSaveHeaderState createState() {
    return _WOSaveHeaderState();
  }
}

class _WOSaveHeaderState extends State<WOSaveHeader> {
  TextEditingController _documentNoController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _locationToController = TextEditingController();

  TextEditingController description = TextEditingController();
  List<WOStatusModel> status = [];
  List<PriorityModel> priority = [];
  List<BusinessPartnerModel> bpartner = [];
  List<BusinessPartnerModel> bpartnerdetail = [];
  List<BPLocationModel> bplocation = [];
  late List<WOServiceModel> woservicemodel;
  late List<DoctypeWOModel> doctypemodel;
  late List<EmployeeGroupModel> employeegroup;
  late List<EquipmentModel> equipment;
  var location;
  var wostatus;
  var prioritydata;
  var bpdata;
  var employeegroupdata;
  var equipmentdata;
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
    super.dispose();
  }

  Future<String> loadwostatus() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit.getWOStatus();
    return 'success';
  }

  Future<String> loadPriority() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit.getPriority();
    return 'success';
  }

  Future<String> loadBparner() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit.getBPpartner();
    return 'success';
  }

  Future<String> loadBPLocation(int bpid) async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit.getBPLocation(bpid);
    return 'success';
  }

  Future<String> loadDoctype() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit.getDoctype();
    return 'success';
  }

  savewoservice(data) async {
    await BlocProvider.of<WOServiceCubit>(context).savewoservice(data);
  }

  Future<String> loadEmployeeGroup() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit.getEmployeeGroup();
    return 'success';
  }

  Future<String> loadEquipment() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit.getEquipment();
    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ),
            title: Text(
              'Work Order',
              style: TextStyle(
                  fontFamily: 'Oswald',
                  letterSpacing: 1,
                  color: purewhiteTheme),
            ),
            bottom: new TabBar(
              labelColor: purewhiteTheme,
              tabs: <Widget>[
                new Tab(
                  text: 'Work Order',
                ),
                new Tab(
                  text: 'Status Update',
                ),
                new Tab(
                  text: 'Notes',
                ),
              ],
            ),
          ),
          backgroundColor: Colors.grey[200],
          body: BlocConsumer<WOServiceCubit, WOServiceState>(
            builder: (context, state) {
              return tabBar(woservicemodel);
            },
            listener: (context, state) {},
          )),
    );
  }

  TextEditingController controller = new TextEditingController();
  Widget tabBar(List<WOServiceModel> woservice) {
    return TabBarView(
      children: <Widget>[
        new Scaffold(
          backgroundColor: Colors.grey[200],
          body: BlocConsumer<WOServiceCubit, WOServiceState>(
            builder: (context, state) {
              if (state is WOStatusSuccess) {
                status = state.wostatus;
                // You can call tabBar() if needed here.
              }
              if (state is PrioritySuccess) {
                priority = state.priority;
                return LoadingIndicator(); // Return loading when priority state changes
              }
              if (state is BPartnerSuccess) {
                bpartner = state.bpartner;
                bpartnerdetail = bpartner;
              }
              if (state is DoctypeSuccess) {
                doctypemodel = state.doctype;
                return LoadingIndicator(); // Return loading when doc type state changes
              }
              if (state is EmployeeGroupSuccess) {
                employeegroup = state.employeegroup;
                return LoadingIndicator(); // Return loading when employee group state changes
              }
              if (state is BPLocationSuccess) {
                bplocation = state.bplocation;
              }
              if (state is EquipmentSuccess) {
                equipment = state.equipment;
                return LoadingIndicator(); // Return loading when equipment state changes
              }
              if (state is SaveWOServiceSuccess) {
                return buildPageWOStatus(); // Return status page on success
              }
              // Default condition to return a page if all conditions are met
              if (priority.isNotEmpty &&
                  bpartner.isNotEmpty &&
                  doctypemodel.isNotEmpty &&
                  employeegroup.isNotEmpty &&
                  equipment.isNotEmpty &&
                  bplocation.isEmpty) {
                return buildPageWO(); // Show page if bplocation is empty
              }
              if (priority.isNotEmpty &&
                  bpartner.isNotEmpty &&
                  doctypemodel.isNotEmpty &&
                  employeegroup.isNotEmpty &&
                  equipment.isNotEmpty &&
                  bplocation.isNotEmpty) {
                return buildPageWO(); // Show page if bplocation is not empty
              }

              // Add a default return widget to avoid returning null
              return Center(
                  child:
                      CircularProgressIndicator()); // Default fallback widget
            },
            listener: (context, state) {},
          ),
        ),
        new Scaffold(
          backgroundColor: Colors.grey[200],
          body: BlocConsumer<WOServiceCubit, WOServiceState>(
            builder: (context, state) {
              if (state is WOStatusSuccess) {
                status = state.wostatus;
              }
              // if (state is SaveWOServiceSuccess) {
              //   tabBar(woservice);
              // }

              return buildPageWOStatus();
            },
            listener: (context, state) {},
          ),
        ),
        new Scaffold(
          body: ListView(
            children: [
              Card(
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Column(
                      children: [
                        ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              'News Notes',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: TextField(
                              controller: description,
                              // hint: Text('Choose'),
                              onChanged: (changedValue) {
                                setState(() {
                                  setState(() {
                                    description.text = changedValue;
                                  });
                                  // wostatus = changedValue;
                                });
                              },
                            )),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => BlocProvider<WOServiceCubit>(
                                create: (BuildContext context) =>
                                    WOServiceCubit(),
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
            ],
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

  Widget buildPageWO() {
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
                    'Work Order Description',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: TextField(
                    controller: description,
                    // hint: Text('Choose'),
                    onChanged: (changedValue) {
                      setState(() {
                        setState(() {
                          description.text = changedValue;
                        });
                        wostatus = changedValue;
                      });
                    },
                  )),
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
                      subtitle: DropdownButtonFormField(
                        isExpanded: true,
                        value: doctypedata,
                        items: _buildDocType(context, doctypemodel),
                        // hint: Text('Choose'),
                        onChanged: (changedValue) {
                          setState(() {
                            doctypedata = changedValue;
                          });
                        },
                      ))
                  : SizedBox(
                      height: 1,
                    ),
              SizedBox(
                height: 10,
              ),
              equipment.isNotEmpty
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
                      subtitle: DropdownButtonFormField(
                        isExpanded: true,
                        value: equipmentdata,
                        items: _buildequipment(context, equipment),
                        // hint: Text('Choose'),
                        onChanged: (changedValue) {
                          setState(() {
                            equipmentdata = changedValue;
                          });
                        },
                      ))
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
                  subtitle: DropdownButtonFormField(
                    isExpanded: true,
                    value: bpdata,
                    items: _buildBPartner(context, bpartner),
                    // hint: Text('Choose'),
                    onChanged: (changedValue) {
                      setState(() {
                        bpdata = changedValue;
                      });
                    },
                  )),
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
                subtitle: DropdownButtonFormField(
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
                      subtitle: DropdownButtonFormField(
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
                  subtitle: DropdownButtonFormField(
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
                      });
                    },
                  )),
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
                      startdate;
                    }
                  },
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
            onPressed: () async {
              SaveWOServiceModel datawoservice = SaveWOServiceModel(
                description: description.text,
                priorityRule: prioritydatanew,
                startDate: startdate,
                endDate: enddate,
                cBPartnerID: Reference(id: bpdata),
                cDoctypeid: Reference(id: doctypedata),
                bhpinstallbaseid: Reference(id: equipmentdata),
                bplocationid: Reference(id: location),
                employeegroupid: Reference(id: employeegroupdata),
              );

              // ignore: avoid_print
              print(datawoservice);
              savewoservice(datawoservice);

              await loadwostatus();
            },
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
    return equipmentdata
        .map((equipmentdata) => DropdownMenuItem(
              value: equipmentdata.id,
              child: Text(
                equipmentdata.documentNo,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: pureblackTheme),
              ),
              onTap: () async {
                if (equipmentdata.id > 0) {
                  // Context().bpwo = bpdata.id;
                } else {
                  // Context().bpwo = 0;
                }
              },
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
              onTap: () async {
                if (employeegroup.id > 0) {
                  // Context().bpwo = bpdata.id;
                } else {
                  // Context().bpwo = 0;
                }
              },
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
            onTap: () {
              if (location.id > 0) {
                Context().bplocationwo = location.id;
              } else {
                Context().bplocationwo = 0;
              }
            },
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
              onTap: () {
                if (prioritydata.value != null) {
                  Context().priority = prioritydata.value;
                  String jhjh = Context().priority;
                } else {
                  Context().priority = '';
                }
              },
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
                if (bpdata.id > 0) {
                  Context().bpwo = bpdata.id;
                } else {
                  Context().bpwo = 0;
                }
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
              onTap: () {
                if (wostatus.value != null) {
                  Context().wostatus = wostatus.value!;
                } else {
                  Context().wostatus = '';
                }
              },
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
