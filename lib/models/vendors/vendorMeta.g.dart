// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendorMeta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorMeta _$VendorMetaFromJson(Map<String, dynamic> json) {
  return VendorMeta(
    json['scope'] as String,
    json['store_name'] as String,
  );
}

Map<String, dynamic> _$VendorMetaToJson(VendorMeta instance) =>
    <String, dynamic>{
      'scope': instance.scope,
      'store_name': instance.storeName,
    };
