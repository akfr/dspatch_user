// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletTransaction _$WalletTransactionFromJson(Map<String, dynamic> json) {
  return WalletTransaction(
    json['id'] as int,
    (json['amount'] as num)?.toDouble(),
    json['type'] as String,
    json['meta'] == null || json['meta'] is List
        ? null
        : WalletTransactionMeta.fromJson(json['meta'] as Map<String, dynamic>),
    json['user'] == null
        ? null
        : UserInformation.fromJson(json['user'] as Map<String, dynamic>),
    json['created_at'] as String,
  );
}

Map<String, dynamic> _$WalletTransactionToJson(WalletTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'type': instance.type,
      'meta': instance.meta,
      'user': instance.user,
      'created_at': instance.created_at,
    };
