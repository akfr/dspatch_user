import 'package:dspatch_user/models/order/post/list_products.dart';
import 'package:json_annotation/json_annotation.dart';

part 'postOrder.g.dart';

@JsonSerializable()
class PostOrder {
  @JsonKey(name: 'address_id')
  final int addressId;
  @JsonKey(name: 'payment_method_slug')
  final String paymentMethodSlug;
  final ListProducts products;

  PostOrder(this.addressId, this.paymentMethodSlug, this.products);

  factory PostOrder.fromJson(Map<String, dynamic> json) =>
      _$PostOrderFromJson(json);

  Map<String, dynamic> toJson() => _$PostOrderToJson(this);
}
