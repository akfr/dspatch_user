// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_vendorcategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListVendorCategory _$ListVendorCategoryFromJson(Map<String, dynamic> json) {
  return ListVendorCategory(
    (json['categories'] as List)
        ?.map((e) => e == null
            ? null
            : VendorCategory.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ListVendorCategoryToJson(ListVendorCategory instance) =>
    <String, dynamic>{
      'categories': instance.categories,
    };
