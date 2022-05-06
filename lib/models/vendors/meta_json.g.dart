// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meta _$MetaFromJson(Map<String, dynamic> json) {
  return Meta(
    json['current_page'] as int,
    json['from'] as int,
    json['last_page'] as int,
    json['path'] as String,
    json['per_page'] as int,
    json['to'] as int,
    json['total'] as int,
  );
}

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'current_page': instance.currentPage,
      'from': instance.from,
      'last_page': instance.lastPage,
      'path': instance.path,
      'per_page': instance.perPage,
      'to': instance.to,
      'total': instance.total,
    };
