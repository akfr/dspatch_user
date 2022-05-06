// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addOnChoices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOnChoices _$AddOnChoicesFromJson(Map<String, dynamic> json) {
  return AddOnChoices(
    json['id'] as int,
    json['title'] == null
        ? null
        : Title.fromJson(json['title'] as Map<String, dynamic>),
    json['price'] as int,
    json['product_addon_group_id'] as int,
    json['created_at'] as String,
    json['updated_at'] as String,
  );
}

Map<String, dynamic> _$AddOnChoicesToJson(AddOnChoices instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'product_addon_group_id': instance.productAddonGroupId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
