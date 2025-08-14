part of 'setup_cubit.dart';

abstract class SetupState extends Equatable {
  const SetupState();

  @override
  List<Object> get props => [];
}

class SetupInitial extends SetupState {}

class SetupLoadInProgress extends SetupState {}

class SetupLoadSuccess extends SetupState {
  final String host;

  SetupLoadSuccess({required this.host});

  @override
  List<Object> get props => [host];
}

class SetupSaveSuccess extends SetupState {}

class SetupStateFailure extends SetupState {
  final String message;

  SetupStateFailure({required this.message});

  @override
  List<Object> get props => [message];
}
