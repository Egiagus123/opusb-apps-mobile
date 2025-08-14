part of 'downloaddata_cubit.dart';

abstract class DownloadDataState extends Equatable {
  const DownloadDataState();

  @override
  List<Object> get props => [];
}

class DownloadDataLoadData extends DownloadDataState {
  final List<ListDataMovReqHeader> assetRequestHeader;
  final List<ListDataMovReqLine> assetRequestLine;
  final int saveline;
  DownloadDataLoadData(
      {required this.assetRequestHeader,
      required this.assetRequestLine,
      required this.saveline});
  @override
  List<Object> get props => [assetRequestHeader, assetRequestLine, saveline];
}

class DownloadDataInitial extends DownloadDataState {}

class SavingDataToLocal extends DownloadDataState {}

class DownloadinProgress extends DownloadDataState {}

class DownloadDataLoadSuccess extends DownloadDataState {
  final List<News> news;

  DownloadDataLoadSuccess({required this.news});

  @override
  List<Object> get props => [news];
}

class DownloadDataSaveSuccess extends DownloadDataState {}

class DownloadDataStateFailure extends DownloadDataState {
  final String message;

  DownloadDataStateFailure({required this.message});

  @override
  List<Object> get props => [message];
}
