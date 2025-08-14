import 'package:equatable/equatable.dart';

class ServerError extends Equatable {
  final String title;
  final int status;
  final String detail;

  ServerError(
      {required this.title, required this.status, required this.detail});

  @override
  List<Object> get props => [title, status, detail];
}
