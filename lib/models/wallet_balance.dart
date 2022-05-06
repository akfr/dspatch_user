import 'package:json_annotation/json_annotation.dart';

part 'wallet_balance.g.dart';

@JsonSerializable()
class WalletBalance {
  final double balance;

  WalletBalance(this.balance);

  /// A necessary factory constructor for creating a new WalletBalance instance
  /// from a map. Pass the map to the generated `_$WalletBalanceFromJson()` constructor.
  /// The constructor is named after the source class, in this case, WalletBalance.
  factory WalletBalance.fromJson(Map<String, dynamic> json) =>
      _$WalletBalanceFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$WalletBalanceToJson`.
  Map<String, dynamic> toJson() => _$WalletBalanceToJson(this);
}
