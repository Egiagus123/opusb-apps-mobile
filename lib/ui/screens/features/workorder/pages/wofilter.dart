// ignore_for_file: unnecessary_null_comparison

import 'package:apps_mobile/business_logic/cubit/woservice_cubit.dart';
import 'package:apps_mobile/business_logic/models/bplocation.dart';
import 'package:apps_mobile/business_logic/models/businesspartner.dart';
import 'package:apps_mobile/business_logic/models/equipment_model.dart';
import 'package:apps_mobile/business_logic/models/priority.dart';
import 'package:apps_mobile/business_logic/models/woservice_model.dart';
import 'package:apps_mobile/business_logic/models/wostatus.dart';
import 'package:apps_mobile/business_logic/scanbarcode/ScanPage.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/ui/components/eam_app_bar.dart';
import 'package:apps_mobile/ui/components/fields/field_date_time_picker.dart';
import 'package:apps_mobile/ui/components/fields/field_dropdown.dart';
import 'package:apps_mobile/ui/components/fields/field_text.dart';
import 'package:apps_mobile/ui/screens/features/workorder/pages/workorder.dart';
import 'package:apps_mobile/ui/themes/design/design_theme.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:apps_mobile/widgets/loading_indicator.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class WOFilter extends StatefulWidget {
  const WOFilter({Key? key, this.setListWO, this.listWO}) : super(key: key);
  final void Function(List<WOServiceModel> listWOFiltered)? setListWO;
  final List<WOServiceModel>? listWO;
  @override
  _WOServiceState createState() {
    return _WOServiceState();
  }
}

class _WOServiceState extends State<WOFilter> {
  // Controllers for text fields
  TextEditingController _documentNoController = TextEditingController();
  TextEditingController _equipmentController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _locationToController = TextEditingController();

// Lists for different models
  List<WOStatusModel> status = [];
  List<PriorityModel> priority = [];
  List<BusinessPartnerModel> bpartner = [];
  List<BPLocationModel> bplocation = [];
  List<EquipmentModel> equipment = [];

// Selected models for form data
  BPLocationModel? location;
  late WOStatusModel wostatus;
  PriorityModel? prioritydata;
  BusinessPartnerModel? bpdata;
  EquipmentModel? equipmentdata;

// String data for form fields
  String equipmentdatanew = "";
  String locationdate = "";
  String wostatusdata = "";
  String prioritydatanew = "";
  String bpdatanew = "";
  String startdate = "";
  String enddate = "";

// Cubit for handling state changes
  WOServiceCubit? woServiceCubit;

// Flag for selection state
  bool isSelected = false;

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
    _equipmentController.dispose();

