import 'package:apps_mobile/business_logic/cubit/assetaudit_cubit.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditheader.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditline.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditput.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditstatus.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:apps_mobile/widgets/text_line.dart';
import 'package:apps_mobile/widgets/text_lineupdate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AssetAuditDetails extends StatefulWidget {
  final List<AssetAuditHeader> assetAuditHeader;
  AssetAuditDetails(this.assetAuditHeader, {Key? key}) : super(key: key);

  @override
  _AssetAuditDetailsState createState() {
    return _AssetAuditDetailsState(this.assetAuditHeader);
  }
}

class _AssetAuditDetailsState extends State<AssetAuditDetails> {
  dynamic assetStatusNewValue;
  var listStatus;

  TextEditingController _noteTextController = TextEditingController();
  TextEditingController _qtyCount = TextEditingController();

  List<AssetAuditHeader> assetAuditHeader;
  List<AssetAuditLines>? assetAuditLine;
  List<AssetAuditStatusModel>? assetStatus;
  dynamic lines;
  bool isLoadingVertical = false;
  bool isProcessing = false;
  _AssetAuditDetailsState(this.assetAuditHeader);

  @override
  void initState() {
    super.initState();
    getLinesAudited();
  }

  Future<void> getLinesAudited() async {
    await BlocProvider.of<AssetAuditCubit>(context)
        .getLinesAudited(assetAuditHeader.first.id);
  }

