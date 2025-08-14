import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'edittimeentry.g.dart';

@JsonSerializable()
class EditTimeEntry extends Equatable {
  // final int id;
  final String actualDate, description;
  final double qtyDelivered;

  EditTimeEntry(
      {required this.description,
      required this.qtyDelivered,
      required this.actualDate});

  factory EditTimeEntry.fromJson(Map<String, dynamic> json) =>
      _$EditTimeEntryFromJson(json);
  Map<String, dynamic> toJson() => _$EditTimeEntryToJson(this);

  @override
  List<Object> get props => [description];

  @override
  String toString() {
    return 'EditTimeEntry[description: $description]';
  }
}
