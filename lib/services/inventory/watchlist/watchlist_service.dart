import 'package:apps_mobile/business_logic/models/inventory/watchlist.dart';

abstract class WatchlistService {
  Future<List<WatchlistModel>> getWatchlistData();
}
