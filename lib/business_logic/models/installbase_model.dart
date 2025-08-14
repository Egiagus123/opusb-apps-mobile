import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'installbase_model.g.dart';

@JsonSerializable()
class InstallBaseModel extends Equatable {
  final int id;

  final String documentNo;

  final String dateDisposed;

  @JsonKey(name: 'Effective_Date')
  final String effectivedate;

  @JsonKey(name: 'A_Asset_ID')
  final Reference asset;

  final String serNo;

  final Reference status;
  final String description;

  @JsonKey(name: 'M_Locator_ID')
  final Reference locator;

  final Reference bhpMInstallBaseTypeID;

  final num qtyEntered;

  InstallBaseModel(
      {required this.id,
      required this.documentNo,
      required this.dateDisposed,
      required this.effectivedate,
      required this.serNo,
      required this.asset,
      required this.status,
      required this.description,
      required this.locator,
      required this.qtyEntered,
      required this.bhpMInstallBaseTypeID});

  factory InstallBaseModel.fromJson(Map<String, dynamic> json) =>
      _$InstallBaseModelFromJson(json);
  Map<String, dynamic> toJson() => _$InstallBaseModelToJson(this);

  @override
  List<Object> get props => [
        id,
        dateDisposed,
        effectivedate,
        serNo,
        status,
        description,
        asset,
        locator,
        qtyEntered,
        documentNo
      ];

  @override
  String toString() {
    return 'InstallBaseModel[id: $id]';
  }
}
