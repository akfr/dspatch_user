// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transaction_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletTransactionMeta _$WalletTransactionMetaFromJson(
    Map<String, dynamic> json) {
  return WalletTransactionMeta(
    json['source_id'] as int,
    (json['source_amount'] as num)?.toDouble(),
    json['source'] as String,
    json['source_payment_type'] as String,
    json['description'] as String,
    json['type'] as String,
    json['source_data'],
    json['source_meta_courier_type'] as String,
  );
}

Map<String, dynamic> _$WalletTransactionMetaToJson(
        WalletTransactionMeta instance) =>
    <String, dynamic>{
      'source_id': instance.source_id,
      'source_amount': instance.source_amount,
      'source': instance.source,
      'source_payment_type': instance.source_payment_type,
      'description': instance.description,
      'type': instance.type,
      'source_data': instance.source_data,
      'source_meta_courier_type': instance.source_meta_courier_type,
    };
