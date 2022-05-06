// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request_login_social.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRequestLoginSocial _$AuthRequestLoginSocialFromJson(
    Map<String, dynamic> json) {
  return AuthRequestLoginSocial(
    json['platform'] as String,
    json['token'] as String,
    json['os'] as String,
  )..role = json['role'] as String;
}

Map<String, dynamic> _$AuthRequestLoginSocialToJson(
        AuthRequestLoginSocial instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'token': instance.token,
      'os': instance.os,
      'role': instance.role,
    };
