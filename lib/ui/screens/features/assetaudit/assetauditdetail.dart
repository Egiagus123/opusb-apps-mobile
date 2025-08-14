// ignore_for_file: missing_required_param

import 'package:apps_mobile/business_logic/cubit/assetaudit_cubit.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditheader.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditline.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditput.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditstatus.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetmodels.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:apps_mobile/ui/screens/features/assetaudit/assetauditcreate.dart';
import 'package:apps_mobile/ui/screens/features/assetaudit/assetauditedit.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:apps_mobile/widgets/loading_indicator.dart';
import 'package:apps_mobile/widgets/text_line.dart';
import 'package:apps_mobile/widgets/text_lineupdate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetAuditDetail extends StatefulWidget {
  final List<AssetAuditHeader> assetAuditHeader;
  AssetAuditDetail(this.assetAuditHeader, {Key? key}) : super(key: key);

  @override
  _AssetAuditDetailState createState() {
    return _AssetAuditDetailState(this.assetAuditHeader);
  }
}

class _AssetAuditDetailState extends State<AssetAuditDetail> {
  dynamic assetStatusNewValue;
  var listStatus;

  TextEditingController _noteTextController = TextEditingController();
  TextEditingController _qtyCount = TextEditingController();
  TextEditingController _searchAssetTextController = TextEditingController();

  List<AssetAuditHeader> assetAuditHeader;
  List<AssetAuditLines> assetAuditLine = [];
  List<AssetAuditStatusModel> assetStatus = [];
  List<AssetModel> assetModel = [];
  dynamic lines;
  bool isLoadingVertical = false;
  bool isProcessing = false;
  _AssetAuditDetailState(this.assetAuditHeader);

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

  Future<void> getLinesByKeyboardInput() async {
    await BlocProvider.of<AssetAuditCubit>(context).getLinesByKeyboardInput(
      assetAuditHeader.first.id,
      _searchAssetTextController.text,
    );
  }

  Future<void> getLineByCardTap(var asset) async {
    await BlocProvider.of<AssetAuditCubit>(context)
        .getLinesByKeyboardInput(assetAuditHeader.first.id, asset);
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
    return BlocConsumer<AssetAuditCubit, AssetAuditState>(
        builder: (context, state) {
      if (state is AssetAuditInProgress) {
        return LoadingIndicator();
      }
      return ListView.builder(
        itemCount: assetAuditLine != null ? assetAuditLine.length : 0,
        itemBuilder: (context, index) {
          var datas = assetAuditLine[index];
          return Container(
            child: Card(
              child: InkWell(
                onTap: () {
                  getLineByCardTap(datas.assetvalue);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextLineUpdateCustom(
                                title:
                                    'ASSET (${datas.auditStatus.identifier!.toUpperCase()})',
                                freetext: '${datas.assetvalue}',
                                fontWeight: bold,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextLineCustom(
                                freetext: 'Qty',
                                fontSize: 10,
                              ),
                              TextLineCustom(
                                freetext: datas.qtyCount.toInt().toString(),
                                fontSize: 18,
                                fontWeight: bold,
                              )
                            ],
                          ),
                        ],
                      ),
                      TextLineCustom(
                        freetext: 'Asset Name : ${datas.assetname}',
                        fontSize: 10,
                      ),
                      TextLineCustom(
                        freetext: 'UPDATED : ${datas.updated}',
                        fontSize: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }, listener: (context, state) {
      if (state is AssetAuditFailed) {
        _showSnackBar(context, state.message);
      } else if (state is AssetAuditGetLinesAudited) {
        this.assetAuditLine = state.dataLines;
      }
    });
  }

  Widget header() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchAssetTextController,
            textInputAction: TextInputAction.go,
            onSubmitted: (value) {
              this._searchAssetTextController.text = value;
              getLinesByKeyboardInput();
            },
            decoration: InputDecoration(
                fillColor: Colors.grey[200],
                alignLabelWithHint: true,
                filled: true,
                hintText: 'Input Asset Key ...',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                )),
          ),
        ),
        Container(
          width: 50,
          height: 50,
          color: Colors.transparent,
          child: IconButton(
            onPressed: () {
              getLinesScanned();
            },
            icon: Icon(
              Icons.qr_code_scanner,
              color: Colors.blue[400],
            ),
          ),
        )
      ],
    );
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
            'Audited Asset',
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
                horizontal: 10,
                vertical: 15,
              ),
              child: Column(
                children: [
                  header(),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: body(),
                  ),
                ],
              ));
        }, listener: (context, state) {
          if (state is AssetAuditLoadLineAndGetAuditStatus) {
            this.assetAuditLine = state.dataLines;
            assetStatus = state.auditStatus;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<AssetAuditCubit>(
                    create: (BuildContext context) => AssetAuditCubit(),
                    child: AssetAuditEdit(
                      assetAuditHeader,
                      assetStatus,
                      assetAuditLine,
                    )),
              ),
            );
          } else if (state is AssetAuditCreateLineAndGetAuditStatus) {
            assetStatus = state.auditStatus;
            assetModel = state.newLines;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<AssetAuditCubit>(
                    create: (BuildContext context) => AssetAuditCubit(),
                    child: AssetAuditCreate(
                      assetAuditHeader,
                      assetStatus,
                      assetModel,
                    )),
              ),
            );
          }
        }),
        // floatingActionButton: FloatingActionButton(
        //     onPressed: () {
        //       getLinesScanned();
        //     },
        //     child: Icon(
        //       Icons.qr_code_scanner,
        //       color: whiteTheme,
        //     ),
        //     backgroundColor: OpusbTheme().primaryMaterialColor),
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
