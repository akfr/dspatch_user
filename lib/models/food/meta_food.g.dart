// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaFood _$MetaFoodFromJson(Map<String, dynamic> json) {
  return MetaFood(
    (json['foodItems'] as List)
        ?.map((e) =>
            e == null ? null : FoodItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['order_category'] as String,
  );
}

Map<String, dynamic> _$MetaFoodToJson(MetaFood instance) => <String, dynamic>{
      'foodItems': instance.foodItems,
      'order_category': instance.orderCategory,
    };
