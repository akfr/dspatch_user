// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListOrder _$ListOrderFromJson(Map<String, dynamic> json) {
  return ListOrder(
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : OrderData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['links'] == null
        ? null
        : Links.fromJson(json['links'] as Map<String, dynamic>),
    json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ListOrderToJson(ListOrder instance) => <String, dynamic>{
      'data': instance.listOfOrder,
      'links': instance.links,
      'meta': instance.meta,
    };
