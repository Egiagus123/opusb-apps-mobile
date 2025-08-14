import 'package:equatable/equatable.dart';

class CommonError extends Equatable {
  const CommonError();

  @override
  List<Object> get props => [];
}

class NoConnectionError extends CommonError {
  String get message => 'There is no Internet connection';
}

class ClientError extends CommonError {
  final String message;

  ClientError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ClientError { message: $message }';
}

class ServerError extends CommonError {
  final String message;

  ServerError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'ServerError { message: $message }';
}

class UnknownError extends CommonError {
  final String message;

  UnknownError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'UnknownError { message: $message }';
}
