import 'package:json_annotation/json_annotation.dart';

part 'wallet_transaction_meta.g.dart';

@JsonSerializable()
class WalletTransactionMeta {
  final int source_id;
  final double source_amount;
  final String source;
  final String source_payment_type;
  final String description;
  final String type; //cash_collected or earnings
  final dynamic source_data;
  final String source_meta_courier_type;

  WalletTransactionMeta(
      this.source_id,
      this.source_amount,
      this.source,
      this.source_payment_type,
      this.description,
      this.type,
      this.source_data,
      this.source_meta_courier_type);

  /// A necessary factory constructor for creating a new WalletTransactionMeta instance
  /// from a map. Pass the map to the generated `_$WalletTransactionMetaFromJson()` constructor.
  /// The constructor is named after the source class, in this case, WalletTransactionMeta.
  factory WalletTransactionMeta.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionMetaFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$WalletTransactionMetaToJson`.
  Map<String, dynamic> toJson() => _$WalletTransactionMetaToJson(this);
}
