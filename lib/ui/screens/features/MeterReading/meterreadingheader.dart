// ignore_for_file: unused_local_variable, deprecated_member_use, unnecessary_new, prefer_const_constructors, sized_box_for_whitespace, unnecessary_this, avoid_unnecessary_containers, unnecessary_string_interpolations, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:apps_mobile/business_logic/cubit/woservice_cubit.dart';
import 'package:apps_mobile/business_logic/models/bplocation.dart';
import 'package:apps_mobile/business_logic/models/businesspartner.dart';
import 'package:apps_mobile/business_logic/models/currentdisplaymeter.dart';
import 'package:apps_mobile/business_logic/models/doctypewo.dart';
import 'package:apps_mobile/business_logic/models/employeegroup.dart';
import 'package:apps_mobile/business_logic/models/equipment_model.dart';
import 'package:apps_mobile/business_logic/models/meterdisplay.dart';
import 'package:apps_mobile/business_logic/models/meterreading.dart';
import 'package:apps_mobile/business_logic/models/priority.dart';
import 'package:apps_mobile/business_logic/models/recentitem.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/models/savemeterreading.dart';
import 'package:apps_mobile/business_logic/models/saverecentitemmr.dart';
import 'package:apps_mobile/business_logic/models/woservice_model.dart';
import 'package:apps_mobile/business_logic/models/wostatus.dart';
import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/features/core/base/widgets/loading_indicator.dart';
import 'package:apps_mobile/features/core/presentation/util/dialog_util.dart';
import 'package:apps_mobile/ui/screens/home/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_field/date_field.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:intl/intl.dart';

class MeterReadingPage extends StatefulWidget {
  const MeterReadingPage({Key? key}) : super(key: key);

  @override
  MeterReadingPageState createState() => MeterReadingPageState();
}

