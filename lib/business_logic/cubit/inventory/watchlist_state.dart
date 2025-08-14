part of 'watchlist_cubit.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoadSuccess extends WatchlistState {
  final List<WatchlistModel> watchlist;

  WatchlistLoadSuccess({required this.watchlist});

  @override
  List<Object> get props => [watchlist];
}

class WatchlistStateFailure extends WatchlistState {
  final String message;

  WatchlistStateFailure({required this.message});

  @override
  List<Object> get props => [message];
}
