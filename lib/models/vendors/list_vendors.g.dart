// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_vendors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListVendors _$ListVendorsFromJson(Map<String, dynamic> json) {
  return ListVendors(
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : Vendor.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ListVendorsToJson(ListVendors instance) =>
    <String, dynamic>{
      'data': instance.listOfData,
    };
