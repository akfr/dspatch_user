import 'package:json_annotation/json_annotation.dart';

import 'food_item.dart';

part 'meta_food.g.dart';

@JsonSerializable()
class MetaFood {
  final List<FoodItem> foodItems;

  @JsonKey(name: 'order_category')
  final String orderCategory;

  MetaFood(this.foodItems, this.orderCategory);

  factory MetaFood.fromJson(Map json) => _$MetaFoodFromJson(json);

  Map toJson() => _$MetaFoodToJson(this);
}
