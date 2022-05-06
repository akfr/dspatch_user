// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageData _$ImageDataFromJson(Map<String, dynamic> json) {
  return ImageData(
    json['default'] as String,
    json['thumb'] as String,
    json['small'] as String,
    json['medium'] as String,
    json['large'] as String,
  );
}

Map<String, dynamic> _$ImageDataToJson(ImageData instance) => <String, dynamic>{
      'default': instance.defaultImage,
      'thumb': instance.thumb,
      'small': instance.small,
      'medium': instance.medium,
      'large': instance.large,
    };
