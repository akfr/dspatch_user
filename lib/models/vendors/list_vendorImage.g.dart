// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_vendorImage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListVendorImage _$ListVendorImageFromJson(Map<String, dynamic> json) {
  return ListVendorImage(
    (json['images'] as List)
        ?.map((e) =>
            e == null ? null : VendorImage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ListVendorImageToJson(ListVendorImage instance) =>
    <String, dynamic>{
      'images': instance.images,
    };
