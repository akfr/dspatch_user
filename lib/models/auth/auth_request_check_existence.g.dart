// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request_check_existence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRequestCheckExistence _$AuthRequestCheckExistenceFromJson(
    Map<String, dynamic> json) {
  return AuthRequestCheckExistence(
    json['mobile_number'] as String,
  )..role = json['role'] as String;
}

Map<String, dynamic> _$AuthRequestCheckExistenceToJson(
        AuthRequestCheckExistence instance) =>
    <String, dynamic>{
      'mobile_number': instance.mobile_number,
      'role': instance.role,
    };
