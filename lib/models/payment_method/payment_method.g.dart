// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) {
  return PaymentMethod(
    json['id'] as int,
    json['slug'] as String,
    json['title'] as String,
    json['enabled'] as int,
    json['type'] as String,
    json['meta'],
  );
}

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'enabled': instance.enabled,
      'type': instance.type,
      'meta': instance.dynamicMeta,
    };
