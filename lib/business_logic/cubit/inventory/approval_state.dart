part of 'approval_cubit.dart';

abstract class ApprovalState extends Equatable {
  const ApprovalState();

  @override
  List<Object> get props => [];
}

class ApprovalInitial extends ApprovalState {}

class ApprovalGetListInProgress extends ApprovalState {}

class ApprovalGetListSuccess extends ApprovalState {
  final List<ApprovalDoc> approvalDocs;
  final List<UserData> userData;

  ApprovalGetListSuccess({required this.approvalDocs, required this.userData});

  @override
  List<Object> get props => [approvalDocs];
}

class GetUserData extends ApprovalState {
  final List<UserData> userData;

  GetUserData({required this.userData});

  @override
  List<Object> get props => [userData];
}

class ApprovalProcessInProgress extends ApprovalState {}

class ApprovalGetAttchProcessInProgress extends ApprovalState {}

class ApprovalProcessSuccess extends ApprovalState {
  final String message;

  ApprovalProcessSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ApprovalGetPrintFormatInProgress extends ApprovalState {}

class ApprovalGetPrintFormatSuccess extends ApprovalState {
  final String printFormatPath;
  final ApprovalDoc approvalDoc;

  ApprovalGetPrintFormatSuccess(
      {required this.printFormatPath, required this.approvalDoc});

  @override
  List<Object> get props => [printFormatPath, approvalDoc];
}

class ApprovalGetAttachSuccess extends ApprovalState {
  final String printFormatPath;
  final ApprovalDoc approvalDoc;

  ApprovalGetAttachSuccess(
      {required this.printFormatPath, required this.approvalDoc});

  @override
  List<Object> get props => [printFormatPath, approvalDoc];
}

class ApprovalGetOneSuccess extends ApprovalState {
  final ApprovalDoc approvalDoc;

  ApprovalGetOneSuccess({required this.approvalDoc});

  @override
  List<Object> get props => [approvalDoc];
}

class ApprovalFailure extends ApprovalState {
  final String message;

  ApprovalFailure({required this.message});

  @override
  List<Object> get props => [message];
}
