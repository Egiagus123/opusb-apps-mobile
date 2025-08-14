// import 'package:eam_mobile/business_logic/models/rendered.dart';
import 'package:apps_mobile/business_logic/models/reference.dart';
import 'package:apps_mobile/business_logic/models/rendered.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'news.g.dart';

@JsonSerializable(explicitToJson: true)
class News extends Equatable {
  final Rendered title;

  final String link;

  @JsonKey(name: 'featured_media_src_url')
  final String img;

  News({
    required this.title,
    required this.img,
    required this.link,
  });

  @override
  List<Object> get props => [title, img, link];
  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsToJson(this);
}
