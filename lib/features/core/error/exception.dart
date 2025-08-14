import 'package:apps_mobile/features/core/constant/auth_constant.dart';

class BadRequestException implements Exception {
  final String message;

  BadRequestException([this.message = 'Bad Request']);
}

class ClientException implements Exception {
  final String message;

  ClientException([this.message = 'Client Exception']);
}

class ServerException implements Exception {
  final String message;

  ServerException([this.message = 'Server Error']);
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException([this.message = AuthConstant.unauthorizedUserMessage]);
}

class AccessDeniedException implements Exception {
  final String message;

  AccessDeniedException([this.message = 'Access Denied']);
}

class DocumentNotFoundException implements Exception {
  final String message;

  DocumentNotFoundException([this.message = 'Document Not Found']);
}

class WrongUsernamePasswordException implements Exception {
  final String message;

  WrongUsernamePasswordException(
      [this.message = AuthConstant.invalidCredentialsMessage]);
}
