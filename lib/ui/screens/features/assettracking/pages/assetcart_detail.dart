import 'package:apps_mobile/business_logic/cubit/asset_tracking_cubit.dart';
import 'package:apps_mobile/business_logic/models/installbase_model.dart';
import 'package:apps_mobile/business_logic/models/installbasestatus.dart';
import 'package:apps_mobile/business_logic/models/installbasetrf.dart';
import 'package:apps_mobile/business_logic/models/pmbacklog.dart';
import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pmbacklogdetails.dart' as tab_pmbacklog;
import 'tabdetails.dart' as tab_details;
import 'tabtransferhistory.dart' as tab_transferhistory;
import 'tabstatushistory.dart' as tab_statushistory;

class AssetCartDetail extends StatefulWidget {
  final InstallBaseModel data;
  final byte;

  AssetCartDetail(this.data, this.byte);
  @override
  _AssetCartDetailState createState() {
    return _AssetCartDetailState(this.data, this.byte);
  }
}

class _AssetCartDetailState extends State<AssetCartDetail> {
  InstallBaseModel data;
  var byte;

  AssetTrackingCubit? assetTrackingCubit;
  _AssetCartDetailState(this.data, this.byte);

  List<InstallBaseStatus>? installbasestatus;
  List<InstallBaseTransfer>? installbasetrfhistory;

  List<PMBacklogModel>? pmbacklog;

  Future<String> loadinitData() async {
    assetTrackingCubit = BlocProvider.of<AssetTrackingCubit>(context);
    await assetTrackingCubit!.getphoto(data.id);
    return 'success';
  }

  Future<String> loadpmdata() async {
    assetTrackingCubit = BlocProvider.of<AssetTrackingCubit>(context);
    await assetTrackingCubit!.getPMBacklog(data.id);
    return 'success';
  }

  @override
  void initState() {
    super.initState();
    loadinitData();
    loadpmdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // here the desired height
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
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
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).primaryColor,
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
            'Equipment',
            style: TextStyle(
                fontFamily: 'Oswald', letterSpacing: 1, color: Colors.white),
          ),
        ),
      ),
      body: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(47.0), // here the desired height
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Color(0xffEAEAEA),
                // leadingWidth: 200,
                bottom: new TabBar(
                  indicatorColor: Colors.grey,
                  labelColor: Colors.white,
                  indicatorWeight: 1,
                  // indicatorColor: blackTheme,
                  unselectedLabelColor: Colors.grey,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor),
                  // labelColor: purewhiteTheme,
                  tabs: <Widget>[
                    new Tab(
                      text: 'Details',
                    ),
                    new Tab(
                      text: 'PM Backlog',
                    ),
                    new Tab(
                      text: 'Status History',
                    ),
                    // new Tab(
                    //   text: 'Transfer History',
                    // ),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.grey[200],
            body: BlocConsumer<AssetTrackingCubit, AssetTrackingState>(
              builder: (context, state) {
                if (state is AssetTrackigInProgress) {
                  return LoadingIndicator();
                } else if (state is AssetTrackingLoadDetail) {
                  // byte = state.photo;
                  installbasestatus = state.statushistory;
                  installbasetrfhistory = state.trfhistory;
                  return tabBar(
                      this.byte, installbasestatus!, installbasetrfhistory!);
                } else if (state is PMBacklogSuccess) {
                  pmbacklog = state.pmbacklog;
                  print(pmbacklog);
                  return tabBar(
                      byte, installbasestatus!, installbasetrfhistory!);
                } else {
                  return tabBar(
                      byte, installbasestatus!, installbasetrfhistory!);
                }
              },
              listener: (context, state) {},
            )),
      ),
    );
  }

  Widget tabBar(var byte, List<InstallBaseStatus> installbasestatus,
      List<InstallBaseTransfer> trfhistory) {
    return TabBarView(
      children: <Widget>[
        new tab_details.DetailsTabs(dataX: data, byte: byte),
        new tab_pmbacklog.PMBacklogTabs(data: pmbacklog!),
        new tab_statushistory.StatusHistoryTab(data: installbasestatus),
        // new tab_transferhistory.TransferHistoryTab(
        //   data: trfhistory,
        // ),
      ],
    );
  }
}
