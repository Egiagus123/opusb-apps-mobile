import 'package:apps_mobile/business_logic/cubit/asset_offlne_cubit.dart';
import 'package:apps_mobile/business_logic/localrequirement/models_databasehelper/shipment_models.dart';
import 'package:apps_mobile/business_logic/models/assettrfmodel/tooltrf_header.dart';
import 'package:apps_mobile/business_logic/models/assettrfmodel/tooltrf_line.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/features/core/component/color.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/assetshipment/history_shipment.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/assetshipment/update_shipment.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/pagesreceiving/1_off_receivinglist.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/pagestrf/2_off_trfdetail.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/database.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_asset.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_assetline.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/table_trxasset.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_header.dart';
import 'package:apps_mobile/ui/themes/opusb_theme.dart';
import 'package:apps_mobile/widgets/dialog_util.dart';
import 'package:apps_mobile/widgets/loading_indicator.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqflite/sqflite.dart';

class OfflineTranscationList extends StatefulWidget {
  const OfflineTranscationList({Key? key}) : super(key: key);
  @override
  _OfflineTranscationListState createState() => _OfflineTranscationListState();
}

class _OfflineTranscationListState extends State<OfflineTranscationList>
    with SingleTickerProviderStateMixin {
  List<Tab> tabs = <Tab>[
    const Tab(child: Text('Update Widget')),
    const Tab(child: Text('History Upload')),
  ];
  late List<ListAssetTrf> listData;
  late List<ToolsTrfHeader> pushData;
  late List<ToolsTrfLine> testLn;
  List<dynamic> listHeader = [];
  late List<ListAssetTrfLine> trxLineList;
  late TabController tabController;
  DatabaseHelper helper = DatabaseHelper();
  QueryTrxTable query = QueryTrxTable();
  late AssetOfflineCubit assetOffCubit;
  late ToolsTrfHeader dataHeader;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
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

    if (listData == null) {
      listData = [];
      updateListView();
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          toolbarHeight: 70,
          centerTitle: true,
          leadingWidth: MediaQuery.of(context).size.width,
          leading: Builder(
            builder: (context) => Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                      flex: 7,
                      child: InkWell(
                        onTap: () {
                          backButtonDrawer();
                        },
                        overlayColor: MaterialStateProperty.all(blueTheme),
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: whiteTheme,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              border: Border.all(
                                width: 1,
                                color: whiteTheme,
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_back_outlined,
                              color: blueTheme,
                              size: 25,
                            ),
                          ),
                        ),
                      )),
                  Expanded(flex: 3, child: SizedBox()),
                ],
              ),
            ),
          ),
          title: Container(
            child: Text('Shipment Activity',
                style: OpusbTheme().latoTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: whiteTheme)),
          ),
          backgroundColor: blueTheme,
        ),
        body: BlocListener<AssetOfflineCubit, AssetOfflineState>(
          listener: (context, state) {
            if (state is AssetloadDataDBState) {
              setState(() {});
            } else if (state is AssetOfflineInProgress) {
              LoadingIndicator();
            } else if (state is AssetOfflinePushSubmitted) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => buildAlertDialog(context,
                          title: 'Document Created',
                          content: 'successfully created ',
                          proceedText: 'OK', proceedCallback: () {
                        Navigator.of(context).pop(true);
                      }, cancelText: '', cancelCallback: () {})).then((_) {
                _resetForm();
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => OfflineTranscationList()));
              });
            }
          },
          child: buildBodyNew(),
        ));
  }

  Widget buildBodyNew() {
    return Container(
      color: blueTheme,
      child: Column(
        children: [
          Container(
              color: blueTheme, height: 90, child: Center(child: _tabSlider())),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  color: whiteTheme),
              child: TabBarView(
                controller: tabController,
                children: [
                  Container(
                    child: UpdateShipment(
                      shipmentOfflineModel: null,
                      statusShipment: null,
                      setShipmentObject:
                          (ShipmentOfflineModel? shipmentOfflineModel) {},
                    ),
                  ),
                  Container(
                    child: HistoryUpload(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabSlider() {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
        color: whiteTheme,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: TabBar(
        tabs: tabs,
        controller: tabController,
        indicator: BoxDecoration(
          color: blueTheme,
          borderRadius: BorderRadius.circular(20),
        ),
        indicatorColor: blueTheme,
        labelStyle:
            OpusbTheme().latoTextStyle.copyWith(color: blueTheme, fontSize: 16),
        labelColor: whiteTheme,
        unselectedLabelColor: blueTheme,
        onTap: (value) {
          setState(() {
            // TO DO HERE
          });
        },
      ),
    );
  }

  Widget buildbody() {
    return Column(children: <Widget>[
      Expanded(
          child: ListView.builder(
              itemCount: listData == null ? 0 : listData.length,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext ctx, int index) {
                return InkWell(
                    onTap: () {
                      if (listData[index].trxtype == 'Transfer') {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => AssetTrfOffDetail(
                                    [] as ListDataMovReqHeader,
                                    listData[index])));
                      } else {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    OfflineReceivingList(listData[index])));
                      }
                    },
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              int result = await query
                                  .deleteAllData(listData[index].toolRequestId);
                              if (result > 0) {
                                updateListView();
                              }
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: EvaIcons
                                .close, // Pastikan Anda sudah import eva_icons
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Card(
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '# ${listData[index].trxtype}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Document No'),
                                    Text('Transfer Date'),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(' : ${listData[index].docNo}'),
                                    listData[index].trxtype == 'Transfer'
                                        ? Text(' : ${listData[index].dateReq}')
                                        : Text(' : ${listData[index].dateRec}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ));
              })),
    ]);
  }

  push(ToolsTrfHeader listData) async {
    assetOffCubit = BlocProvider.of<AssetOfflineCubit>(context);
    await assetOffCubit.pushDataOffline(listData);
  }

  Future<void> _resetForm() async {
    await query.deleteAllTransaction().whenComplete(() => updateListView());
  }

  void updateListView() {
    List<dynamic> listLine = [];
    ToolsTrfLine ln;
    final Future<Database> dbfuture = helper.initializedDatabase();
    dbfuture.then((database) {
      Future<List<ListAssetTrf>> listDataFuture = query.fetchdatalistHeader();

      listDataFuture.then((listData) {
        dbfuture.then((database) => listData.forEach((h) async {
              Future<List<ListAssetTrfLine>> listDataFutureLn =
                  query.fetchdatalistLine(h.toolRequestId);
              listDataFutureLn.then((lines) {
                lines.forEach((l) {
                  ln = ToolsTrfLine(
                      doctype: Reference(id: 1001857),
                      installBase: Reference(id: l.installBaseID),
                      locator: Reference(id: h.locatorID),
                      locatorTo: Reference(id: h.locatorNewID),
                      qtyEntered: l.qtyEntered,
                      requestID: Reference(id: l.toolRequestId),
                      trxtype: h.trxtype,
                      datedoc: h.dateDocument,
                      serNo: l.serNo);
                  listLine.add(ln);
                });
                setState(() {
                  this.testLn =
                      listLine.map((item) => item as ToolsTrfLine).toList();
                });
              });
            }));
        setState(() {
          this.listData = listData;
        });
      });
    });
  }
}
