part of 'asset_offlne_cubit.dart';

abstract class AssetOfflineState extends Equatable {
  const AssetOfflineState();

  @override
  List<Object> get props => [];
}

class AssetOfflineInitial extends AssetOfflineState {}

class AssetloadDataDBState extends AssetOfflineState {
  final List<ToolsTrfHeader> data;

  AssetloadDataDBState({required this.data});

  @override
  List<Object> get props => [data];
}

class AssetOfflinePushSubmitted extends AssetOfflineState {
  final ToolsTrfHeader data;

  AssetOfflinePushSubmitted({required this.data});

  @override
  List<Object> get props => [data];
}

class AssetOfflinePushSubmittedFailure extends AssetOfflineState {
  final String message;

  AssetOfflinePushSubmittedFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class AssetOfflineInProgress extends AssetOfflineState {}
