// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_mode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryMode _$DeliveryModeFromJson(Map<String, dynamic> json) {
  return DeliveryMode(
    json['id'] as int,
    json['title'] as String,
    json['title_translations'] == null
        ? null
        : TitleTranslations.fromJson(
            json['title_translations'] as Map<String, dynamic>),
    json['detail'] as String,
    json['detail_translations'] == null
        ? null
        : TitleTranslations.fromJson(
            json['detail_translations'] as Map<String, dynamic>),
    json['meta'],
    json['price'] as int,
    json['enabled'] as int,
  );
}

Map<String, dynamic> _$DeliveryModeToJson(DeliveryMode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'title_translations': instance.titleTranslations,
      'detail': instance.detail,
      'detail_translations': instance.detailTranslations,
      'meta': instance.meta,
      'price': instance.price,
      'enabled': instance.enabled,
    };
