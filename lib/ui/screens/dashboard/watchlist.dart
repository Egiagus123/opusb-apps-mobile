// ignore_for_file: unnecessary_null_comparison

import 'package:apps_mobile/business_logic/models/recentitem.dart';
import 'package:apps_mobile/business_logic/utils/context.dart';
import 'package:flutter/material.dart';

class Watchlist extends StatefulWidget {
  @override
  _WatchlistState createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  // WatchlistCubit watchlistCubit;

  List<RecentItem> recentitemdata = [];

  @override
  void initState() {
    super.initState();
    // watchlistCubit = BlocProvider.of<WatchlistCubit>(context);
    // watchlistCubit.getWatchlistData();
    recentitemdata = Context().recentitem;
  }

  @override
  Widget build(BuildContext context) {
    // return BlocConsumer<WatchlistCubit, WatchlistState>(
    //   builder: (context, state) {
    //     if (state is WatchlistLoadSuccess) {
    //       var watchlist = state.watchlist;
    //       return _buildWatchlist(context, watchlist);
    //     } else {
    //       return Container();
    //     }
    //   },
    //   listener: (context, state) {},
    // );
    return _buildWatchlist(context);
  }

  Widget _buildWatchlist(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: recentitemdata.take(10).length,
          itemBuilder: (BuildContext context, int position) {
            return Card(
              elevation: 3,
              child: Column(
                children: [
                  ListTile(
                    dense: true,
                    // title: Text(wl.name),
                    // title: Text('Movement Waiting Approval'),
                    title: Text(
                      "${recentitemdata[position].name} : ${recentitemdata[position].cDoctypeid.identifier}",
                    ),
                    trailing: Text(
                      recentitemdata[position].bhpwoserviceid == null
                          ? recentitemdata[position]
                                  .bhpmeterreadingid
                                  .identifier ??
                              'N/A'
                          : recentitemdata[position]
                                  .bhpwoserviceid
                                  .identifier ??
                              'N/A',
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
