// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_custom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaCustom _$MetaCustomFromJson(Map<String, dynamic> json) {
  return MetaCustom(
    lwh: json['lwh'] as String,
    courier_type: json['courier_type'] as String,
    dynamicOrderCategory: json['order_category'],
    foodItems: (json['foodItems'] as List)
        ?.map((e) =>
            e == null ? null : FoodItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    signatureRequired: json['signatureRequired'] as bool,
    notes_url: json['notes_url'] as String,
    dynamicFrangible: json['frangible'],
    dynamicWeight: json['weight'],
  )
    ..estimated_time_pickup = json['estimated_time_pickup'] as String
    ..estimated_time_delivery = json['estimated_time_delivery'] as String;
}

Map<String, dynamic> _$MetaCustomToJson(MetaCustom instance) =>
    <String, dynamic>{
      'lwh': instance.lwh,
      'courier_type': instance.courier_type,
      'foodItems': instance.foodItems,
      'signatureRequired': instance.signatureRequired,
      'notes_url': instance.notes_url,
      'frangible': instance.dynamicFrangible,
      'weight': instance.dynamicWeight,
      'order_category': instance.dynamicOrderCategory,
      'estimated_time_pickup': instance.estimated_time_pickup,
      'estimated_time_delivery': instance.estimated_time_delivery,
    };
