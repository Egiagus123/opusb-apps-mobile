// ignore_for_file: unused_local_variable, deprecated_member_use, unnecessary_new, prefer_const_constructors, sized_box_for_whitespace, unnecessary_this, avoid_unnecessary_containers, unnecessary_string_interpolations, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:apps_mobile/business_logic/cubit/woservice_cubit.dart';
import 'package:apps_mobile/business_logic/models/bplocation.dart';
import 'package:apps_mobile/business_logic/models/employeegroup.dart';
import 'package:apps_mobile/business_logic/models/equipment_model.dart';
import 'package:apps_mobile/business_logic/models/priority.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/ui/screens/features/workorderissue/productdetail.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:barcode_scan/barcode_scan.dart';
import 'package:date_field/date_field.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/ui/screens/features/workorder/pages/workorder.dart';
import 'package:intl/intl.dart';

class WorkOrderIssueDetailPage extends StatefulWidget {
  const WorkOrderIssueDetailPage({Key? key}) : super(key: key);

  @override
  WorkOrderIssueDetailPageState createState() =>
      WorkOrderIssueDetailPageState();
}

class WorkOrderIssueDetailPageState extends State<WorkOrderIssueDetailPage> {
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
              'WO Issue Detail',
              style: TextStyle(
                  fontFamily: 'Oswald',
                  letterSpacing: 1,
                  color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: body());
  }

  var itemswarehouse = [
    '',
    '  Bali Tower',
    '  Bali Tower 2',
  ];

  var itemslocator = [
    '',
    '  ACEH 1',
    '  ACEH 2',
  ];

  var itemsproduct = [
    '',
    '  FEEDHORN_FEEDHORN',
    '  KABEL LAN_KABEL LAN',
  ];

  var itemsproduct2 = [
    '',
    '  FEEDHORN_FEEDHORN',
    '  KABEL LAN_KABEL LAN',
  ];

  var itemsruler = [
    '',
    '  Each',
    '  Liter',
  ];

  String dropdownvaluelocator = '';
  String dropdownvaluewarehouse = '';

  String dropdownvalueproduct = '';
  String dropdownvalueproduct2 = '';
  String dropdownvalueruler = '';
  Widget body() {
    return ListView(children: [
      Container(
        color: purewhiteTheme,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 70),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 1),
                    Column(
                      children: [
                        Container(
                          width: 150,
                          child: Text(
                            'Warehouse',
                            style: OpusbTheme().latoTextStyle.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          width: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              // color: Color(0xffEAEAEA),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor)
                              // border: Border.all(color: bluepos)
                              ),
                          child: DropdownButton(
                            isExpanded: true,
                            value: dropdownvaluewarehouse,
                            items: itemswarehouse.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (changedValue) {
                              setState(() {
                                dropdownvaluewarehouse = changedValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        Container(
                          width: 165,
                          child: Text(
                            'Locator',
                            style: OpusbTheme().latoTextStyle.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          width: 160,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              // color: Color(0xffEAEAEA),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor)
                              // border: Border.all(color: bluepos)
                              ),
                          child: DropdownButton(
                            isExpanded: true,
                            value: dropdownvaluelocator,
                            items: itemslocator.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (changedValue) {
                              setState(() {
                                dropdownvaluelocator = changedValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailPage(product: "MODEM", qty: "1"),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      Container(
                        width: 430,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: grayField,
                          border:
                              Border.all(color: Color(0xff959798), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/cart-4.png',
                                          // scale: 25,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 260,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              // color: Color(0xffEAEAEA),
                                              border: Border.all(
                                                  color: Color(0xFFD9D9D9))
                                              // border: Border.all(color: bluepos)
                                              ),
                                          child: DropdownButton(
                                            isExpanded: true,
                                            value: dropdownvalueproduct,
                                            items: itemsproduct
                                                .map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            onChanged: (changedValue) {
                                              setState(() {
                                                dropdownvalueproduct =
                                                    changedValue!;
                                              });
                                            },
                                          ),
                                        ),
                                        // Text(
                                        //   "MODEM",
                                        //   style: TextStyle(
                                        //       fontSize: 15,
                                        //       fontFamily: 'Lato',
                                        //       fontWeight: FontWeight.bold,
                                        //       color: const Color(0xff959798)),
                                        // ),
                                        // SizedBox(
                                        //   width: 192,
                                        // ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Container(
                                      width: 310,
                                      child: Divider(
                                        thickness: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/Ruler.png',
                                          // scale: 25,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 260,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              // color: Color(0xffEAEAEA),
                                              border: Border.all(
                                                  color: Color(0xFFD9D9D9))
                                              // border: Border.all(color: bluepos)
                                              ),
                                          child: DropdownButton(
                                            isExpanded: true,
                                            value: dropdownvalueruler,
                                            items:
                                                itemsruler.map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            onChanged: (changedValue) {
                                              setState(() {
                                                dropdownvalueruler =
                                                    changedValue!;
                                              });
                                            },
                                          ),
                                        ),
                                        // Text(
                                        //   "MODEM",
                                        //   style: TextStyle(
                                        //       fontSize: 15,
                                        //       fontFamily: 'Lato',
                                        //       fontWeight: FontWeight.bold,
                                        //       color: const Color(0xff959798)),
                                        // ),
                                        // SizedBox(
                                        //   width: 192,
                                        // ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/Calculator.png',
                                          // scale: 25,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 260,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              // color: Color(0xffEAEAEA),
                                              border: Border.all(
                                                  color: Color(0xFFD9D9D9))
                                              // border: Border.all(color: bluepos)
                                              ),
                                          child: TextFormField(
                                            maxLines: 5,
                                            decoration: InputDecoration(
                                                hintText: '  1',
                                                border: InputBorder.none),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            // hint: Text('Choose'),
                                            onChanged: (changedValue) {
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 250,
                          ),
                          Text(
                            "Reset",
                            style: TextStyle(color: blueTheme, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailPage(product: "MODEM", qty: "1"),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      Container(
                        width: 430,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: grayField,
                          border:
                              Border.all(color: Color(0xff959798), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/cart-4.png',
                                          // scale: 25,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 260,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              // color: Color(0xffEAEAEA),
                                              border: Border.all(
                                                  color: Color(0xFFD9D9D9))
                                              // border: Border.all(color: bluepos)
                                              ),
                                          child: DropdownButton(
                                            isExpanded: true,
                                            value: dropdownvalueproduct2,
                                            items: itemsproduct2
                                                .map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            onChanged: (changedValue) {
                                              setState(() {
                                                dropdownvalueproduct2 =
                                                    changedValue!;
                                              });
                                            },
                                          ),
                                        ),
                                        // Text(
                                        //   "MODEM",
                                        //   style: TextStyle(
                                        //       fontSize: 15,
                                        //       fontFamily: 'Lato',
                                        //       fontWeight: FontWeight.bold,
                                        //       color: const Color(0xff959798)),
                                        // ),
                                        // SizedBox(
                                        //   width: 192,
                                        // ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Container(
                                      width: 310,
                                      child: Divider(
                                        thickness: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/Ruler.png',
                                          // scale: 25,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 260,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              // color: Color(0xffEAEAEA),
                                              border: Border.all(
                                                  color: Color(0xFFD9D9D9))
                                              // border: Border.all(color: bluepos)
                                              ),
                                          child: DropdownButton(
                                            isExpanded: true,
                                            value: dropdownvalueruler,
                                            items:
                                                itemsruler.map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            onChanged: (changedValue) {
                                              setState(() {
                                                dropdownvalueruler =
                                                    changedValue!;
                                              });
                                            },
                                          ),
                                        ),
                                        // Text(
                                        //   "MODEM",
                                        //   style: TextStyle(
                                        //       fontSize: 15,
                                        //       fontFamily: 'Lato',
                                        //       fontWeight: FontWeight.bold,
                                        //       color: const Color(0xff959798)),
                                        // ),
                                        // SizedBox(
                                        //   width: 192,
                                        // ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/Calculator.png',
                                          // scale: 25,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          height: 40,
                                          width: 260,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              // color: Color(0xffEAEAEA),
                                              border: Border.all(
                                                  color: Color(0xFFD9D9D9))
                                              // border: Border.all(color: bluepos)
                                              ),
                                          child: TextFormField(
                                            maxLines: 5,
                                            decoration: InputDecoration(
                                                hintText: '  1',
                                                border: InputBorder.none),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            // hint: Text('Choose'),
                                            onChanged: (changedValue) {
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 250,
                          ),
                          Text(
                            "Reset",
                            style: TextStyle(color: blueTheme, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 50,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  showMessage(context, "Success", "Success");
                },
                child: Text(
                  'Save',
                  style: TextStyle(fontFamily: 'Oswald', letterSpacing: 1),
                ),
                color: Theme.of(context).primaryColor,
                disabledColor: Colors.grey[400],
                textColor: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 50,
          ),
        ],
      ),
    ]);
  }

  AlertDialog showMessage(BuildContext context, String title, String message) {
    return AlertDialog(title: Text(title), content: Text(message), actions: [
      TextButton(
        child: const Text("Close"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
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
            onPressed: () => showMessage(context, "Success", "Success"),
            // Navigator.push(
            //   context,
            //   new MaterialPageRoute(
            //     builder: (context) => BlocProvider<WOServiceCubit>(
            //       create: (BuildContext context) => WOServiceCubit(),
            //       child: WorkOrder(),
            //     ),
            //   ),
            // ),
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
