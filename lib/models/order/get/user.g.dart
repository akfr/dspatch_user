// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'] as int,
    json['name'] as String,
    json['email'] as String,
    json['mobile_number'] as String,
    json['mobile_verified'] as int,
    json['active'] as int,
    json['language'] as String,
    json['notification'],
    json['meta'],
    json['mediaurls'] == null
        ? null
        : ListVendorImage.fromJson(json['mediaurls'] as Map<String, dynamic>),
    json['balance'] as int,
    json['wallet'] == null
        ? null
        : Wallet.fromJson(json['wallet'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'mobile_number': instance.mobileNumber,
      'mobile_verified': instance.mobileVerified,
      'active': instance.active,
      'language': instance.language,
      'notification': instance.notification,
      'meta': instance.meta,
      'mediaurls': instance.mediaurls,
      'balance': instance.balance,
      'wallet': instance.wallet,
    };
