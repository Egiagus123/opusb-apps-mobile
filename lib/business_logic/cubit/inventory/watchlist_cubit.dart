import 'package:apps_mobile/business_logic/models/inventory/watchlist.dart';
import 'package:apps_mobile/business_logic/utils/logger.dart';
import 'package:apps_mobile/service_locator.dart';
import 'package:apps_mobile/services/inventory/watchlist/watchlist_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final log = getLogger('WatchlistCubit');
  WatchlistCubit() : super(WatchlistInitial());

  Future<void> getWatchlistData() async {
    log.i('getWatchlistData()');
    try {
      List<WatchlistModel> watchlist =
          await sl<WatchlistService>().getWatchlistData();
      emit(WatchlistLoadSuccess(watchlist: watchlist));
    } catch (e) {
      log.e('getWatchlistData error: $e');
      emit(WatchlistStateFailure(message: 'Failed getWatchlistData'));
    }
  }
}
