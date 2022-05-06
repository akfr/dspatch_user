// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListProducts _$ListProductsFromJson(Map<String, dynamic> json) {
  return ListProducts(
    (json['products'] as List)
        ?.map((e) =>
            e == null ? null : Products.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ListProductsToJson(ListProducts instance) =>
    <String, dynamic>{
      'products': instance.products,
    };
