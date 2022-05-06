import 'package:dspatch_user/models/payment_method/payment_method.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  final int id;
  @JsonKey(name: 'payable_id')
  final int payableId;

  @JsonKey(name: 'payer_id')
  final int payerId;

  final int amount;
  final String status;
  @JsonKey(name: 'payment_method')
  final PaymentMethod paymentMethod;

  Payment(this.id, this.payableId, this.amount, this.status, this.paymentMethod,
      this.payerId);

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
