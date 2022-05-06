// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerList _$BannerListFromJson(Map<String, dynamic> json) {
  return BannerList(
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : BannerData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['links'] == null
        ? null
        : Links.fromJson(json['links'] as Map<String, dynamic>),
    json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BannerListToJson(BannerList instance) =>
    <String, dynamic>{
      'data': instance.listOfBanner,
      'links': instance.links,
      'meta': instance.meta,
    };
