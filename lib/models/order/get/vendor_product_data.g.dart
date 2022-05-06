// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorProductData _$VendorProductDataFromJson(Map<String, dynamic> json) {
  return VendorProductData(
    json['id'] as int,
    json['title'] as String,
    json['detail'] as String,
    json['meta'],
    json['price'] as int,
    json['owner'] as String,
    json['parent_id'],
    json['attribute_term_id'],
    json['mediaurls'] as List,
    json['createdAt'] as String,
    json['updatedAt'] as String,
  );
}

Map<String, dynamic> _$VendorProductDataToJson(VendorProductData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'detail': instance.detail,
      'meta': instance.meta,
      'price': instance.price,
      'owner': instance.owner,
      'parent_id': instance.parentId,
      'attribute_term_id': instance.attributeTermId,
      'mediaurls': instance.mediaurls,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
