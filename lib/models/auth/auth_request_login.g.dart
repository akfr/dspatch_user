// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request_login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRequestLogin _$AuthRequestLoginFromJson(Map<String, dynamic> json) {
  return AuthRequestLogin(
    json['token'] as String,
  )..role = json['role'] as String;
}

Map<String, dynamic> _$AuthRequestLoginToJson(AuthRequestLogin instance) =>
    <String, dynamic>{
      'token': instance.token,
      'role': instance.role,
    };
