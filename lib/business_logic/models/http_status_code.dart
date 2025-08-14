import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'http_status_code.g.dart';

@JsonSerializable()
class HttpStatusCode {
  final int status;
  final String title;
  final String detail;

  HttpStatusCode({
    required this.status,
    required this.title,
    required this.detail,
  });

  factory HttpStatusCode.fromJson(Map<String, dynamic> json) =>
      _$HttpStatusCodeFromJson(json);

  Map<String, dynamic> toJson() => _$HttpStatusCodeToJson(this);

  @override
  String toString() {
    return 'HttpStatusCode[status: $status, title: $title, detail: $detail]';
  }
}
