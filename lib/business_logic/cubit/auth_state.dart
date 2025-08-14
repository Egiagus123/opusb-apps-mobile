part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthAuthenticationSuccess extends AuthState {
  final AuthResponse response;

  AuthAuthenticationSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class AuthAuthorizationSuccess extends AuthState {
  final AuthResponse response;

  AuthAuthorizationSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class AuthAutoLoginSuccess extends AuthState {}

class AuthAuthorizationDataLoaded extends AuthState {
  final int clientId;
  final int roleId;
  final int orgId;
  final List<IdNamePair> roles;
  final List<IdNamePair> orgs;

  AuthAuthorizationDataLoaded(
      {required this.clientId,
      required this.roleId,
      required this.roles,
      required this.orgId,
      required this.orgs});

  @override
  List<Object> get props => [clientId, roleId, roles, orgId, orgs];
}

class AuthAuthenticationFailure extends AuthState {}

class AuthAuthorizationFailure extends AuthState {}

class AuthInProgress extends AuthState {}

class AuthHostNotSetFailure extends AuthState {}

class AuthLogoutSuccess extends AuthState {}

class AuthIsScanValue extends AuthState {
  final bool value;

  AuthIsScanValue({required this.value});

  @override
  List<Object> get props => [value];
}

class AuthMinVersionFailure extends AuthState {
  final String message;

  AuthMinVersionFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}
