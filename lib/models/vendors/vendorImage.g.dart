// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendorImage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorImage _$VendorImageFromJson(Map<String, dynamic> json) {
  return VendorImage(
    json['default'] as String,
    json['thumb'] as String,
  );
}

Map<String, dynamic> _$VendorImageToJson(VendorImage instance) =>
    <String, dynamic>{
      'default': instance.defaultImage,
      'thumb': instance.thumbImage,
    };
