import 'package:apps_mobile/business_logic/cubit/assetaudit_cubit.dart';
import 'package:apps_mobile/business_logic/models/assetauditmodel/assetauditheader.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'assetauditdetail.dart';

class AssetAudit extends StatefulWidget {
  const AssetAudit({Key? key}) : super(key: key);

  @override
  _AssetAuditState createState() => _AssetAuditState();
}

class _AssetAuditState extends State<AssetAudit> {
  TextEditingController _docNoTextController = TextEditingController();
  TextEditingController _locatorTextController = TextEditingController();
  TextEditingController _dateTextController = TextEditingController();
  late List<AssetAuditHeader> assetAuditHeader;

  @override
  void dispose() {
    _docNoTextController.dispose();
    _locatorTextController.dispose();
    _dateTextController.dispose();
    super.dispose();
  }

  callCubitOnDocNoInputDone() async {
    setState(() {
      this.assetAuditHeader = [];
    });
    await BlocProvider.of<AssetAuditCubit>(context).getAssetAuditHeader(
      this._docNoTextController.text.toUpperCase(),
    );
  }

  scanDocumentbyQR() async {
    await BlocProvider.of<AssetAuditCubit>(context).scanDocumentbyQR(context);
  }

  Widget body() {
    Widget firstLiner() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Document No.',
            style: OpusbTheme().blackTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 10,
                ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: _docNoTextController,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  if (_docNoTextController.text != '')
                    callCubitOnDocNoInputDone();
                },
                onChanged: (value) {
                  setState(() {
                    _dateTextController.text = '';
                    _locatorTextController.text = '';
                  });
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.receipt,
                      color: Colors.blue[400],
                    ),
                    fillColor: Colors.grey[200],
                    alignLabelWithHint: true,
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    )),
              )),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    scanDocumentbyQR();
                  },
                  icon: Icon(
                    Icons.qr_code_scanner,
                    color: Colors.blue[400],
                  ),
                ),
              )
            ],
          ),
        ],
      );
    }

    Widget secondLiner() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Locator :',
                  style: OpusbTheme().blackTextStyle.copyWith(
                        fontWeight: bold,
                        fontSize: 10,
                      ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _locatorTextController,
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.home,
                      color: Colors.grey[500],
                      size: 25,
                    ),
                    isDense: true,
                    fillColor: Colors.grey[200],
                    alignLabelWithHint: true,
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date :',
                  style: OpusbTheme().blackTextStyle.copyWith(
                        fontWeight: bold,
                        fontSize: 10,
                      ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _dateTextController,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) {},
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.date_range,
                        color: Colors.grey[500],
                        size: 25,
                      ),
                      isDense: true,
                      fillColor: Colors.grey[200],
                      alignLabelWithHint: true,
                      filled: true,
                      contentPadding:
                          EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget bottomPanel() {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: [
            Container(
              color:
                  _locatorTextController.text != "" && assetAuditHeader != null
                      ? OpusbTheme().primaryMaterialColor
                      : Colors.grey,
              width: double.infinity,
              height: 40,
              child: MaterialButton(
                onPressed: () {
                  assetAuditHeader != null && _locatorTextController.text != ""
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider<AssetAuditCubit>(
                                create: (BuildContext context) =>
                                    AssetAuditCubit(),
                                child: AssetAuditDetail(assetAuditHeader)),
                          ),
                        )
                      : null;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.download_done_outlined,
                      color: whiteTheme,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Start Audit',
                      style: OpusbTheme().whiteTextStyleO.copyWith(
                            fontWeight: bold,
                            letterSpacing: 1,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              color: _locatorTextController.text != ''
                  ? OpusbTheme().primaryMaterialColor.shade100
                  : Colors.grey,
              width: double.infinity,
              height: 40,
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    reset();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cancel,
                      color: whiteTheme,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Reset Data',
                      style: OpusbTheme().whiteTextStyleO.copyWith(
                            fontWeight: bold,
                            letterSpacing: 1,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      child: Column(
        children: [
          Card(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                firstLiner(),
                SizedBox(
                  height: 10,
                ),
                secondLiner(),
              ],
            ),
          )),
          SizedBox(
            height: 15,
          ),
          bottomPanel()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Asset Audit',
            style: OpusbTheme().whiteTextStyleO.copyWith(letterSpacing: 1),
          ),
          leading: Builder(
            builder: (context) => IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ),
        body: BlocConsumer<AssetAuditCubit, AssetAuditState>(
          builder: (context, state) {
            return body();
          },
          listener: (context, state) {
            if (state is AssetAuditLoadHeader) {
              setState(() {
                this.assetAuditHeader = state.dataHeader;
                _dateTextController.text = assetAuditHeader.first.date1;
                _locatorTextController.text =
                    assetAuditHeader.first.locator.identifier!;
              });
            } else if (state is ScanValue) {
              this._docNoTextController.text = state.value;
              callCubitOnDocNoInputDone();
            } else if (state is AssetAuditFailed) {
              _showSnackBar(context, state.message);
            }
          },
        ));
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
    _dateTextController.clear();
    _docNoTextController.clear();
    _locatorTextController.clear();
    this.assetAuditHeader = [];
  }
}
