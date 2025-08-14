// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) {
  return News(
    title: json['title'] == null
        ? Rendered.defaultReference()
        : Rendered.fromJson(json['title'] as Map<String, dynamic>),
    img: json['featured_media_src_url'] as String,
    link: json['link'] as String,
  );
}

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'title': instance.title?.toJson(),
      'link': instance.link,
      'featured_media_src_url': instance.img,
    };
