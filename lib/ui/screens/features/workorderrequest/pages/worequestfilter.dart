import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/ui/screens/features/workorderrequest/pages/workorderrequest.dart';
import 'package:date_field/date_field.dart';
import 'package:apps_mobile/business_logic/cubit/woservice_cubit.dart';
import 'package:apps_mobile/business_logic/models/bplocation.dart';
import 'package:apps_mobile/business_logic/models/businesspartner.dart';
import 'package:apps_mobile/business_logic/models/equipment_model.dart';
import 'package:apps_mobile/business_logic/models/priority.dart';
import 'package:apps_mobile/business_logic/models/wostatus.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/ui/screens/features/workorder/pages/workorder.dart';
import 'package:apps_mobile/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WORequestFilter extends StatefulWidget {
  @override
  _WOServiceState createState() {
    return _WOServiceState();
  }
}

class _WOServiceState extends State<WORequestFilter> {
  TextEditingController _documentNoController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _locationToController = TextEditingController();

  List<WOStatusModel> status = [];
  List<PriorityModel> priority = [];
  List<BusinessPartnerModel> bpartner = [];
  List<BPLocationModel> bplocation = [];
  List<EquipmentModel> equipment = [];

  var location;
  var wostatus;
  var prioritydata;
  var bpdata;
  var equipmentdata;

  late String equipmentdatanew;
  late String locationdate;
  late String wostatusdata;
  late String prioritydatanew;
  late String bpdatanew;
  late String startdate;
  late String enddate;
  late WOServiceCubit woServiceCubit;

  var isSelected = false;
  @override
  void initState() {
    super.initState();
    loadwostatus();
    loadPriority();
    loadBparner();
    loadEquipment();
  }

  @override
  void dispose() {
    _documentNoController.dispose();
    _locationController.dispose();
    _locationToController.dispose();
    super.dispose();
  }

  Future<String> loadEquipment() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit.getEquipment();
    return 'success';
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
            'Filter Work Request',
            style: TextStyle(
                fontFamily: 'Oswald',
                letterSpacing: 1,
                color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: BlocConsumer<WOServiceCubit, WOServiceState>(
        builder: (context, state) {
          if (state is WOServiceLoadInProgress) {
            return LoadingIndicator();
          }
          return buildPage();
        },
        listener: (context, state) {
          if (state is WOStatusSuccess) {
            status = state.wostatus;
          } else if (state is PrioritySuccess) {
            priority = state.priority;
          } else if (state is BPartnerSuccess) {
            bpartner = state.bpartner;
          } else if (state is BPLocationSuccess) {
            bplocation = state.bplocation;
            // Context()
          } else if (state is EquipmentSuccess) {
            equipment = state.equipment;
            // return LoadingIndicator();
          }
        },
      ),
    );
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
    return wostatus
        .map((wostatus) => DropdownMenuItem(
              value: wostatus.value,
              child: Text(
                wostatus.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: pureblackTheme),
              ),
              onTap: () {
                if (wostatus.value != null) {
                  Context().wostatus = wostatus.value;
                } else {
                  Context().wostatus = '';
                }
              },
            ))
        .toList();
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
              onTap: () {
                if (equipmentdata.id > 0) {
                  Context().equipmentid = equipmentdata.id;
                } else {
                  Context().equipmentid = 0;
                }
              },
            ))
        .toList();
  }

  Widget buildPage() {
    return ListView(children: [
      Card(
        color: purewhiteTheme,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 100,
          ),
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
                            // color: Color(0xffEAEAEA),
                            border: Border.all(
                                color: Theme.of(context).primaryColor)
                            // border: Border.all(color: bluepos)
                            ),
                        child: DateTimeFormField(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black45),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            // border: InputBorder.none,
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
                              Context().startdate = value;
                            } else {
                              Context().startdate = null;
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
                          fontSize: 13,
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
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black45),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            // border: InputBorder.none,
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
                              Context().enddate = value;
                            } else {
                              Context().enddate = null;
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
                  'Status',
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
                      // color: Color(0xffEAEAEA),
                      border: Border.all(color: Theme.of(context).primaryColor)
                      // border: Border.all(color: bluepos)
                      ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      value: wostatus,
                      items: _buildStatus(context, status),
                      // hint: Text('Choose'),
                      onChanged: (changedValue) {
                        setState(() {
                          wostatus = changedValue;
                        });
                      },
                    ),
                  ),
                ),
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
                    fontSize: 13,
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
                      value: prioritydata,
                      items: _buildPriority(context, priority),
                      // hint: Text('Choose'),
                      onChanged: (changedValue) {
                        setState(() {
                          prioritydata = changedValue;
                        });
                      },
                    ),
                  ),
                ),
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
                    fontSize: 13,
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
              ListTile(
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
                  width: 100,
                  // height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: Color(0xffEAEAEA),
                      border: Border.all(color: Theme.of(context).primaryColor)
                      // border: Border.all(color: bluepos)
                      ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      value: location,
                      items: _buildLocation(context, bplocation),
                      // hint: Text('Choose'),
                      onChanged: (changedValue) {
                        setState(() {
                          bplocation = changedValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // equipment.isNotEmpty
              //     ?
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Equipment',
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
                      // color: Color(0xffEAEAEA),
                      border: Border.all(color: Theme.of(context).primaryColor)
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
              ),
              // : SizedBox(
              //     height: 1,
              //   ),
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
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => BlocProvider<WOServiceCubit>(
                        create: (BuildContext context) => WOServiceCubit(),
                        child: WorkOrderRequest()))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Search',
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
}
