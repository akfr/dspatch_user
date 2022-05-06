// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'links_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Links _$LinksFromJson(Map<String, dynamic> json) {
  return Links(
    json['first'] as String,
    json['last'] as String,
    json['prev'],
    json['next'],
  );
}

Map<String, dynamic> _$LinksToJson(Links instance) => <String, dynamic>{
      'first': instance.first,
      'last': instance.last,
      'prev': instance.prev,
      'next': instance.next,
    };