class _LeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Ambil angka saja, buang selain digit
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Tambahkan spasi di depan
    final formatted = ' $digitsOnly';

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class MeterReadingPageState extends State<MeterReadingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _documentNoController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _locationToController = TextEditingController();
  TextEditingController _sernoTextController = TextEditingController();
  var serno;

  TextEditingController netincrease = TextEditingController(
    text: ' ${NumberFormat("####", "id_ID").format(0)}',
  );
  TextEditingController newmeterreading = TextEditingController(
    text: ' ${NumberFormat("####", "id_ID").format(0)}',
  );
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
  List<CurrentDisplayMeter> currentDisplayMeter = [];
  List<MeterReading> meterreading = [];
  var location;
  var wostatus;
  var prioritydata;
  var bpdata;
  var employeegroupdata;
  var equipmentdata;
  var equipmentdatanew;
  var doctypedata;
  var metertypedata;

  double newmeterreadingdata = 0;
  double netincreasedata = 0;

  late String locationdate;
  late String wostatusdata;
  late String prioritydatanew;
  late String bpdatanew;
  late String startdate = "";
  late String enddate;
  late WOServiceCubit woServiceCubit;
  bool issave = false;
  var metertypedataselect;

  var isSelected = false;

  @override
  void initState() {
    super.initState();
    loadEquipment();
    loadMeterType();
    loadCurrentDisplayMeter();
  }

  @override
  void dispose() {
    _documentNoController.dispose();
    _locationController.dispose();
    _locationToController.dispose();
    _sernoTextController.dispose();
    super.dispose();
  }

  saverecentitems(data) async {
    await BlocProvider.of<WOServiceCubit>(context).saverecentitems(data);
  }

  getrecentitems() async {
    await BlocProvider.of<WOServiceCubit>(context).getRecentItem();
  }

  loadMeterReading() async {
    await BlocProvider.of<WOServiceCubit>(context).getMeterReading();
  }

  loadCurrentDisplayMeter() async {
    await BlocProvider.of<WOServiceCubit>(context).getCurrentDisplayMeter();
  }

  loadMeterType() async {
    await BlocProvider.of<WOServiceCubit>(context).getMeterType();
  }

  saveMeterReading(data) async {
    await BlocProvider.of<WOServiceCubit>(context).saveMeterReading(data);
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
              setState(() {
                Context().recentitem = recentitemdata;
              });
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeBody(),
                  ));
            }));
  }

  List<RecentItem> recentitemdata = [];

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
            'Meter Reading',
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
          if (state is EquipmentSuccess) {
            equipment = state.equipment;
            print("equipment =$equipment");
          } else if (state is MeterTypeSuccess) {
            metertype = state.metertype;
            print("metertype =$metertype");
          } else if (state is CurrentDisplayMeterSuccess) {
            currentDisplayMeter = state.currentDisplayMeter;
            print("currentDisplayMeter =$currentDisplayMeter");
          } else if (state is SaveMeterReadingSuccess) {
            print("showsuccess");
            loadMeterReading();
          } else if (state is MeterReadingSuccess) {
            print("meterreading showsuccess");

            meterreading = state.mreading;

            SaveRecentItemMR data = SaveRecentItemMR(
              cDoctypeid: Reference(id: meterreading.first.cDoctypeid.id),
              name: "Meter Reading",
              bHPmeterreadingID: Reference(id: meterreading.first.id),
            );

            saverecentitems(data);
          } else if (state is SaveRecentItemsSuccess) {
            print("recenitem showsuccess");
            getrecentitems();
          } else if (state is RecentItemsSuccess) {
            setState(() {
              Context().recentitem = state.recentitem;
              recentitemdata = state.recentitem;
            });

            print("getrecenitem showsuccess");

            showmsuccess(context, "Save Meter Reading Success");
          }
        },
      ),
    );
  }

  double currentqtydisplaymeter = 0;
  double currentqtylifetimemeter = 0;
  double currentqtylifetimemeterdataasli = 0;
  Widget body() {
    print("object55${netincrease.text}");
    return ListView(
      children: [
        Card(
          color: purewhiteTheme,
          elevation: 4, // Add shadow to give depth
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12), // Rounded corners for modern look
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                // Equipment Dropdown
                buildDropdownTile(
                  context,
                  'Equipment*',
                  serno != null ? serno : "Select Equipment",
                  equipmentdata,
                  _buildequipment(context, equipment),
                  (changedValue) {
                    setState(() {
                      equipmentdata = changedValue;
                      currentqtydisplaymeter = 0;
                      currentqtylifetimemeter = 0;

                      List<EquipmentModel> equipmentdatabaru =
                          equipment.where((i) => i.id == changedValue).toList();
                      int equipmentdataid = equipmentdatabaru.first.id;

                      if (equipmentdatabaru.isNotEmpty &&
                          metertypedataselect != null) {
                        for (var datacurrentdisplaymeter
                            in currentDisplayMeter) {
                          DateFormat dateFormat = DateFormat("MM/dd/yyyy");

                          var dateTimestartdate;
                          if (startdate != "") {
                            dateTimestartdate = dateFormat.parse(startdate);
                          } else {
                            dateTimestartdate = DateTime.now();
                          }

                          DateTime dateTimedocumentdate = dateFormat
                              .parse(datacurrentdisplaymeter.documentDate);

                          if (datacurrentdisplaymeter
                              .bhpMInstallBaseID.identifier!.isNotEmpty) {
                            if (equipmentdataid ==
                                    datacurrentdisplaymeter
                                        .bhpMInstallBaseID.id &&
                                metertypedataselect ==
                                    datacurrentdisplaymeter.meterType.id &&
                                dateTimestartdate != "" &&
                                (dateTimestartdate
                                        .isAfter(dateTimedocumentdate) ||
                                    dateTimestartdate ==
                                        dateTimedocumentdate)) {
                              currentqtydisplaymeter +=
                                  datacurrentdisplaymeter.qty;
                            }
                          }

                          if (datacurrentdisplaymeter
                              .bhpMInstallBaseID.identifier!.isNotEmpty) {
                            if (equipmentdataid ==
                                    datacurrentdisplaymeter
                                        .bhpMInstallBaseID.id &&
                                metertypedataselect ==
                                    datacurrentdisplaymeter.meterType.id &&
                                dateTimestartdate != "") {
                              currentqtylifetimemeter +=
                                  datacurrentdisplaymeter.qty;
                            }
                          }
                        }
                      }
                    });
                  },
                ),
                SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      )
                    ],
                  ),
                  subtitle: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Theme.of(context).primaryColor)),
                    child: DateTimeFormField(
                      initialValue: DateTime.now(),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        suffixIcon: Icon(
                          Icons.event_note,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.always,
                      validator: (e) => (e?.day ?? 0) == 1
                          ? 'Please not the first day'
                          : null,
                      onDateSelected: (DateTime value) {
                        print(value);
                        // if (value != null) {
                        DateFormat dateFormat = DateFormat("MM/dd/yyyy");
                        String startdatesdds = dateFormat.format(value);
                        startdate = startdatesdds;
                        // }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 12),

                // Meter Type Dropdown
                buildDropdownTile(
                  context,
                  'Meter Type',
                  metertypedataselect != null
                      ? metertypedataselect.toString()
                      : "Select Meter Type",
                  metertypedataselect,
                  _buildMeterType(context, metertype),
                  (changedValue) {
                    setState(() {
                      metertypedataselect = changedValue;

                      // equipmentdata = equi;
                      currentqtydisplaymeter = 0;
                      currentqtylifetimemeter = 0;

                      List<EquipmentModel> equipmentdatabaru = equipment
                          .where((i) => i.id == equipmentdata)
                          .toList();
                      int equipmentdataid = equipmentdatabaru.first.id;

                      if (equipmentdatabaru.isNotEmpty &&
                          metertypedataselect != null) {
                        for (var datacurrentdisplaymeter
                            in currentDisplayMeter) {
                          DateFormat dateFormat = DateFormat("MM/dd/yyyy");
                          var dateTimestartdate;
                          if (startdate != "") {
                            dateTimestartdate = dateFormat.parse(startdate);
                          } else {
                            dateTimestartdate = DateTime.now();
                          }

                          DateTime dateTimedocumentdate = dateFormat
                              .parse(datacurrentdisplaymeter.documentDate);

                          if (datacurrentdisplaymeter
                              .bhpMInstallBaseID.identifier!.isNotEmpty) {
                            if (equipmentdataid ==
                                    datacurrentdisplaymeter
                                        .bhpMInstallBaseID.id &&
                                metertypedataselect ==
                                    datacurrentdisplaymeter.meterType.id &&
                                dateTimestartdate != "" &&
                                (dateTimestartdate
                                        .isAfter(dateTimedocumentdate) ||
                                    dateTimestartdate ==
                                        dateTimedocumentdate)) {
                              currentqtydisplaymeter +=
                                  datacurrentdisplaymeter.qty;
                            }
                          }

                          if (datacurrentdisplaymeter
                              .bhpMInstallBaseID.identifier!.isNotEmpty) {
                            if (equipmentdataid ==
                                    datacurrentdisplaymeter
                                        .bhpMInstallBaseID.id &&
                                metertypedataselect ==
                                    datacurrentdisplaymeter.meterType.id &&
                                dateTimestartdate != "") {
                              currentqtylifetimemeter +=
                                  datacurrentdisplaymeter.qty;
                            }
                          }
                        }
                      }
                    });
                    // setState(() {
                    //   metertypedataselect = changedValue;
                    // });
                  },
                ),
                SizedBox(height: 12),

                // Display and Lifetime Meters
                buildMeterField(
                    'Current Display Meter', currentqtydisplaymeter, false),
                buildMeterField(
                    'Current Lifetime Meter', currentqtylifetimemeter, false),

                // Net Increase and New Meter Reading
                // buildMeterField('Net Increase', netincreasedata, true),
                // buildMeterField('New Meter Reading', newmeterreadingdata, true),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Net Increase',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      )
                    ],
                  ),
                  subtitle: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // color: Color(0xffEAEAEA),
                        color: int.parse(newmeterreading.text) == 0
                            ? Colors.white
                            : Color(0xffEAEAEA),
                        border:
                            Border.all(color: Theme.of(context).primaryColor)),
                    child: TextFormField(
                      controller: netincrease,
                      enabled:
                          int.parse(newmeterreading.text) == 0 ? true : false,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 12),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        _LeadingSpaceFormatter(), // Custom formatter di bawah
                      ],
                      onChanged: (changedValue) {
                        setState(() {
                          double datanet = 0;
                          if (changedValue != "") {
                            datanet = double.parse(changedValue);
                            netincreasedata = datanet;

                            newmeterreadingdata =
                                currentqtylifetimemeter + datanet;
                          } else {
                            netincreasedata = 0;
                            newmeterreadingdata = 0;
                          }
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Meter Reading',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      )
                    ],
                  ),
                  subtitle: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: int.parse(netincrease.text) == 0
                            ? Colors.white
                            : Color(0xffEAEAEA),
                        border:
                            Border.all(color: Theme.of(context).primaryColor)),
                    child:
                        // TextFormField(
                        //   enabled:
                        //       netincrease.text.isEmpty || netincrease.text == ""
                        //           ? true
                        //           : false,
                        //   controller: newmeterreading,
                        //   decoration: InputDecoration(
                        //       hintText:
                        //           '${'${NumberFormat("####", "id_ID").format(newmeterreadingdata).toString()}'}'),
                        //   keyboardType: TextInputType.number,
                        //   // hint: Text('Choose'),
                        //   onChanged: (changedValue) {
                        //     setState(() {
                        //       double datanewmeter = 0;
                        //       if (changedValue != "") {
                        //         datanewmeter = double.parse(changedValue);

                        //         currentqtylifetimemeter = datanewmeter;

                        //         netincreasedata = currentqtylifetimemeter +
                        //             currentqtydisplaymeter;
                        //       } else {
                        //         netincreasedata = 0;

                        //         currentqtylifetimemeter =
                        //             currentqtylifetimemeterdataasli;
                        //       }
                        //     });
                        //   },
                        // ),
                        TextFormField(
                      controller: newmeterreading,
                      enabled: int.parse(netincrease.text) == 0 ? true : false,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 12),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        _LeadingSpaceFormatter(), // Custom formatter di bawah
                      ],
                      onChanged: (changedValue) {
                        setState(
                          () {
                            double datanewmeter = 0;
                            if (changedValue != "") {
                              datanewmeter = double.parse(changedValue);

                              currentqtylifetimemeter = datanewmeter;

                              netincreasedata = currentqtylifetimemeter +
                                  currentqtydisplaymeter;
                            } else {
                              netincreasedata = 0;

                              currentqtylifetimemeter =
                                  currentqtylifetimemeterdataasli;
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),

                // Submit Button
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        SaveMeterReading datameterreading = SaveMeterReading(
                          adOrgID: Reference(id: Context().orgId),
                          qty: netincreasedata,
                          documentDate: startdate,
                          meterType: Reference(id: metertypedataselect),
                          cDoctypeid: Reference(id: 1001360),
                          bhpinstallbaseid: Reference(
                              id: _sernoTextController.text.isNotEmpty
                                  ? equipmentdatanew
                                  : equipmentdata),
                        );
                        print(datameterreading);
                        saveMeterReading(datameterreading);
                      },
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
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMeterField(String title, double value, bool enable) {
    // Fungsi untuk menambahkan spasi otomatis ke angka
    String formatWithSpacing(double val) {
      final intVal = val.toInt(); // Buat integer jika desimal tak diperlukan
      final str = intVal.toString();
      final buffer = StringBuffer();
      for (int i = 0; i < str.length; i++) {
        if (i != 0 && (str.length - i) % 3 == 0) {
          buffer.write(' ');
        }
        buffer.write(str[i]);
      }
      return buffer.toString();
    }

    final controller = TextEditingController(text: formatWithSpacing(value));

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
          ],
        ),
        subtitle: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xffEAEAEA),
            border: Border.all(color: Colors.white),
          ),
          child: TextFormField(
            controller: controller,
            enabled: enable,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ),
    );
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
                equipmentdata.serNo,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: pureblackTheme),
              ),
              onTap: () async {},
            ))
        .toList();
  }

  List<DropdownMenuItem> _buildMeterType(
      BuildContext context, List<MeterTypeModel> metertypedata) {
    return metertypedata
        .map((metertypedata) => DropdownMenuItem(
              value: metertypedata.meterType.id,
              child: Text(
                metertypedata.meterType.identifier!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: pureblackTheme),
              ),
              onTap: () {},
            ))
        .toList();
  }

  showmsuccess(BuildContext context, String message) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.grey,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: const EdgeInsets.only(top: 10.0),
      content: Container(
        width: 120.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(top: 4.0, bottom: 20.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0)),
              ),
              child: Center(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    Context().recentitem = recentitemdata;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Close',
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3,
            sigmaY: 3,
          ),
          child: alert,
        );
      },
    );
  }
}

Widget buildDropdownTile(
  BuildContext context,
  String label,
  String hintText,
  dynamic value,
  List<DropdownMenuItem<dynamic>> items,
  ValueChanged<dynamic> onChanged,
) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    title: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13, // Smaller font size
            fontWeight: FontWeight.bold,
            // color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(
          height: 7,
        )
      ],
    ),
    subtitle: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(2, 2),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
        ),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: 8, vertical: 3), // Reduced padding
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: value,
          items: items,
          hint: Text(
            hintText,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 12, // Smaller font size for hint text
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    ),
  );
}

// Reusable meter field for consistency
Widget buildMeterField(String title, double value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xffEAEAEA),
            border: Border.all(color: Colors.white)),
        child: TextFormField(
          enabled: false,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: NumberFormat("####", "id_ID").format(value).toString()),
          keyboardType: TextInputType.number,
        ),
      ),
    ),
  );
}
