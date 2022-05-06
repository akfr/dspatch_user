import 'package:dspatch_user/models/food/food_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meta_custom.g.dart';

@JsonSerializable()
class MetaCustom {
  //coming from customer app
  final String lwh;
  final String courier_type;
  final List<FoodItem> foodItems;
  final bool signatureRequired;
  final String notes_url;
  @JsonKey(name: 'frangible')
  final dynamic dynamicFrangible;
  @JsonKey(name: 'weight')
  final dynamic dynamicWeight;
  @JsonKey(name: 'order_category')
  final dynamic dynamicOrderCategory;

  //seting from delivery app
  String estimated_time_pickup;
  String estimated_time_delivery;

  MetaCustom(
      {this.lwh,
      this.courier_type,
      this.dynamicOrderCategory,
      this.foodItems,
      this.signatureRequired,
      this.notes_url,
      this.dynamicFrangible,
      this.dynamicWeight});

  bool get frangible => (dynamicFrangible != null && dynamicFrangible is bool)
      ? dynamicFrangible
      : (dynamicFrangible != null && dynamicFrangible is String)
          ? (dynamicFrangible as String).toLowerCase() == "true"
          : false;

  String get weight => (dynamicWeight != null && dynamicWeight is String)
      ? dynamicWeight
      : "$dynamicWeight";

  String get order_category =>
      dynamicOrderCategory != null && dynamicOrderCategory is String
          ? dynamicOrderCategory
          : "other";

  factory MetaCustom.fromJson(Map json) => _$MetaCustomFromJson(json);

  Map toJson() => _$MetaCustomToJson(this);

  static MetaCustom request(
      String lwh,
      String frangible,
      String selectedBoxType,
      String weight,
      String orderCategory,
      List<FoodItem> list) {
    return MetaCustom(
        lwh: lwh,
        dynamicFrangible: frangible,
        courier_type: selectedBoxType,
        dynamicWeight: weight,
        dynamicOrderCategory: orderCategory,
        foodItems: list);
  }
}
