// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInformation _$UserInformationFromJson(Map<String, dynamic> json) {
  return UserInformation(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    image_url: json['image_url'] as String,
    mobileNumber: json['mobile_number'] as String,
    mobileVerified: json['mobile_verified'] as int,
    active: json['active'] as int,
    language: json['language'] as String,
    notification: json['notification'],
    meta: json['meta'],
    mediaurls: json['mediaurls'] == null
        ? null
        : MediaLibrary.fromJson(json['mediaurls'] as Map<String, dynamic>),
    rememberToken: json['remember_token'],
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
  );
}

Map<String, dynamic> _$UserInformationToJson(UserInformation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'image_url': instance.image_url,
      'mobile_number': instance.mobileNumber,
      'mobile_verified': instance.mobileVerified,
      'active': instance.active,
      'language': instance.language,
      'notification': instance.notification,
      'meta': instance.meta,
      'mediaurls': instance.mediaurls,
      'remember_token': instance.rememberToken,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
