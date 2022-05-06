// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postaddress_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostAddress _$PostAddressFromJson(Map<String, dynamic> json) {
  return PostAddress(
    json['title'] as String,
    json['formatted_address'] as String,
    (json['longitude'] as num)?.toDouble(),
    (json['latitude'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$PostAddressToJson(PostAddress instance) =>
    <String, dynamic>{
      'title': instance.title,
      'formatted_address': instance.formattedAddress,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
