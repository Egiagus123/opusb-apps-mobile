import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:apps_mobile/features/core/domain/entity/reference_entity.dart';

class Warehouse extends Equatable {
  @JsonKey(name: 'M_InTransitLocator_ID')
  final ReferenceEntity inTransit;

  Warehouse({
    required this.inTransit,
  });

  @override
  List<Object> get props => [inTransit];
}
