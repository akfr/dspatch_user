// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerData _$BannerDataFromJson(Map<String, dynamic> json) {
  return BannerData(
    json['id'] as int,
    json['title'] as String,
    json['title_translations'] == null
        ? null
        : TitleTranslations.fromJson(
            json['title_translations'] as Map<String, dynamic>),
    json['meta'] == null
        ? null
        : VendorMeta.fromJson(json['meta'] as Map<String, dynamic>),
    json['sort_order'] as int,
    json['mediaurls'] == null
        ? null
        : MediaLibrary.fromJson(json['mediaurls'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BannerDataToJson(BannerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'title_translations': instance.titleTranslations,
      'meta': instance.meta,
      'sort_order': instance.sortOrder,
      'mediaurls': instance.mediaurls,
    };