  Future<void> getLinesScanned() async {
    await BlocProvider.of<AssetAuditCubit>(context)
        .scanLinesbyQR(assetAuditHeader.first.id, context);
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

  Widget body() {
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

    return BlocConsumer<AssetAuditCubit, AssetAuditState>(
        builder: (context, state) {
      if (state is AssetAuditLoadLineAndGetAuditStatus) {
        this.assetAuditLine = state.dataLines;
        var lines = assetAuditLine!.first;
        assetStatus = state.auditStatus;
        if (assetStatus!.length > 0) {
          assetStatus!.forEach((e) {
            if (e.value == assetAuditLine!.first.auditStatus.id) {
              listStatus = e;
            }
          });
        }
        _noteTextController = TextEditingController(text: lines.note);
        _qtyCount = TextEditingController.fromValue(new TextEditingValue(
            text: lines.qtyCount == null
                ? '0'
                : lines.qtyCount.toInt().toString(),
            selection: new TextSelection.collapsed(
                offset: lines.qtyCount.toString().length)));
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tittle('AUDIT AVAILABLE ASSET'),
              TextLineUpdateCustom(
                title: 'Key :',
                freetext: lines.asset.identifier,
                fontWeight: bold,
              ),
              SizedBox(
                height: 10,
              ),
              TextLineUpdateCustom(
                title: 'Asset Name :',
                freetext: lines.name == null ? '-' : lines.name,
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
                    items: _buildAuditStatus(context, assetStatus!),
                    icon: Icon(
                      Icons.arrow_drop_down_circle,
                      color: assetStatus!.length > 0
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
                freetext: lines.assetActivationDate == null
                    ? '-'
                    : lines.assetActivationDate,
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
                                    lines.qtyCount = qtyBookInt;
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
                                  lines.qtyCount = int.tryParse(value)!;
                                });
                              },
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(fontFamily: 'Montserrat'),
                              textAlign: TextAlign.center,
                              controller: _qtyCount,
                              keyboardType: TextInputType.number,
                              onTap: () => _qtyCount.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _qtyCount.value.text.length),
                              onChanged: (value) {
                                if (int.tryParse(value)! < 0) {
                                  _qtyCount.value = TextEditingValue(
                                      text: lines.qtyCount.toString(),
                                      selection: TextSelection.fromPosition(
                                          TextPosition(
                                              offset: lines.qtyCount
                                                  .toString()
                                                  .length)));
                                  setState(() {
                                    lines.qtyCount = 0;
                                    _qtyCount.text = lines.qtyCount.toString();
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
                                    lines.qtyCount = qtyBookInt;
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
                    // onTap: () => _noteTextController.selection = TextSelection(
                    //     baseOffset: 0,
                    //     extentOffset: _noteTextController.value.text.length),
                    onSubmitted: (value) {
                      setState(() {
                        _noteTextController =
                            TextEditingController(text: value);
                        assetAuditLine!.first.note = value;
                      });
                    },
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
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
                                  "Are you sure you want to delete asset ${lines.asset.identifier} from list?"),
                              actions: <Widget>[
                                MaterialButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("Cancel"),
                                ),
                                MaterialButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Remove")),
                              ],
                            );
                          },
                        );
                        if (isRemove) {
                          setState(() {
                            this.isProcessing = true;
                          });
                          bool isDeleted = await deletedata(lines);
                          if (isDeleted) {
                            _showSnackBar(context, 'Successfully Deleted.');
                            setState(() {
                              this.isProcessing = false;
                            });
                            reset();
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
                                content: Text("Data has been updated !"),
                                actions: <Widget>[
                                  MaterialButton(
                                    onPressed: () => Navigator.pop(context),
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
        );
      } else if (state is AssetAuditCreateLineAndGetAuditStatus) {
        assetStatus = state.auditStatus;
        var now = new DateTime.now();
        var formatter = new DateFormat('MM-dd-yyyy');
        String dateActivation = formatter.format(now);
        lines = state.newLines.first;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tittle('CREATE NEW LINES TO AUDIT'),
              TextLineUpdateCustom(
                title: 'Key :',
                freetext: lines.value,
                fontWeight: bold,
              ),
              SizedBox(
                height: 10,
              ),
              TextLineUpdateCustom(
                title: 'Asset Name :',
                freetext: lines.name,
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
                    items: _buildAuditStatus(context, assetStatus!),
                    icon: Icon(
                      Icons.arrow_drop_down_circle,
                      color: assetStatus!.length > 0
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
              // TextLineUpdateCustom(
              //   title: 'Activation :',
              //   freetext: dateActivation,
              //   fontWeight: bold,
              // ),
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
                                    _qtyCount.text = qtyBookInt.toString();
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
                              onTap: () => _qtyCount.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _qtyCount.value.text.length),
                              onChanged: (value) {
                                if (int.tryParse(value)! < 0) {
                                  _qtyCount.value = TextEditingValue(
                                      text: '0',
                                      selection: TextSelection.fromPosition(
                                          TextPosition(
                                              offset: _qtyCount.text.length)));
                                  setState(() {
                                    _qtyCount.text = '0';
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
                                _qtyCount = TextEditingController.fromValue(
                                    TextEditingValue(
                                        text: _qtyCount.text == ''
                                            ? '0'
                                            : _qtyCount.text,
                                        selection: TextSelection.collapsed(
                                            offset:
                                                _qtyCount.toString().length)));
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
                    onTap: () => _noteTextController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _noteTextController.value.text.length),
                    onSubmitted: (value) {
                      setState(() {
                        _noteTextController =
                            TextEditingController(text: value);
                        assetAuditLine!.first.note = value;
                      });
                    },
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
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
                              title: const Text("Cancel"),
                              content: Text(
                                  "Are you sure you want to cancel asset?"),
                              actions: <Widget>[
                                MaterialButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("No"),
                                ),
                                MaterialButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Yes")),
                              ],
                            );
                          },
                        );
                        if (isRemove) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider<AssetAuditCubit>(
                                      create:
                                          (BuildContext context) =>
                                              AssetAuditCubit(),
                                      child:
                                          AssetAuditDetails(assetAuditHeader)),
                            ),
                          );
                          reset();
                        }
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
                        if (_qtyCount.text != null && listStatus != null) {
                          bool isUpdateSuccess = await createNew();
                          if (isUpdateSuccess) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text("Data has been created !"),
                                  actions: <Widget>[
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider<
                                                    AssetAuditCubit>(
                                                create:
                                                    (BuildContext context) =>
                                                        AssetAuditCubit(),
                                                child: AssetAuditDetails(
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
                      color: _qtyCount.text != "" && assetStatusNewValue != null
                          ? OpusbTheme().primaryMaterialColor
                          : Colors.grey,
                      child: Text(
                        'Create Asset',
                        style: OpusbTheme().whiteTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
      return Container();
    }, listener: (context, state) {
      if (state is AssetAuditFailed) {
        _showSnackBar(context, state.message);
      }
    });
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
        assetAuditLine!.first.id);
    return success;
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
            asset: Reference(id: lines.id)),
        assetAuditHeader.first.id);
    return success;
  }

  Future<bool> _handleWillPop([bool? isLoading]) async {
    if (!isProcessing) {
      Navigator.pop(context, true);
    } else {
      null;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _handleWillPop(isProcessing);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Audit Asset',
            style: OpusbTheme().whiteTextStyleO,
          ),
          centerTitle: true,
          leading: !isProcessing
              ? Builder(
                  builder: (context) => IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                )
              : SizedBox(),
        ),
        body: BlocConsumer<AssetAuditCubit, AssetAuditState>(
            builder: (context, state) {
              return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: body(),
                      ),
                    ],
                  ));
            },
            listener: (context, state) {}),
        floatingActionButton: !isProcessing && assetAuditHeader != null
            ? FloatingActionButton(
                onPressed: () {
                  if (assetAuditLine == null ||
                      assetAuditLine!.length == 0 && lines == null) {
                    reset();
                    getLinesScanned();
                  } else {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("Scan another asset?"),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("No"),
                            ),
                            MaterialButton(
                              onPressed: () {
                                reset();
                                Navigator.pop(context);
                                getLinesScanned();
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Icon(
                  Icons.qr_code_scanner,
                  color: whiteTheme,
                ),
                backgroundColor: OpusbTheme().primaryMaterialColor)
            : null,
      ),
    );
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
}
