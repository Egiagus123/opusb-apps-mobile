part of 'asset_trfrcv_cubit.dart';

abstract class AssetTransferReceivingState extends Equatable {
  const AssetTransferReceivingState();

  @override
  List<Object> get props => [];
}

class AssetTransferInitial extends AssetTransferReceivingState {}

class AssetTransferLoadDataHeader extends AssetTransferReceivingState {
  // final List<AssetRequest> assetTrfHeader;
  // final List<AssetRequestLine> assetTrfLine;

  // AssetTransferLoadData({this.assetTrfHeader, this.assetTrfLine});

  // @override
  // List<Object> get props => [assetTrfHeader, assetTrfLine];
  final List<AssetRequestModel> assetRequest;
  AssetTransferLoadDataHeader({required this.assetRequest});
  @override
  List<Object> get props => [assetRequest];
}

class AssetTransferLoadDataLine extends AssetTransferReceivingState {
  final List<AssetRequestLine> line;
  AssetTransferLoadDataLine({required this.line});
  @override
  List<Object> get props => [line];
}

class AssetLines extends AssetTransferReceivingState {
  final List<dynamic> line;
  AssetLines({required this.line});
  @override
  List<Object> get props => [line];
}

class AssetRcvDataState extends AssetTransferReceivingState {
  final List<AssetRcvData> assetRcvData;
  AssetRcvDataState({required this.assetRcvData});
  @override
  List<Object> get props => [assetRcvData];
}

class AssetRcvLine extends AssetTransferReceivingState {
  final AssetRcvData rcvData;
  AssetRcvLine({required this.rcvData});
  @override
  List<Object> get props => [rcvData];
}

class AssetSerno extends AssetTransferReceivingState {
  final AssetRequestLine line;
  AssetSerno({required this.line});
  @override
  List<Object> get props => [line];
}

class AssetNotFound extends AssetTransferReceivingState {
  final String message;

  AssetNotFound({required this.message});

  @override
  List<Object> get props => [message];
}

class AssetTransferLoadDetail extends AssetTransferReceivingState {
  final photo;
  final List<InstallBaseStatus> statushistory;
  final List<InstallBaseTransfer> trfhistory;
  AssetTransferLoadDetail(
      {this.photo, required this.statushistory, required this.trfhistory});

  @override
  List<Object> get props => [photo, statushistory, trfhistory];
}

// class AssetLocState extends AssetTransferReceivingState {
//   final List<AssetTrackingLocation> loc;
//   AssetLocState({
//     this.loc,
//   });
//   @override
//   List<Object> get props => [loc];
// }
class AssetLocState extends AssetTransferReceivingState {
  final List<AssetRcvData> loc;
  AssetLocState({
    required this.loc,
  });
  @override
  List<Object> get props => [loc];
}

class AssetTransferReceivingLoadSuccess extends AssetTransferReceivingState {}

class AssetTransferReceivingStateFailure extends AssetTransferReceivingState {
  final String message;

  AssetTransferReceivingStateFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class AssetTransferReceivingSubmitted extends AssetTransferReceivingState {
  final GenerateData data;

  AssetTransferReceivingSubmitted({required this.data});

  @override
  List<Object> get props => [data];
}

class AssetTransferReceivingInProgress extends AssetTransferReceivingState {}

class AssetTransferScanCancel extends AssetTransferReceivingState {
  final String message;

  AssetTransferScanCancel({this.message = 'Scan canceled'});
}
