import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/base_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';

class UOMConvertion extends BaseEntity {
  final double? multiplyRate;
  final double? divideRate;
  @JsonKey(name: 'C_UOM_To_ID')
  final ReferenceEntity? uomToID;

  @JsonKey(name: 'M_Product_ID')
  final ReferenceEntity? product;
  UOMConvertion({
    required int id,
    required ReferenceEntity client,
    required ReferenceEntity organization,
    this.uomToID,
    this.divideRate,
    this.multiplyRate,
    this.product,
  }) : super(id: id, client: client, organization: organization);
}
