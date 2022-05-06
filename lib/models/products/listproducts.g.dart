// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listproducts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListProduct _$ListProductFromJson(Map<String, dynamic> json) {
  return ListProduct(
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : ProductById.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ListProductToJson(ListProduct instance) =>
    <String, dynamic>{
      'data': instance.listOfData,
    };
