import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

import 'package:apps_mobile/business_logic/cubit/assetaudit_cubit.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditheader.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditline.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditput.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditstatus.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/ui/screens/features/assetaudit/assetauditdetail.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:apps_mobile/widgets/text_line.dart';
import 'package:apps_mobile/widgets/text_lineupdate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetAuditEdit extends StatefulWidget {
  final List<AssetAuditHeader> assetAuditHeader;
  final List<AssetAuditStatusModel> assetStatus;
  final List<AssetAuditLines> assetAuditLine;
  AssetAuditEdit(this.assetAuditHeader, this.assetStatus, this.assetAuditLine,
      {Key? key})
      : super(key: key);

  @override
  _AssetAuditEditState createState() {
    return _AssetAuditEditState(
      this.assetAuditHeader,
      this.assetStatus,
      this.assetAuditLine,
    );
  }
}

class _AssetAuditEditState extends State<AssetAuditEdit> {
  List<AssetAuditHeader> assetAuditHeader;
  List<AssetAuditStatusModel> assetStatus;
  List<AssetAuditLines> assetAuditLine;
  _AssetAuditEditState(
      this.assetAuditHeader, this.assetStatus, this.assetAuditLine);

  dynamic assetStatusNewValue;
  var listStatus;

  TextEditingController _noteTextController = TextEditingController();
  TextEditingController _qtyCount = TextEditingController();

