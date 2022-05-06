import 'package:json_annotation/json_annotation.dart';

import 'vendor_product.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int id;
  final int quantity;
  final int total;
  final subtotal;
  @JsonKey(name: 'order_id')
  final int orderId;
  @JsonKey(name: 'vendor_product_id')
  final vendorProductId;
  @JsonKey(name: 'vendor_product')
  final VendorProduct vendorProduct;
  @JsonKey(name: 'addon_choices')
  final List addonChoices;

  Product(this.id, this.quantity, this.total, this.subtotal, this.orderId,
      this.vendorProductId, this.vendorProduct, this.addonChoices);

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
