import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/base_entity.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';

class LocatorEntity extends BaseEntity {
  final String? x;
  final String? y;
  final String? z;
  final String? value;
  final int? priorityNo;
  final bool? defaultLocator;

  LocatorEntity(
      {@required int? id,
      @required ReferenceEntity? client,
      @required ReferenceEntity? organization,
      @required this.x,
      @required this.y,
      @required this.z,
      @required this.value,
      @required this.priorityNo,
      @required this.defaultLocator})
      : super(
            id: id!,
            client: client!,
            organization: organization!,
            props: [x, y, z, value, priorityNo, defaultLocator]);
}
