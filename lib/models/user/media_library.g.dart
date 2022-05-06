// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_library.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaLibrary _$MediaLibraryFromJson(Map<String, dynamic> json) {
  return MediaLibrary(
    (json['images'] as List)
        ?.map((e) =>
            e == null ? null : ImageData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MediaLibraryToJson(MediaLibrary instance) =>
    <String, dynamic>{
      'images': instance.images,
    };
