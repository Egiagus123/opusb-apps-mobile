import 'package:apps_mobile/business_logic/models/inventory/watchlist.dart';
import 'package:apps_mobile/business_logic/utils/constants.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/inventory/watchlist/watchlist_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WatchlistServiceImpl implements WatchlistService {
  final Dio dio;
  WatchlistServiceImpl({required this.dio});

  @override
  Future<List<WatchlistModel>> getWatchlistData() async {
    final storage = sl<FlutterSecureStorage>();
    final clientId = await storage.read(key: AuthKey.clientId.toString());
    final roleId = await storage.read(key: AuthKey.roleId.toString());
    final userId = await storage.read(key: AuthKey.userId.toString());

    var query =
        'filter= ad_user_id=$userId and ad_role_id =$roleId and ad_client_id=$clientId';
    List<WatchlistModel> watchlist = <WatchlistModel>[];
    try {
      final response = await dio.get("/models/bhp_rv_watchlistmobile?$query");
      var data = (response.data as List);
      List<WatchlistModel> newListData =
          data.map((i) => WatchlistModel.fromJson(i)).toList();
      watchlist = newListData.reversed.toList();
    } on DioError catch (e) {
      throw e.error.toString();
    }
    return watchlist;
  }
}
