part of 'assetaudit_cubit.dart';

abstract class AssetAuditState extends Equatable {
  const AssetAuditState();

  @override
  List<Object> get props => [];
}

class AssetAuditInitialBLOC extends AssetAuditState {}

class AssetAuditInProgress extends AssetAuditState {}

class AssetAuditLoadHeader extends AssetAuditState {
  final List<AssetAuditHeader> dataHeader;
  AssetAuditLoadHeader({required this.dataHeader});
  @override
  List<Object> get props => [dataHeader];
}

class AssetAuditDeleteSuccess extends AssetAuditState {
  final bool deleteSuccess;
  AssetAuditDeleteSuccess({required this.deleteSuccess});
  @override
  List<Object> get props => [deleteSuccess];
}

class AssetAuditGetLinesAudited extends AssetAuditState {
  final List<AssetAuditLines> dataLines;
  AssetAuditGetLinesAudited({required this.dataLines});
  @override
  List<Object> get props => [dataLines];
}

class AssetAuditLoadLineAndGetAuditStatus extends AssetAuditState {
  final List<AssetAuditLines> dataLines;
  final List<AssetAuditStatusModel> auditStatus;
  AssetAuditLoadLineAndGetAuditStatus(
      {required this.dataLines, required this.auditStatus});
  @override
  List<Object> get props => [dataLines, auditStatus];
}

class AssetAuditCreateLineAndGetAuditStatus extends AssetAuditState {
  final List<AssetModel> newLines;
  final List<AssetAuditStatusModel> auditStatus;
  AssetAuditCreateLineAndGetAuditStatus(
      {required this.newLines, required this.auditStatus});
  @override
  List<Object> get props => [newLines, auditStatus];
}

class AssetAuditStatus extends AssetAuditState {
  final List<AssetAuditStatusModel> statusList;
  AssetAuditStatus({required this.statusList});
  @override
  List<Object> get props => [statusList];
}

class ScanValue extends AssetAuditState {
  final String value;
  const ScanValue({required this.value});
  @override
  List<Object> get props => [value];
}

class ScanCancel extends AssetAuditState {
  final String message;

  ScanCancel({this.message = 'Scan canceled'});
}

class ChangePage extends AssetAuditState {}

class AssetAuditFailed extends AssetAuditState {
  final String message;
  AssetAuditFailed({required this.message});
  @override
  List<Object> get props => [message];
}

class AssetAuditLoadFailed extends AssetAuditState {
  final String message;
  AssetAuditLoadFailed({required this.message});
  @override
  List<Object> get props => [message];
}

class DeleteLine extends AssetAuditState {
  final bool success;
  DeleteLine({required this.success});
  @override
  List<Object> get props => [success];
}

class AssetAuditUpdateLine extends AssetAuditState {
  final bool updatedline;
  AssetAuditUpdateLine({required this.updatedline});
  @override
  List<Object> get props => [updatedline];
}

class AssetAuditScanCancel extends AssetAuditState {
  final String message;

  AssetAuditScanCancel({this.message = 'Scan canceled'});
}
