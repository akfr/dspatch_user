// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productsById.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductById _$ProductByIdFromJson(Map<String, dynamic> json) {
  return ProductById(
    json['id'] as int,
    json['title'] as String,
    json['detail'] as String,
    json['meta'],
    json['price'] as int,
    json['owner'] as String,
    json['parent_id'],
    json['attribute_term_id'],
    json['created_at'] as String,
    json['updated_at'] as String,
    (json['addon_groups'] as List)
        ?.map((e) =>
            e == null ? null : AddOnGroups.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['categories'] as List)
        ?.map((e) => e == null
            ? null
            : VendorCategory.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['vendor_product'] as List)
        ?.map((e) => e == null
            ? null
            : VendorProduct.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['mediaurls'] == null
        ? null
        : ListVendorImage.fromJson(json['mediaurls'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProductByIdToJson(ProductById instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'detail': instance.detail,
      'meta': instance.meta,
      'price': instance.price,
      'owner': instance.owner,
      'parent_id': instance.parentId,
      'attribute_term_id': instance.attributeTermId,
      'mediaurls': instance.mediaUrls,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'addon_groups': instance.addOnGroups,
      'categories': instance.categories,
      'vendor_product': instance.vendorProduct,
    };
