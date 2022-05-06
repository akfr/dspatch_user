// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addOnGroups.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOnGroups _$AddOnGroupsFromJson(Map<String, dynamic> json) {
  return AddOnGroups(
    json['id'] as int,
    json['title'] == null
        ? null
        : Title.fromJson(json['title'] as Map<String, dynamic>),
    json['max_choice'] as int,
    json['min_choice'] as int,
    json['product_id'] as int,
    (json['addon_choices'] as List)
        ?.map((e) =>
            e == null ? null : AddOnChoices.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AddOnGroupsToJson(AddOnGroups instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'max_choice': instance.maxChoice,
      'min_choice': instance.minChoice,
      'product_id': instance.productId,
      'addon_choices': instance.addOnChoices,
    };
