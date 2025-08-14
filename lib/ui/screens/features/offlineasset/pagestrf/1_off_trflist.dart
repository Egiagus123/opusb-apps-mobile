import 'package:apps_mobile/business_logic/utils/color.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/database.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/local_database/tablemovementreq_header.dart';
import 'package:apps_mobile/ui/screens/features/offlineasset/utils/localmodels/list_header.dart';
import 'package:apps_mobile/widgets/dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '2_off_trfdetail.dart';

class OfflineTransferList extends StatefulWidget {
  @override
  _OfflineTransferListState createState() => _OfflineTransferListState();
}

class _OfflineTransferListState extends State<OfflineTransferList> {
  late List<ListDataMovReqHeader> listData;
  DatabaseHelper helper = DatabaseHelper();
  QueryTableHeader query = QueryTableHeader();

  @override
  Widget build(BuildContext context) {
    if (listData == null) {
      listData = [];
      updateListView();
    }
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

    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => backButtonDrawer(),
            ),
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Asset Transfer List (Offline)',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Oswald',
                  letterSpacing: 1,
                  color: purewhiteTheme),
            ),
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: buildbody());
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
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                AssetTrfOffDetail(listData[index], null)));
                  },
                  child: Card(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Movement Request : ${listData[index].docNo}',
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
                                Text('Doc Date'),
                                Text('Transfer Date'),
                                Text('Location'),
                                Text('New Location'),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(' : ${listData[index].dateDocument}'),
                                Text(' : ${listData[index].dateReq}'),
                                Text(' : ${listData[index].locationfromName}'),
                                listData[index].locatorNewID == null
                                    ? Text(' : ')
                                    : Text(
                                        ' : ${listData[index].locationToName}'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })),
    ]);
  }

  void updateListView() {
    final Future<Database> dbfuture = helper.initializedDatabase();
    dbfuture.then((database) {
      Future<List<ListDataMovReqHeader>> listDataFuture = query.fetchdatalist();

      listDataFuture.then((listData) {
        setState(() {
          this.listData = listData;
        });
      });
    });
  }
}
