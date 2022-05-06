// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request_register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRequestRegister _$AuthRequestRegisterFromJson(Map<String, dynamic> json) {
  return AuthRequestRegister(
    json['name'] as String,
    json['email'] as String,
    json['password'] as String,
    json['mobile_number'] as String,
    json['image_url'] as String,
  )..role = json['role'] as String;
}

Map<String, dynamic> _$AuthRequestRegisterToJson(
        AuthRequestRegister instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'mobile_number': instance.mobile_number,
      'image_url': instance.image_url,
      'role': instance.role,
    };
