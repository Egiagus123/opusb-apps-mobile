import 'package:apps_mobile/business_logic/cubit/asset_trfrcv_cubit.dart';
import 'package:apps_mobile/business_logic/models/assetrequestwindow_model.dart';
import 'package:apps_mobile/ui/screens/features/assettrf/pages/assettfr.dart';
import 'package:apps_mobile/widgets/date_text.dart';
import 'package:apps_mobile/widgets/dialog_util.dart';
import 'package:apps_mobile/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetTrf extends StatefulWidget {
  @override
  _AssetTrfState createState() => _AssetTrfState();
}

class _AssetTrfState extends State<AssetTrf> {
  late AssetTransferReceivingCubit assetReqCubit;
  List<AssetRequestModel> assetRequest = [];

  void backButtonDrawer() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => buildAlertDialog(
        ctx,
        title: 'Warning',
        content: 'Do you really want to exit?',
        cancelText: 'No',
        cancelCallback: () => Navigator.of(ctx).pop(false),
        proceedText: 'Yes',
        proceedCallback: () {
          Navigator.pop(ctx, true);
          Navigator.pop(ctx, true);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    assetReqCubit = BlocProvider.of<AssetTransferReceivingCubit>(context);
    loadInitData();
  }

  Future<void> loadInitData() async {
    await assetReqCubit.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // here the desired height
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
            'Asset Transfer',
            style: TextStyle(
                fontFamily: 'Oswald',
                letterSpacing: 1,
                color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: BlocConsumer<AssetTransferReceivingCubit,
          AssetTransferReceivingState>(
        builder: (context, state) {
          if (state is AssetTransferReceivingInProgress) {
            return LoadingIndicator();
          } else if (state is AssetTransferLoadDataHeader) {
            assetRequest = state.assetRequest;
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildBody(),
          );
        },
        listener: (context, state) {},
      ),
    );
  }

  Widget buildBody() {
    return RefreshIndicator(
      onRefresh: () async => await loadInitData(),
      child: assetRequest.isEmpty
          ? ListView(
              children: [
                SizedBox(height: 100),
                Center(child: Text('No data available')),
              ],
            )
          : ListView.builder(
              itemCount: assetRequest.length,
              itemBuilder: (context, index) {
                final asset = assetRequest[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => BlocProvider(
                          create: (_) => AssetTransferReceivingCubit(),
                          child: AssetTrfDetail(asset),
                        ),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.inventory_2,
                                  color: Theme.of(context).primaryColor),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Movement Request: ${asset.documentNo}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Table(
                            columnWidths: {
                              0: IntrinsicColumnWidth(),
                              1: FlexColumnWidth(),
                            },
                            children: [
                              TableRow(children: [
                                Text('Doc Date'),
                                Text(' : ${asset.dateDoc}'),
                              ]),
                              TableRow(children: [
                                Text('Transfer Date'),
                                DateText(
                                    freetext: ' : ',
                                    dateTime: asset.dateRequired),
                              ]),
                              TableRow(children: [
                                Text('Location'),
                                Text(' : ${asset.locator.identifier}'),
                              ]),
                              TableRow(children: [
                                Text('New Location'),
                                Text(' : ${asset.locatorTo?.identifier ?? ''}'),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
