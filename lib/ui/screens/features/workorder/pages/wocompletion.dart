// ignore_for_file: unused_local_variable, deprecated_member_use, unnecessary_new, prefer_const_constructors, sized_box_for_whitespace, unnecessary_this, avoid_unnecessary_containers, unnecessary_string_interpolations, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apps_mobile/business_logic/cubit/woservice_cubit.dart';
import 'package:apps_mobile/business_logic/models/bplocation.dart';
import 'package:apps_mobile/business_logic/models/employeegroup.dart';
import 'package:apps_mobile/business_logic/models/equipment_model.dart';
import 'package:apps_mobile/business_logic/models/priority.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_field/date_field.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/ui/screens/features/workorder/pages/workorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class WOCompletionPage extends StatefulWidget {
  var wono;

  WOCompletionPage({Key? key, this.wono}) : super(key: key);

  @override
  WOCompletionPageState createState() => WOCompletionPageState();
}

class WOCompletionPageState extends State<WOCompletionPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // TextEditingController _documentNoController = TextEditingController();
  // TextEditingController _locationController = TextEditingController();
  // TextEditingController _locationToController = TextEditingController();
  // TextEditingController _sernoTextController = TextEditingController();
  // TextEditingController _selecteddate;
  // var serno;
  var data;

  TextEditingController wonodata = TextEditingController();
  TextEditingController equipmentno = TextEditingController();
  TextEditingController description = TextEditingController();

  late File image;
  // var equipmentdatanew;
  // var doctypedata;

  // String locationdate;
  // String wostatusdata;
  // String prioritydatanew;
  // String bpdatanew;
  late String movementdate;

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

  Future pickImage() async {
    try {
      // Using the pickImage method instead of getImage
      final picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  final ImagePicker _picker = ImagePicker();

  getPermission() async {
    var _permissionStatus = await Permission.storage.status;
    var _cameraPermissionStatus = await Permission.camera.status;
    if (_permissionStatus != PermissionStatus.granted) {
      PermissionStatus permissionStatus = await Permission.storage.request();

      setState(() {
        _permissionStatus = permissionStatus;
      });
    }
    if (_cameraPermissionStatus != PermissionStatus.granted) {
      PermissionStatus permissionStatus = await Permission.camera.request();
      setState(() {
        _cameraPermissionStatus = permissionStatus;
      });
    }
  }

  var pickedFile;

  Future imageSelector(BuildContext context, pickerType, String data) async {
    switch (pickerType) {
      case "gallery":
        await getPermission();
        pickedFile = await _picker.pickImage(
            source: ImageSource.camera, imageQuality: 50);
        final attachment = File(pickedFile.path);
        int sizeInBytes = attachment.lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        print('============> SIZE : $sizeInMb');
        if (sizeInMb > 2) {
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //   content: Text('Maximum upload file size 2MB.'),
          //   backgroundColor: Colors.red,
          //   duration: Duration(seconds: 3),
          // ));
        } else {
          setState(() {
            if (attachment != '') {
              final bytes = attachment.readAsBytesSync();
              String img64 = base64Encode(bytes);
              // savePhoto(img64, data);

              Context().photo = img64;

              body();
            }
          });
        }

        break;
      case "camera":
        await getPermission();
        pickedFile = await _picker.pickImage(
            source: ImageSource.camera,
            preferredCameraDevice: CameraDevice.rear,
            imageQuality: 50);
        final attachment = File(pickedFile.path);
        int sizeInBytes = attachment.lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (sizeInMb > 2) {
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //   content: Text('Maximum upload file size 2MB.'),
          //   backgroundColor: Colors.red,
          //   duration: Duration(seconds: 3),
          // ));
        } else {
          setState(() {
            if (attachment != '') {
              final bytes = attachment.readAsBytesSync();
              String img64 = base64Encode(bytes);
              // savePhoto(img64, data);
              Context().photo = img64;
            }
          });
        }
    }
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
                      onTap: () {
                        setState(() {
                          Context().photo = null;
                        });
                        Navigator.pop(context, true);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            title: Text(
              'WO Completion',
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

  Widget photoBox(BuildContext context, String data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: MediaQuery.of(context).size.height * 0.2,
      child: Image.file(
        File(data),
        fit: BoxFit.cover, // Adjust fit as per your design
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return const Center(child: Text('This image type is not supported'));
        },
      ),
    );
  }

  dataPhoto(var data) {
    var bytes;
    if (data != '') {
      bytes = const Base64Decoder().convert(data);
      print("bytesny adalah : $bytes");
    }
    return data != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Image.memory(
                    (bytes),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        data = '';
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                  // Text(
                  //   '${data.descPersyaratan} Uploaded',
                  //   style: TextStyle(
                  //     color: Colors.grey,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              )
            ],
          )
        : Container();
  }

  Widget body() {
    print("datanya ${Context().photo}");
    var bytes;
    if (Context().photo != null) {
      bytes = const Base64Decoder().convert(Context().photo);
    }
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
                title: Row(
                  children: [
                    Text(
                      'Work Order No.',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 230,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Reset',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
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
                    enabled: false,
                    controller: wonodata,
                    decoration: InputDecoration(
                        hintText: widget.wono,
                        border: InputBorder.none,
                        filled: true),
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
                  'Attachment',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Context().photo == null
                    ? Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            // color: Color(0xffEAEAEA),
                            border: Border.all(
                                color: Theme.of(context).primaryColor)
                            // border: Border.all(color: bluepos)
                            ),
                        child: IconButton(
                          onPressed: () {
                            imageSelector(context, 'gallery', data);
                          },
                          icon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_file,
                                color: Colors.grey,
                                size: 30,
                              ),
                              Text(
                                'Upload Image',
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        // Image.asset(
                        //   'assets/modem.jpg',
                        //   fit: BoxFit.fill,
                        // ),
                      )
                    : InkWell(
                        onTap: () {
                          imageSelector(context, 'gallery', data);
                        },
                        child: Container(
                          width: 100,
                          height: 250,
                          child: Image.memory(
                            bytes,
                            fit: BoxFit.fill,
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
                  'Actual End Date',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
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
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Container(
                  width: 50,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: Color(0xffEAEAEA),
                      border: Border.all(color: Theme.of(context).primaryColor)
                      // border: Border.all(color: bluepos)
                      ),
                  child: TextFormField(
                    maxLines: 5,
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
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
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
                  'Completion WO',
                  style: TextStyle(fontFamily: 'Oswald', letterSpacing: 1),
                ),
                color: Theme.of(context).primaryColor,
                disabledColor: Colors.grey[400],
                textColor: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 100,
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