    super.dispose();
  }

  Future<String> loadEquipment() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit!.getEquipment();
    return 'success';
  }

  Future<String> loadwostatus() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit!.getWOStatus();
    return 'success';
  }

  Future<String> loadPriority() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit!.getPriority();
    return 'success';
  }

  Future<String> loadBparner() async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit!.getBPpartner();
    return 'success';
  }

  Future<String> loadBPLocation(int bpid) async {
    woServiceCubit = BlocProvider.of<WOServiceCubit>(context);
    await woServiceCubit!.getBPLocation(bpid);
    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // top: false,
      bottom: false,
      child: Scaffold(
        appBar: EamAppBar(
          title: 'Filter Work Order',
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<WOServiceCubit, WOServiceState>(
            listener: (context, state) {
              if (state is WOStatusSuccess) {
                status = state.wostatus;
                wostatus = status!.first;
              } else if (state is PrioritySuccess) {
                priority = state.priority;
              } else if (state is BPartnerSuccess) {
                bpartner = state.bpartner;
              } else if (state is BPLocationSuccess) {
                bplocation = state.bplocation;
              } else if (state is EquipmentSuccess) {
                equipment = state.equipment;
              }
            },
            builder: (context, state) {
              if (state is WOServiceLoadInProgress) {
                return LoadingIndicator();
              }

              print("status $status");
              print("priority $priority");
              print("bp $bpartner");
              print("bplocation $bplocation");
              print("equipement $equipment");

              // Hanya lanjut bangun UI jika semua data penting sudah tersedia
              if (status.isNotEmpty &&
                  priority.isNotEmpty &&
                  (bpartner.isNotEmpty ||
                      bplocation.isNotEmpty ||
                      equipment.isNotEmpty)) {
                return buildPage2(); // <- dijamin aman di sini
              }

              // Sementara, tampilkan indikator loading
              return LoadingIndicator();
            },
          ),
        ),
      ),
    );
  }

  Widget buildPage2() {
    // final validInitialValue = status!.contains(wostatus!) ? wostatus! : null;

    final space = SizedBox(height: 20);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildStartAndEndDate(),
            space,
            FieldDropdown<WOStatusModel>(
              title: 'Status',
              initialValue: wostatus,
              // wostatus ?? WOStatusModel(id: 0, name: '', value: ''),

              items: status,
              itemTextBuilder: (item) => item.name,
              onChanged: (value) {
                setState(() {
                  wostatus = value!;
                });
              },
              errorText: '',
            ),
            space,
            FieldDropdown<PriorityModel>(
              title: 'Priority',
              initialValue: prioritydata,
              items: priority,
              itemTextBuilder: (item) => item.name,
              onChanged: (value) {
                setState(() {
                  prioritydata = value!;
                });
              },
              errorText: '',
            ),
            space,
            FieldDropdown<BusinessPartnerModel>(
              title: 'Customer',
              initialValue: bpdata,
              items: bpartner,
              itemTextBuilder: (item) => item.name,
              onChanged: (value) {
                loadBPLocation(value!.id);
                setState(() {
                  location;
                  bpdata = value!;
                });
              },
              errorText: '',
            ),
            space,
            FieldDropdown<BPLocationModel>(
              title: 'Location',
              initialValue: location,
              items: bplocation,
              itemTextBuilder: (item) => item.name,
              onChanged: (value) {
                loadBPLocation(value!.id);
                setState(() {
                  location = value;
                });
              },
              errorText: '',
            ),
            space,
            // _buildUnitNoField(),
            space,
            FieldText(
              title: 'Equipment',
              controller: _equipmentController,
            ),
            space,
            SmallButton(
              text: 'Search',
              onPressed: () {
                // Why do we push? why don't use pop?
                // push a new route that similiar with previous screen is a waste of resources.
                // Please read this article for reference:
                // https://docs.flutter.dev/cookbook/navigation/returning-data
                // Navigator.push(
                //   context,
                //   new MaterialPageRoute(
                //     builder: (context) => BlocProvider<WOServiceCubit>(
                //       create: (BuildContext context) => WOServiceCubit(),
                //       child: WorkOrder(),
                //     ),
                //   ),
                // );
                print(
                    '_documentNoController >>> ${_documentNoController.text}');
                setState(() {
                  if (wostatus == null &&
                      prioritydata == null &&
                      bpdata == null &&
                      _equipmentController.text.isEmpty &&
                      location == null &&
                      _documentNoController.text.isEmpty &&
                      Context().startdate == null &&
                      Context().enddate == null) {
                    widget.setListWO!(Context().finalListWO);
                  } else {
                    setState(() {
                      List<WOServiceModel> tempListWO =
                          widget.listWO!.where((element) {
                        bool woStatus = wostatus == null
                            ? false
                            : element.wOStatus.id.toString().toUpperCase() ==
                                wostatus.value.toString().toUpperCase();
                        bool woPriority = prioritydata == null
                            ? false
                            : element.priorityRule.id.toUpperCase() ==
                                (prioritydata!.value.toUpperCase());
                        bool woBpartnerId = bpdata == null
                            ? false
                            : element.bpartnerid.id == bpdata!.id;
                        bool woBpartnerLocationId = location == null
                            ? false
                            : element.bparnertlocation.id == location!.id;
                        bool woEquipmentNo = _documentNoController.text.isEmpty
                            ? false
                            : element.bhpinstallbaseid.identifier!
                                .toUpperCase()
                                .contains(
                                    _documentNoController.text.toUpperCase());
                        bool woBhpInstallBaseId = _equipmentController
                                .text.isEmpty
                            ? false
                            : element.bhpinstallbaseid.identifier!
                                .toUpperCase()
                                .contains(
                                    _equipmentController.text.toUpperCase());
                        return woStatus ||
                            woPriority ||
                            woBhpInstallBaseId ||
                            woBpartnerLocationId ||
                            woEquipmentNo ||
                            woBpartnerId;
                      }).toList();
                      tempListWO = tempListWO.length == 0
                          ? itemsBetweenDates(
                              dates: Context().finalListWO,
                              items: Context().finalListWO,
                              start: Context().startdate!,
                              end: Context().enddate!)
                          : itemsBetweenDates(
                              dates: tempListWO,
                              items: tempListWO,
                              start: Context().startdate!,
                              end: Context().enddate!);
                      widget.setListWO!(tempListWO);
                    });
                  }
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<WOServiceModel> itemsBetweenDates({
    List<WOServiceModel>? dates,
    List<WOServiceModel>? items,
    DateTime? start,
    DateTime? end,
  }) {
    assert(dates!.length == items!.length);
    DateFormat dateFormat = DateFormat("MM/dd/yyyy");
    var output = <WOServiceModel>[];
    setState(() {
      for (var i = 0; i < dates!.length; i += 1) {
        String tempstartDate = dates[i].startDate;
        String tempendDate = dates[i].endDate;
        DateTime inputstart = dateFormat.parse(tempstartDate);
        DateTime inputend = dateFormat.parse(tempendDate);
        if (start != null && end != null) {
          if (inputstart.compareTo(start) >= 0 &&
              inputend.compareTo(end) <= 0) {
            output.add(items![i]);
          }
        } else if (start != null && end == null) {
          if (inputstart.compareTo(start) >= 0) {
            output.add(items![i]);
          }
        } else if (start == null && end != null) {
          if (inputstart.compareTo(end) <= 0) {
            output.add(items![i]);
          }
        } else if (start == null && end == null) {
          output.add(items![i]);
        }
      }
    });
    return output;
  }

  var equipmentdoc;
  Widget _buildUnitNoField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 254,
          child: FieldText(
            title: 'Unit No',
            controller: _documentNoController,
          ),
        ),
        SizedBox(width: 20),
        Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(
            bottom: 5,
          ),
          child: InkWell(
            splashColor: DesignTheme.of(context)!.color.bluePressed,
            onTap: () async {
              // Gunakan scanBarcode(context) untuk pemindaian barcode
              String? barcode = await scanBarcode(
                  context); // Menggunakan scanBarcode(context)

              // Cek apakah pemindaian barcode berhasil
              if (barcode != 'Cancelled') {
                // Pastikan hasil pemindaian bukan 'Cancelled'
                setState(() {
                  _documentNoController = TextEditingController(text: barcode);
                  FocusScope.of(context).unfocus();
                  equipmentdoc = barcode;
                });
              }
            },
            child: Icon(
              Icons.qr_code_scanner_outlined,
              size: 45,
              color: DesignTheme.of(context)!.color.blue1,
            ),
          ),
        ),
      ],
    );
  }

  Row _buildStartAndEndDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: FieldDateTimePicker(
            title: 'Start Date',
            initialDate: Context().startdate,
            validator: (date) =>
                (date?.day ?? 0) == 1 ? 'Please not the first day' : null,
            onSelected: (DateTime value) {
              print(value);
              setState(() {
                if (value != null) {
                  // Use shared cubit/bloc/notifier between previous and this screen.
                  // Or can you use push result to get the filter value
                  // ```dart
                  // final result = await Navigator.of(context).push(route);
                  // ```
                  // Managing it in a static var/class
                  // will make the logic more complex and hard to test
                  Context().startdate = value;
                } else {
                  Context().startdate = null;
                }
              });
            },
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: FieldDateTimePicker(
            title: 'End Date',
            initialDate: Context().enddate,
            startDate: Context().startdate,
            validator: (date) =>
                (date?.day ?? 0) == 1 ? 'Please not the first day' : null,
            onSelected: (DateTime value) {
              print(value);
              setState(() {
                if (value != null) {
                  Context().enddate = value;
                } else {
                  Context().enddate = null;
                }
              });
            },
          ),
        ),
      ],
    );
  }
}

class SmallButton extends StatelessWidget {
  const SmallButton({
    Key? key,
    this.text,
    this.onPressed,
  }) : super(key: key);

  final String? text;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size.zero),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 28,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        side: MaterialStateProperty.all(BorderSide.none),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return Color(0xffC6C2C2);
          }
          if (states.contains(MaterialState.pressed)) {
            return DesignTheme.of(context)!.color.bluePressed;
          }
          return DesignTheme.of(context)!.color.blue1;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return Color(0xff3C3737);
          }
          return DesignTheme.of(context)!.color.white;
        }),
        textStyle: MaterialStateProperty.all(
          DesignTheme.of(context)!.textStyle.paragraph1Regular,
        ),
        elevation: MaterialStateProperty.resolveWith((states) => 4),
      ),
      child: Text(text!),
    );
  }
}
