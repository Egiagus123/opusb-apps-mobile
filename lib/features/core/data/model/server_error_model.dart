import 'package:json_annotation/json_annotation.dart';
import 'package:apps_mobile/features/core/domain/entity/server_error.dart';

part 'server_error_model.g.dart';

@JsonSerializable()
class ServerErrorModel extends ServerError {
  ServerErrorModel(
      {required String title, required int status, required String detail})
      : super(title: title, status: status, detail: detail);

  factory ServerErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ServerErrorModelFromJson(json);
  Map<String, dynamic> toJson() => _$ServerErrorModelToJson(this);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
