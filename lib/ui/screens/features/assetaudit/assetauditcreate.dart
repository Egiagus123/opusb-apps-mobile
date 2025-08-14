// ignore_for_file: missing_required_param

import 'package:apps_mobile/business_logic/cubit/assetaudit_cubit.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditheader.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditput.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditstatus.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetmodels.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/ui/screens/features/assetaudit/assetauditdetail.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:apps_mobile/widgets/text_line.dart';
import 'package:apps_mobile/widgets/text_lineupdate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetAuditCreate extends StatefulWidget {
  final List<AssetAuditHeader> assetAuditHeader;
  final List<AssetAuditStatusModel> assetStatus;
  final List<AssetModel> assetModel;
  const AssetAuditCreate(
      this.assetAuditHeader, this.assetStatus, this.assetModel,
      {Key? key})
      : super(key: key);

  @override
  _AssetAuditCreateState createState() {
    return _AssetAuditCreateState(
      this.assetAuditHeader,
      this.assetStatus,
      this.assetModel,
    );
  }
}

class _AssetAuditCreateState extends State<AssetAuditCreate> {
  List<AssetAuditHeader> assetAuditHeader;
  List<AssetAuditStatusModel> assetStatus;
  List<AssetModel> assetModel;
  _AssetAuditCreateState(
      this.assetAuditHeader, this.assetStatus, this.assetModel);

  TextEditingController _noteTextController = TextEditingController();
  TextEditingController _qtyCount = TextEditingController(text: '1');
  bool isLoadingVertical = false;
  bool isProcessing = false;
  AssetModel? lines;
  dynamic assetStatusNewValue;
  var listStatus;

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

  void reset() {
    this.assetModel = [];
    this.listStatus = null;
    this.assetStatus = [];
    this.assetStatusNewValue = null;
    _qtyCount.clear();
    _noteTextController.clear();
    this.lines = null;
    this.isProcessing = false;
  }

  Future<bool> createNew() async {
    bool success = await BlocProvider.of<AssetAuditCubit>(context).createNew(
        AssetAuditPut(
            headerID: Reference(id: assetAuditHeader.first.id),
            org: Reference(id: Context().orgId),
            auditStatus: assetStatusNewValue == null
                ? Reference(id: listStatus.value)
                : Reference(id: assetStatusNewValue.value),
            note: _noteTextController.text,
            qtyCount: num.parse(this._qtyCount.text),
            isAudited: true,
            asset: Reference(id: lines!.id)),
        assetAuditHeader.first.id);
    return success;
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

  Future<bool> _handleWillPop() async {
    final bool? isRemove = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cancel"),
          content: const Text("Are you sure you want to cancel asset?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    if (isRemove == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider<AssetAuditCubit>(
            create: (BuildContext context) => AssetAuditCubit(),
            child: AssetAuditDetail(assetAuditHeader),
          ),
        ),
      );
      reset();
    }

    return Future.value(isRemove ?? false); // Mengembalikan hasil jika perlu
  }

  @override
  Widget build(BuildContext context) {
    lines = assetModel.first;

    if (assetStatus.length > 0) {
      assetStatus.forEach((e) {
        if (e.value == lines!.assetstatus.id) {
          listStatus = e;
        }
      });
    }
    return WillPopScope(
      onWillPop: () {
        return _handleWillPop();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                    tittle('CREATE NEW LINES TO AUDIT'),
                    TextLineUpdateCustom(
                      title: 'Key :',
                      freetext: lines!.value,
                      fontWeight: bold,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextLineUpdateCustom(
                      title: 'Asset Name :',
                      freetext: lines!.name,
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
                                          _qtyCount.text =
                                              qtyBookInt.toString();
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
                                        _qtyCount.text = value;
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
                                            extentOffset:
                                                _qtyCount.value.text.length),
                                    onChanged: (value) {
                                      if (int.tryParse(value)! < 1) {
                                        _qtyCount.value = TextEditingValue(
                                            text: '1',
                                            selection:
                                                TextSelection.fromPosition(
                                                    TextPosition(
                                                        offset: _qtyCount
                                                            .text.length)));
                                        setState(() {
                                          _qtyCount.text = '1';
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
                                      _qtyCount =
                                          TextEditingController.fromValue(
                                              TextEditingValue(
                                                  text: _qtyCount.text == ''
                                                      ? '1'
                                                      : _qtyCount.text,
                                                  selection:
                                                      TextSelection.collapsed(
                                                          offset: _qtyCount
                                                              .toString()
                                                              .length)));
                                      num qtyBookInt = await incrementQty(
                                          int.parse(_qtyCount.text));
                                      print('++ $qtyBookInt');
                                      setState(() {
                                        _qtyCount.text = qtyBookInt.toString();
                                      });
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
                          textInputAction: TextInputAction.done,
                          controller: _noteTextController,
                          maxLines: 2,
                          onTap: () => _noteTextController.selection =
                              TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      _noteTextController.value.text.length),
                          onSubmitted: (value) {
                            setState(() {
                              _noteTextController =
                                  TextEditingController(text: value);
                            });
                          },
                          decoration: new InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
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
                              _handleWillPop();
                            },
                            color: Colors.red,
                            child: Text(
                              'Cancel',
                              style: OpusbTheme().whiteTextStyle,
                            ),
                          ),
                        ),
                        Container(
                          width: 150,
                          child: MaterialButton(
                            onPressed: () async {
                              if (_qtyCount.text != null &&
                                  listStatus != null) {
                                bool isUpdateSuccess = await createNew();
                                if (isUpdateSuccess) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content:
                                            Text("Data has been created !"),
                                        actions: <Widget>[
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);

                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BlocProvider<
                                                              AssetAuditCubit>(
                                                          create: (BuildContext
                                                                  context) =>
                                                              AssetAuditCubit(),
                                                          child: AssetAuditDetail(
                                                              assetAuditHeader)),
                                                ),
                                              ).then((value) => reset());
                                            },
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
                              }
                            },
                            color: _qtyCount.text != ""
                                ? OpusbTheme().primaryMaterialColor
                                : Colors.grey,
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
          listener: (context, state) {},
        ),
      ),
    );
  }
}
