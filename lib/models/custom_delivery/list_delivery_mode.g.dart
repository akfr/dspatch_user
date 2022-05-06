// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_delivery_mode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListDeliveryMode _$ListDeliveryModeFromJson(Map<String, dynamic> json) {
  return ListDeliveryMode(
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : DeliveryMode.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ListDeliveryModeToJson(ListDeliveryMode instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
