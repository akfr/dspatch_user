// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendorcategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorCategory _$VendorCategoryFromJson(Map<String, dynamic> json) {
  return VendorCategory(
    json['id'] as int,
    json['slug'] as String,
    json['title'] as String,
    json['meta'] == null
        ? null
        : VendorMeta.fromJson(json['meta'] as Map<String, dynamic>),
    json['sort_order'] as int,
    json['mediaurls'] == null
        ? null
        : ListVendorImage.fromJson(json['mediaurls'] as Map<String, dynamic>),
    json['parent_id'],
  );
}

Map<String, dynamic> _$VendorCategoryToJson(VendorCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'title': instance.title,
      'meta': instance.meta,
      'sort_order': instance.sortOrder,
      'mediaurls': instance.mediaurls,
      'parent_id': instance.parentId,
    };