  AssetAuditLines? lines;
  bool isLoadingVertical = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
  }

  Future<num> decrementQty(oldQty) async {
    oldQty -= 1;
    print(' minus $oldQty');
    return oldQty;
  }

  Future<num> incrementQty(oldQty) async {
    oldQty += 1;
    print(' plus $oldQty');
    return oldQty;
  }

  List<DropdownMenuItem> _buildAuditStatus(
      BuildContext context, List<AssetAuditStatusModel> listStatus) {
    return listStatus
        .map((listStatus) => DropdownMenuItem(
              value: listStatus,
              child: Text(
                listStatus.name,
                overflow: TextOverflow.ellipsis,
              ),
            ))
        .toList();
  }

  Future<bool> deletedata(AssetAuditLines data) async {
    bool isDeleted =
        await BlocProvider.of<AssetAuditCubit>(context).deleteLines(data);
    return isDeleted;
  }

  Future<bool> updateData() async {
    bool success = await BlocProvider.of<AssetAuditCubit>(context).updateLine(
        AssetAuditPut(
          auditStatus: assetStatusNewValue == null
              ? Reference(id: listStatus.value)
              : Reference(id: assetStatusNewValue.value),
          note: _noteTextController.text,
          qtyCount: num.parse(this._qtyCount.text),
          isAudited: true,
        ),
        assetAuditLine.first.id);
    return success;
  }

  void _showSnackBar(BuildContext context, String message,
      [Color color = Colors.red]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 3),
      action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }),
      content: Text(message),
      backgroundColor: color,
    ));
  }

  void reset() {
    this.assetAuditLine = [];
    this.listStatus = null;
    this.assetStatus = [];
    this.assetStatusNewValue = null;
    _qtyCount.clear();
    _noteTextController.clear();
    this.lines = null;
    this.isProcessing = false;
  }

  Widget tittle(String title) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: TextLineCustom(
              freetext: title,
              fontSize: 17,
              fontWeight: bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextLineUpdateCustom(
            title: 'Document No. :',
            freetext: assetAuditHeader.first.documentNo,
            fontWeight: bold,
          ),
          SizedBox(
            height: 10,
          ),
          TextLineUpdateCustom(
            title: 'Locator :',
            freetext: assetAuditHeader.first.locator.identifier,
            fontWeight: bold,
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Future<bool> _handleWillPop([bool? isLoading]) async {
    if (!isProcessing) {
      // Jika tidak sedang memproses, lakukan navigasi dan kembalikan true setelahnya
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider<AssetAuditCubit>(
            create: (BuildContext context) => AssetAuditCubit(),
            child: AssetAuditDetail(assetAuditHeader),
          ),
        ),
      );
      return true; // Kembalikan true setelah navigasi selesai
    } else {
      // Jika sedang memproses, kembalikan false
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    lines = assetAuditLine != null ? assetAuditLine.first : null;
    if (assetStatus.length > 0) {
      assetStatus.forEach((e) {
        if (e.value == assetAuditLine.first.auditStatus.id) {
          listStatus = e;
        }
      });
    }
    _noteTextController = TextEditingController(text: lines!.note);
    _qtyCount = TextEditingController.fromValue(new TextEditingValue(
        text:
            lines!.qtyCount == null ? '0' : lines!.qtyCount.toInt().toString(),
        selection: new TextSelection.collapsed(
            offset: lines!.qtyCount.toString().length)));
    return WillPopScope(
      onWillPop: () {
        return _handleWillPop(isProcessing);
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'Asset Audit Detail',
              style: OpusbTheme().whiteTextStyleO,
            ),
          ),
          body: BlocConsumer<AssetAuditCubit, AssetAuditState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tittle('AUDIT AVAILABLE ASSET'),
                        TextLineUpdateCustom(
                          title: 'Key :',
                          freetext: lines!.assetvalue,
                          fontWeight: bold,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextLineUpdateCustom(
                          title: 'Asset Name :',
                          freetext:
                              lines!.assetname == null ? '-' : lines!.assetname,
                          fontWeight: bold,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Status :',
                          style: OpusbTheme().blackTextStyle.copyWith(
                                fontSize: 10,
                              ),
                        ),
                        DropdownButtonHideUnderline(
                          child: Container(
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              isDense: true,
                              itemHeight: 50,
                              value: listStatus,
                              items: _buildAuditStatus(context, assetStatus),
                              icon: Icon(
                                Icons.arrow_drop_down_circle,
                                color: assetStatus.length > 0
                                    ? OpusbTheme().primaryMaterialColor
                                    : Colors.grey,
                              ),
                              onChanged: (changedValue) async {
                                setState(() {
                                  listStatus = changedValue;
                                  assetStatusNewValue = changedValue;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextLineUpdateCustom(
                          title: 'Activation :',
                          freetext: lines!.assetActivationDate == null
                              ? '-'
                              : lines!.assetActivationDate,
                          fontWeight: bold,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextLineCustom(
                                  freetext: 'Quantity Count',
                                  fontSize: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      child: FloatingActionButton(
                                        heroTag: Text('decrementQty'),
                                        onPressed: () async {
                                          if (int.parse(_qtyCount.text) > 0) {
                                            num qtyBookInt = await decrementQty(
                                                int.parse(_qtyCount.text));
                                            print('-- $qtyBookInt');
                                            setState(() {
                                              lines!.qtyCount = qtyBookInt;
                                            });
                                          }
                                        },
                                        child: new Icon(
                                          Icons.remove,
                                          color: whiteTheme,
                                          size: 20,
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          isDense: true,
                                          counterText: '',
                                        ),
                                        onSubmitted: (value) async {
                                          setState(() {
                                            lines!.qtyCount =
                                                int.tryParse(value)!;
                                          });
                                        },
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(fontFamily: 'Montserrat'),
                                        textAlign: TextAlign.center,
                                        controller: _qtyCount,
                                        keyboardType: TextInputType.number,
                                        onTap: () => _qtyCount.selection =
                                            TextSelection(
                                                baseOffset: 0,
                                                extentOffset: _qtyCount
                                                    .value.text.length),
                                        onChanged: (value) {
                                          if (int.tryParse(value)! < 0) {
                                            _qtyCount.value = TextEditingValue(
                                                text:
                                                    lines!.qtyCount.toString(),
                                                selection:
                                                    TextSelection.fromPosition(
                                                        TextPosition(
                                                            offset: lines!
                                                                .qtyCount
                                                                .toString()
                                                                .length)));
                                            setState(() {
                                              lines!.qtyCount = 0;
                                              _qtyCount.text =
                                                  lines!.qtyCount.toString();
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                      child: FloatingActionButton(
                                        heroTag: Text('incrementQty'),
                                        onPressed: () async {
                                          if (int.parse(_qtyCount.text) >= 0) {
                                            num qtyBookInt = await incrementQty(
                                                int.parse(_qtyCount.text));
                                            print('++ $qtyBookInt');
                                            setState(() {
                                              lines!.qtyCount = qtyBookInt;
                                            });
                                          }
                                        },
                                        child: new Icon(
                                          Icons.add,
                                          color: whiteTheme,
                                          size: 20,
                                        ),
                                        backgroundColor: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Note :',
                              style: OpusbTheme().blackTextStyle.copyWith(
                                    fontSize: 10,
                                  ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            TextField(
                              expands: false,
                              autofocus: false,
                              textInputAction: TextInputAction.go,
                              controller: _noteTextController,
                              maxLines: 2,
                              onSubmitted: (value) {
                                setState(() {
                                  _noteTextController =
                                      TextEditingController(text: value);
                                  assetAuditLine.first.note = value;
                                });
                              },
                              decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 150,
                              child: MaterialButton(
                                onPressed: () async {
                                  final bool isRemove = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Confirm"),
                                        content: Text(
                                            "Are you sure you want to delete asset ${lines!.asset.identifier} from list?"),
                                        actions: <Widget>[
                                          MaterialButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text("Cancel"),
                                          ),
                                          MaterialButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text("Remove")),
                                        ],
                                      );
                                    },
                                  );
                                  if (isRemove) {
                                    setState(() {
                                      this.isProcessing = true;
                                    });
                                    bool isDeleted = await deletedata(lines!);
                                    if (isDeleted) {
                                      _showSnackBar(
                                          context, 'Successfully Deleted.');
                                      setState(() {
                                        this.isProcessing = false;
                                        // reset();
                                      });
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider<AssetAuditCubit>(
                                                  create:
                                                      (BuildContext context) =>
                                                          AssetAuditCubit(),
                                                  child: AssetAuditDetail(
                                                      assetAuditHeader)),
                                        ),
                                      );
                                    }
                                  }
                                },
                                color: Colors.red,
                                child: Text(
                                  'Delete',
                                  style: OpusbTheme().whiteTextStyle,
                                ),
                              ),
                            ),
                            Container(
                              width: 150,
                              child: MaterialButton(
                                onPressed: () async {
                                  bool isUpdateSuccess = await updateData();
                                  if (isUpdateSuccess) {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content:
                                              Text("Data has been updated !"),
                                          actions: <Widget>[
                                            MaterialButton(
                                              onPressed: () => {
                                                Navigator.pop(context),
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => BlocProvider<
                                                            AssetAuditCubit>(
                                                        create: (BuildContext
                                                                context) =>
                                                            AssetAuditCubit(),
                                                        child: AssetAuditDetail(
                                                            assetAuditHeader)),
                                                  ),
                                                ),
                                              },
                                              // Navigator.pop(context),

                                              child: const Text("Ok"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    setState(() {
                                      this.assetStatusNewValue = null;
                                    });
                                  }
                                },
                                color: OpusbTheme().primaryMaterialColor,
                                child: Text(
                                  'Audit',
                                  style: OpusbTheme().whiteTextStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              listener: (context, state) {})),
    );
  }
}
