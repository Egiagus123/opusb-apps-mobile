part of 'asset_tracking_cubit.dart';

abstract class AssetTrackingState extends Equatable {
  const AssetTrackingState();

  @override
  List<Object> get props => [];
}

class AssetTrackingInitial extends AssetTrackingState {}

class AssetTrackingLoadInitial extends AssetTrackingState {
  final List<AssetTrackingLocation> loc;
  final List<AssetTrackingStatus> status;

  AssetTrackingLoadInitial({required this.loc, required this.status});

  @override
  List<Object> get props => [loc, status];
}

class AssetTrackingLoadInstallBase extends AssetTrackingState {
  final List<InstallBaseModel> installBase;

  AssetTrackingLoadInstallBase({required this.installBase});

  @override
  List<Object> get props => [installBase];
}

class AssetTrackingLoadDetail extends AssetTrackingState {
  final photo;
  final List<InstallBaseStatus> statushistory;
  final List<InstallBaseTransfer> trfhistory;
  AssetTrackingLoadDetail(
      {this.photo, required this.statushistory, required this.trfhistory});

  @override
  List<Object> get props => [photo, statushistory, trfhistory];
}

class AssetTrackigLoadSuccess extends AssetTrackingState {}

class AssetTrackingStateFailure extends AssetTrackingState {
  final String message;

  AssetTrackingStateFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class AssetTrackigInProgress extends AssetTrackingState {}

class PMBacklogSuccess extends AssetTrackingState {
  final List<PMBacklogModel> pmbacklog;

  const PMBacklogSuccess({required this.pmbacklog});

  @override
  List<Object> get props => [PMBacklogSuccess];
}

class PMBacklogFailure extends AssetTrackingState {
  final String message;

  const PMBacklogFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class ImageEquipmentSuccess extends AssetTrackingState {
  final List<ImageEquipment> imageequipment;

  const ImageEquipmentSuccess({required this.imageequipment});

  @override
  List<Object> get props => [ImageEquipmentSuccess];
}

class ImageEquipmentFailure extends AssetTrackingState {
  final String message;

  const ImageEquipmentFailure({required this.message});

  @override
  List<Object> get props => [message];
}
